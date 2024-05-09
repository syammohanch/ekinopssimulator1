@isTest
public class AccessCaseDeliveredAutoClosureTest {
@isTest static void verifyWithValidData(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
        insert  accRec;
        
        Contact conRec = new Contact(AccountId=accRec.Id,LastName='Test Contact',Email='test@ekinops.com');
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
        testCase.Status = 'Delivered';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        testCase.EmailNotification__c = 'test@ekinops.com@ekinops.com,test1@ekinops.com@gmail.com';
        //testCase.OwnerId = accRec.CreatedById;
        insert testCase;
        
    	EkinopsUtilitiesTest.setMetaData('SELECT IsDryRunMode__c, Delivered_Auto_Closure_Duration__c,DryRunModeEmailId__c,Delivered_Auto_Closure_Comment__c FROM AccessCaseAutoClosure__mdt',
                                         (List<AccessCaseAutoClosure__mdt>) JSON.deserialize('[{"IsDryRunMode__c":false,"Delivered_Auto_Closure_Duration__c":0,"DryRunModeEmailId__c":"test@ekinops.com","Delivered_Auto_Closure_Comment__c":"test"}]',List<AccessCaseAutoClosure__mdt>.class));
            
        Test.StartTest(); 
        AccessCaseDeliveredAutoClosure batchInstance = new AccessCaseDeliveredAutoClosure();
		Database.executeBatch(batchInstance);
        Test.StopTest();
    }
}