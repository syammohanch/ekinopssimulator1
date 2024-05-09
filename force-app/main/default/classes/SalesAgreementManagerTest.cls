@isTest
private with sharing class SalesAgreementManagerTest
{
    @TestSetup
    static void makeData()
    {
        TestDataFactory.createAccount();
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        Product2 prod = TestDataFactory.createProduct();
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(stdPriceBookRecId, prod);
        Opportunity opp = TestDataFactory.createOpportunity(UserInfo.getUserId());
        SalesAgreement sa = TestDataFactory.createOrderIntake(opp, pbEntry);
        OpportunityLineItem oliLowerPrice = TestDataFactory.createOpportunityLineItem(opp, pbEntry, 1);
        TestDataFactory.createOpportunityLineItem(opp, pbEntry, 10);
        TestDataFactory.createOrderIntakeProduct(sa, prod, oliLowerPrice);
    }

    @isTest
    private static void testResetProductSchedulesQuantities() 
    {
        ResetProductSchedulesQuantities__e event = new ResetProductSchedulesQuantities__e(
            OrderIntakeId__c = [SELECT Id FROM SalesAgreement LIMIT 1]?.Id
        );

        Test.startTest();
        Database.SaveResult sr = EventBus.publish(event);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess());
        System.assertEquals(0, [
            SELECT Id
            FROM SalesAgreementProductSchedule
            WHERE (UpsideQuantity__c != 0 OR PlannedQuantity != 0)
        ].size(), 'All quantities should be set to zero.');
    }
}