@isTest
private with sharing class CustomSharingBatchTest {
    
    @isTest
    private static void testScheduleBatch() 
    {        
        User u = TestDataFactory.createDirectionSalesUser();
        TestDataFactory.createAccount();
        Opportunity opp = TestDataFactory.createOpportunity(u);
        Request__c req = TestDataFactory.createRequest(opp);

        Test.startTest();
        DateTime scheduleDateTime = System.now().addSeconds(3);
        Database.executeBatch(new CustomSharingCreateBatch('Opportunity', ConstantManager.SHARING_SETTING_BY_OBJECT.get('Opportunity')));
        System.schedule(
            'TestCustomSharingBatch | ' + scheduleDateTime.format('yyyy-MM-dd HH:mm:ss'),
            scheduleDateTime.format('ss mm HH dd MM ? yyyy'),
            new CustomSharingBatch()
        );
        Test.stopTest();
    }
    
    @isTest
    private static void testScheduleExtraBatch() 
    {
        User u = TestDataFactory.createDirectionSalesUser();
        TestDataFactory.createAccount();
        Opportunity opp = TestDataFactory.createOpportunity(u);
        Request__c req = TestDataFactory.createRequest(opp);
        Test.startTest();
        DateTime scheduleDateTime = System.now().addSeconds(3);
        System.schedule(
            'TestCustomSharingExtraBatch | ' + scheduleDateTime.format('yyyy-MM-dd HH:mm:ss'),
            scheduleDateTime.format('ss mm HH dd MM ? yyyy'),
            new CustomSharingForRequestBatch()
        );
        Test.stopTest();
    }
}