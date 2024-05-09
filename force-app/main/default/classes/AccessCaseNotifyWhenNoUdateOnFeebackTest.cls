@isTest
public class AccessCaseNotifyWhenNoUdateOnFeebackTest {
	@isTest static void verifyWithValidData(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert  accRec;
         
        Contact conRec = new Contact(AccountId=accRec.Id,LastName='Test Contact',Email='test3@ekinops.com');
        insert  conRec;
        
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        
		String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        testCase.Description = 'Test';
        testCase.PrivacyPick__c = 'Customer';
        testCase.AccountId = accRec.Id;
        testCase.ProductId = prodRec.id;
        testCase.ContactId = conRec.id;
        testCase.Type   = 'Other';
        testCase.Status = 'Waiting customer feedback';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        testCase.EmailNotification__c = 'test@ekinops.com,test2@ekinops.com';
        //testCase.OwnerId = accRec.CreatedById;
        insert testCase;
        
        EkiCustomConfig__c configRec = new EkiCustomConfig__c(Namespace__c = 'AccessCase',Key__c = 'AccessCase:Feedback:NoUpdateNotification:LastProcessedOn',Value__c='2022-08-16 23:59:59');  
        insert configRec;
        
        EkinopsUtilitiesTest.setMetaData('SELECT IsDryRunMode__c, FeedbackNoUpdateDuration__c,PortalURL__c, DryRunModeEmailId__c,FeedbackNoUpdateAddtionalEmail__c FROM AccessCaseAutoClosure__mdt',
                                         (List<AccessCaseAutoClosure__mdt>) JSON.deserialize('[{"IsDryRunMode__c":false,"FeedbackNoUpdateDuration__c":0,"DryRunModeEmailId__c":"test@ekinops.com","FeedbackNoUpdateAddtionalEmail__c":"test@ekinops.com","PortalURL__c":"http://test.com"}]',List<AccessCaseAutoClosure__mdt>.class));
        
        Test.StartTest(); 
        AccessCaseNotifyWhenNoUdateOnFeeback batchInstance = new AccessCaseNotifyWhenNoUdateOnFeeback();
		Database.executeBatch(batchInstance);
        Test.StopTest();
        
    }
}