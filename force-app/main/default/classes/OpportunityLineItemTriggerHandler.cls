/**
 * Created by vladPersistent on 03.05.2023.
 */

public with sharing class OpportunityLineItemTriggerHandler {

    public static void updateSalesAgreementProductsWhenOLIPriceIsInserted(Map<Id, OpportunityLineItem> opportunityLineItemsMap) {

        Map<Id, List<OpportunityLineItem>> selectedOpportunityLineItemsByOppId = new Map<Id, List<OpportunityLineItem>>();
        //map the opportunity with the opportunity line items that have been changed
        for(Id opportunityLineItemId : opportunityLineItemsMap.keySet()) {
            if(selectedOpportunityLineItemsByOppId.containsKey(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId)){
                selectedOpportunityLineItemsByOppId.get(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId)
                        .add(opportunityLineItemsMap.get(opportunityLineItemId));
            }else{
                selectedOpportunityLineItemsByOppId.put(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId,
                        new List<OpportunityLineItem>{opportunityLineItemsMap.get(opportunityLineItemId)});
            }
        }
        List<SalesAgreementProduct> salesAgreementProductsToUpdate = getSalesAgreementProductsForUpdate(selectedOpportunityLineItemsByOppId);
        updateSalesAgreementProducts(salesAgreementProductsToUpdate);
    }

    public static void updateSalesAgreementProductsWhenOLIPriceIsUpdated(Map<Id, OpportunityLineItem> opportunityLineItemsMap,
                                                                         Map<Id, OpportunityLineItem> oldOpportunityLineItemsMap) {

        Map<Id, List<OpportunityLineItem>> selectedOpportunityLineItemsByOppId = new Map<Id, List<OpportunityLineItem>>();
        List<SalesAgreementProduct> salesAgreementProductsToUpdate = new List<SalesAgreementProduct>();
        //map the opportunity with the opportunity line items that have been changed
        for(Id opportunityLineItemId : opportunityLineItemsMap.keySet()) {
            if (opportunityLineItemsMap.get(opportunityLineItemId).UnitPrice != oldOpportunityLineItemsMap.get(opportunityLineItemId).UnitPrice) {
                if(selectedOpportunityLineItemsByOppId.containsKey(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId)){
                    selectedOpportunityLineItemsByOppId.get(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId)
                            .add(opportunityLineItemsMap.get(opportunityLineItemId));
                }else{
                    selectedOpportunityLineItemsByOppId.put(opportunityLineItemsMap.get(opportunityLineItemId).OpportunityId,
                                                            new List<OpportunityLineItem>{opportunityLineItemsMap.get(opportunityLineItemId)});
                }
            }
        }
        salesAgreementProductsToUpdate = getSalesAgreementProductsForUpdate(selectedOpportunityLineItemsByOppId);
        updateSalesAgreementProducts(salesAgreementProductsToUpdate);
    }

    public static void updateSalesAgreementProductsWhenPrimaryQuoteIsChanged(Map<Id, OpportunityLineItem> oldMap) {

        Set<Id> productIds = new Set<Id>();
        List<SalesAgreementProduct> salesAgreementProductsToDelete = new List<SalesAgreementProduct>();
        Map<Id, SalesAgreementProduct> salesAgreementProductsToUpdate = new Map<Id, SalesAgreementProduct>();

        for(OpportunityLineItem oli : oldMap.values()){
            productIds.add(oli.Product2Id);
        }
        List<OpportunityLineItem> newOpportunityLineItems = OpportunityLineItemTriggerSelector.getOpportunityLineItemsByOppIdAndProductIds(oldMap.values()[0].OpportunityId, productIds);
        Map<Id, OpportunityLineItem> newOpportunityLineItemsByProductId = clearDuplicatesByProductId(newOpportunityLineItems);
        List<SalesAgreementProduct> salesAgreementProducts = OpportunityLineItemTriggerSelector.getSalesAgreementProductsWithoutOppProductByOppId(oldMap.values()[0].OpportunityId);

        for(SalesAgreementProduct salesAgreementProduct : salesAgreementProducts){
            if(newOpportunityLineItemsByProductId.containsKey(salesAgreementProduct.ProductId)) {
                salesAgreementProduct.Opportunity_Product__c = newOpportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).Id;
                salesAgreementProduct.SalesPrice = newOpportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).UnitPrice;
                salesAgreementProductsToUpdate.put(salesAgreementProduct.Id, salesAgreementProduct);
            }else{
                salesAgreementProductsToDelete.add(salesAgreementProduct);
            }
        }
        updateSalesAgreementProducts(salesAgreementProductsToUpdate.values());
        deleteSalesAgreementProducts(salesAgreementProductsToDelete);
    }

    public static List<SalesAgreementProduct> getSalesAgreementProductsForUpdate(Map<Id, List<OpportunityLineItem>> selectedOpportunityLineItemsByOppId){
        List<SalesAgreementProduct> salesAgreementProductsForUpdate = new List<SalesAgreementProduct>();
        if(selectedOpportunityLineItemsByOppId.size() == 1) {
            Id opportunityId = selectedOpportunityLineItemsByOppId.keySet().iterator().next();
            if (!selectedOpportunityLineItemsByOppId.get(opportunityId).isEmpty()) {
                //get all the opportunity line items for the opportunity (old, new and updated)
                List<OpportunityLineItem> opportunityLineItems = OpportunityLineItemTriggerSelector.getOpportunityLineItemsByOppId(opportunityId);
                //in case of multiple opportunity line items with the same product, keep only the one with the lowest price
                Map<Id, OpportunityLineItem> opportunityLineItemsByProductId = clearDuplicatesByProductId(opportunityLineItems);
                //get all the sales agreement products for based on the opportunity line items product ids
                List<SalesAgreementProduct> salesAgreementProducts = OpportunityLineItemTriggerSelector.getSalesAgreementProductsByOppId(
                        opportunityLineItemsByProductId.keySet(),
                        opportunityId);

                for (SalesAgreementProduct salesAgreementProduct : salesAgreementProducts) {
                    //inserted opportunity line item with lower price than the existing ones scenario
                    //updated opportunity line item from a price bigger than the lowest one to a lower one scenario
                    //updated opportunity line item from the lowest price to a bigger price than the lowest one scenario
                    if (salesAgreementProduct.Opportunity_Product__c != opportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).Id) {
                        salesAgreementProduct.Opportunity_Product__c = opportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).Id;
                        salesAgreementProduct.SalesPrice = opportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).UnitPrice;
                        salesAgreementProductsForUpdate.add(salesAgreementProduct);
                    }else if(salesAgreementProduct.SalesPrice != opportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).UnitPrice){
                        //updated opportunity line item with a new price scenario
                        salesAgreementProduct.SalesPrice = opportunityLineItemsByProductId.get(salesAgreementProduct.ProductId).UnitPrice;
                        salesAgreementProductsForUpdate.add(salesAgreementProduct);
                    }
                }
            }
        }
        return salesAgreementProductsForUpdate;
    }

    public static Map<Id, OpportunityLineItem> clearDuplicatesByProductId (List<OpportunityLineItem> opportunityLineItems){
        Map<Id, OpportunityLineItem> opportunityLineItemsByProductId = new Map<Id, OpportunityLineItem>();
        for(OpportunityLineItem opportunityLineItem : opportunityLineItems){
            if(opportunityLineItemsByProductId.containsKey(opportunityLineItem.Product2Id)){
                if(opportunityLineItemsByProductId.get(opportunityLineItem.Product2Id).UnitPrice > opportunityLineItem.UnitPrice){
                    opportunityLineItemsByProductId.put(opportunityLineItem.Product2Id, opportunityLineItem);
                }
            }else{
                opportunityLineItemsByProductId.put(opportunityLineItem.Product2Id, opportunityLineItem);
            }
        }
        return opportunityLineItemsByProductId;
    }

    public static void updateSalesAgreementProducts(List<SalesAgreementProduct> salesAgreementProducts){
        try{
            update salesAgreementProducts;
        } catch (Exception e){
            sendEmailToRunningUser(e.getMessage(), 'updating');
        }
    }

    public static void deleteSalesAgreementProducts(List<SalesAgreementProduct> salesAgreementProducts){
        try{
            delete salesAgreementProducts;
        } catch (Exception e){
            sendEmailToRunningUser(e.getMessage(), 'deleting');
        }
    }

    public static void sendEmailToRunningUser(String errorFromSystem, String operationName) {
        String errorMessage = 'Dear User,\n\n';
        errorMessage += 'I would like to inform you that an error occurred while ';
        errorMessage += operationName;
        errorMessage += ' order intake products ';
        errorMessage += '(OpportunityLineItemTriggerHandler.deleteSalesAgreementProducts): ';
        errorMessage += errorFromSystem + ': ';
        errorMessage += Datetime.now();

        Pattern pattern = Pattern.compile('(?<=with id )[a-zA-Z0-9]+');
        Matcher matcher = pattern.matcher(errorMessage);
        if (matcher.find()) {
            errorMessage += '\n\nPlease check the records by opening the following links : ';
            errorMessage += '\n\n' + Url.getSalesforceBaseUrl().toExternalForm() + '/' + matcher.group(0);
        }

        errorMessage += '\n\nThank you,';
        errorMessage += '\nAutomated Salesforce User';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String> {UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(getCCAddresses());
        mail.setSubject('Error on order intake products');
        mail.setPlainTextBody(errorMessage);
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    private static List<String> getCCAddresses(){
        List<String> ccAddresses = new List<String>();
        Email_Address__mdt emailAddresses;
        if(!Test.isRunningTest()){
            emailAddresses = Email_Address__mdt.getInstance('Order_Intake_Products_Error');
        }else{
            emailAddresses = new Email_Address__mdt();
            emailAddresses.Email_Address__c = 'test@test.com';
        }
        if(emailAddresses != null){
            ccAddresses.addAll(emailAddresses.Email_Address__c.split(';'));
        }
        return ccAddresses;
    }
}