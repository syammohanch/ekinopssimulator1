public class AddQuantitiesAndGetHighestPrice {
    public class FLowInputs {
        @InvocableVariable(required=true) public String InputOpportunityId; 
    }
    @InvocableMethod
    
    // Invocable method (usable in flows) with input = opportunityID and output = List of ApexDefinedVariableOpportunityLineItem
    // We use an Apex Defined Variable because Salesforce prevents manipulation of PricebookEntryId and OpportunityId in a List of Opportunity Line Items
    // the purpose is to transform a list of opportunity line items into a list of opportunity line items with unique pricebook entries and the sum of quantities and the maximum unit price by product
    public static List<List<ApexDefinedVariableOpportunityLineItem>> ProcessOpportunityLineItems(List<FlowInputs> input) {
        String InputOpportunityId = input[0].InputOpportunityId;
        List<ApexDefinedVariableOpportunityLineItem> APEXOLIList = new List<ApexDefinedVariableOpportunityLineItem>();
        List<OpportunityLineItem> OLIList = new List<OpportunityLineItem>();
        List<OpportunityLineItem> newOLIList = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oldOLIList = new List<OpportunityLineItem>();
        List<String> pbEntriesId = new List<String>();
        List<List<ApexDefinedVariableOpportunityLineItem>> APEXOLIListList = new List<List<ApexDefinedVariableOpportunityLineItem>>();
        Integer i = 0;
        
        // query of all the opportunity line items stored in a list
        oldOLIList = [select Id, OpportunityId, PricebookEntryId, Quantity, UnitPrice, SBQQ__QuoteLine__c, SBQQ__SubscriptionType__c, TECH_Product__c from OpportunityLineItem WHERE OpportunityId = :InputOpportunityId ORDER BY UnitPrice desc];
        
        // Use of an aggregate query of all the opportunity line items to sum the quantities and the max unit price grouped by product
        AggregateResult[] groupedResults = [SELECT PricebookEntryId,TECH_Product__c, SUM(Quantity), MAX(UnitPrice) FROM OpportunityLineItem WHERE OpportunityId = :InputOpportunityId GROUP BY PricebookEntryId,TECH_Product__c];
        for (AggregateResult agg : groupedResults) {
			OpportunityLineItem OLI = new OpportunityLineItem(PricebookEntryId = (String) agg.get('PriceBookEntryId'));
            OLI.UnitPrice = (Decimal) agg.get('expr1');
            OLI.Quantity = (Decimal) agg.get('expr0');
            // the datatable component requires an Id, even it's fake so since we're working with aggregates, I generate fake IDs
            OLI.Id = '00k1x000007N41hAA' + string.valueOf(i);
            OLI.TECH_Product__c = (String) agg.get('TECH_Product__c');
            OLIList.add(OLI);
            i=i+1;
        }
        for (OpportunityLineItem oldOLI : oldOLIList) {
            for(OpportunityLineItem newOLI : OLIList) {
                // I use this list of string with pricebook entries so that when we loop a second time on a product, we skip to the next opportunity line item
                IF(pbEntriesId.contains(oldOLI.PricebookEntryId)) {
                    	continue;
                }
                // when we loop on both opportunity line items and find the same pricebook entry, we copy field values so that we keep the values of the opportunity line item with the highest unit price
                // we have to use this because we lose field values with the aggregate query
                IF(newOLI.PricebookEntryId == oldOLI.PricebookEntryId) {
                    ApexDefinedVariableOpportunityLineItem APEXOLI = new ApexDefinedVariableOpportunityLineItem();
                    APEXOLI.Id = oldOLI.Id;
                    APEXOLI.UnitPrice = newOLI.UnitPrice;
                    APEXOLI.Quantity = newOLI.Quantity;
                    APEXOLI.TECH_Product = oldOLI.TECH_Product__c;
                    APEXOLI.OpportunityId = oldOLI.OpportunityId;
                    APEXOLI.QuoteLine = oldOLI.SBQQ__QuoteLine__c;
                    APEXOLI.SubscriptionType = oldOLI.SBQQ__SubscriptionType__c;
                    APEXOLI.PricebookEntryId = oldOLI.PricebookEntryId;
                    pbEntriesId.add(newOLI.PricebookEntryId);
                    APEXOLIList.add(APEXOLI);   
                }
            }
        }      
        APEXOLIListList.add(APEXOLIList);
    	return APEXOLIListList;
    }
}