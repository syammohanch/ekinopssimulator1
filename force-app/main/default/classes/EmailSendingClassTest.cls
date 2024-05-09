@isTest
public class EmailSendingClassTest {

    @isTest static void testEmailSplit(){
        List<String> emailList = new List<String>();
        emailList.add('test1@gmail.com,test1@gmail.com');
        emailList.add('test1@gmail.com');
        EmailNotificationCollection.sendEmailList(emailList);
    }
    
    @isTest static void testCaseEmail(){
        List<Case> caseUpdateList = new List<Case>();
    	//Insert Related Account Record
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        //Record Type
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        
        Test.StartTest();
        //Insert Case Record 
        Case caseRecInsert1 = new Case(Subject='Test',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com,test2@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',ProductId=prodRec.Id,AccountId=accRecInsert.Id);
        insert caseRecInsert1;
        List<Id> caseIdList = new List<Id>();
        caseIdList.add(caseRecInsert1.Id);
        GetCaseDetailsAndEmails.sendEmailList(caseIdList);
        Test.StopTest();
    }
    
    
}