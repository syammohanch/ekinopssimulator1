@isTest
private class UpdateCMDTest {

    @TestSetup
    static void createTestData() {
        
    }
    
    @isTest
    static void testUpdateCMD() {
        
        List<Exchange_Rate__mdt> listRate = new List<Exchange_Rate__mdt>();
        Exchange_Rate__mdt EURRate = new Exchange_Rate__mdt(DeveloperName = 'EUR', Exchange_Rate__c = 1);
        Exchange_Rate__mdt USDRate = new Exchange_Rate__mdt(Label = 'USD', Exchange_Rate__c = 1);
        listRate.add(EURRate);
        listRate.add(USDRate);
        
        UpdateCMD.ActionRequest req = new UpdateCMD.ActionRequest();
        req.data = listRate;
        List<UpdateCMD.ActionRequest> listReq = new List<UpdateCMD.ActionRequest>();
        listReq.Add(req);
        Test.startTest();
        UpdateCMD.invokeService(listReq);
        Test.stopTest();
    }
      
}