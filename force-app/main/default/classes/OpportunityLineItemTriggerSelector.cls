/**
 * Created by vladPersistent on 10.05.2023.
 */

public with sharing class OpportunityLineItemTriggerSelector {

    public static List<OpportunityLineItem> getOpportunityLineItemsByOppId(Id opportunityId) {
        return [SELECT Id
                        , Product2Id
                        , UnitPrice
                        , OpportunityId
                FROM OpportunityLineItem
                WHERE OpportunityId = :opportunityId];
    }

    public static List<OpportunityLineItem> getOpportunityLineItemsByOppIdAndProductIds(Id opporttunityId, Set<Id> productIds) {
        return [SELECT Id
                        , Product2Id
                        , UnitPrice
                        , OpportunityId
                FROM OpportunityLineItem
                WHERE OpportunityId =: opporttunityId
                AND Product2Id IN: productIds];
    }

    public static List<SalesAgreementProduct> getSalesAgreementProductsByOppId(Set<Id> productIds, Id opportunityId) {
        return [SELECT Id
                        , ProductId
                        , SalesPrice
                        , Opportunity__c
                        , Opportunity_Product__c
                FROM SalesAgreementProduct
                WHERE ProductId IN: productIds
                AND Opportunity__c = :opportunityId
                AND SalesAgreement.Status = 'Draft'];
    }

    public static List<SalesAgreementProduct> getSalesAgreementProductsWithoutOppProductByOppId(Id opportunityId) {
        return [SELECT Id
                        , ProductId
                        , SalesPrice
                        , Opportunity_Product__c
                        , SalesAgreement.Status
                FROM SalesAgreementProduct
                WHERE Opportunity_Product__c = NULL
                AND Opportunity__c = :opportunityId
                AND SalesAgreement.Status = 'Draft'];
    }

}