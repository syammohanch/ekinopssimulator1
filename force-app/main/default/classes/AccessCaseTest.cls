@isTest
public class AccessCaseTest {
    @isTest static void testCaseInsert(){
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
        Case caseRecInsert1 = new Case(Subject='Test',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',ProductId=prodRec.Id,AccountId=accRecInsert.Id);
        insert caseRecInsert1;
        //Case caseRecInsert2 = new Case(Subject='Test',Description='Test',Detailed_Description__c='Test',PrivacyPick__c='Customer',RecordTypeId=strRecordTypeId,AccountId=accRecInsert.Id);
        //insert caseRecInsert2;
        //Case caseRecInsert3 = new Case(Subject='Test',Description='Test',Detailed_Description__c='Test',PrivacyPick__c='Customer',RecordTypeId=strRecordTypeId,AccountId=accRecInsert.Id);
        //insert caseRecInsert3;
        Case caseRecUpdate1 = new Case(id=caseRecInsert1.Id,Subject='Test1');
        update caseRecUpdate1;
        Case caseRecUpdate2 = new Case(id=caseRecInsert1.Id,Description='Test1');
        update caseRecUpdate2;
        Case caseRecUpdate3 = new Case(id=caseRecInsert1.Id,Detailed_Description__c='Test1');
        update caseRecUpdate3;
        Case caseRecUpdate4 = new Case(id=caseRecInsert1.Id,ReproductibilityPick__c='Always');
        update caseRecUpdate4;
        Case caseRecUpdate5 = new Case(id=caseRecInsert1.Id,IsServiceAffectingPick__c='No');
        update caseRecUpdate5;
        Case caseRecUpdate6 = new Case(id=caseRecInsert1.Id,SoftwarePackPick__c='IBC');
        update caseRecUpdate6;
        Case caseRecUpdate7 = new Case(id=caseRecInsert1.Id,SoftwareVersion__c='Test1');
        update caseRecUpdate7;
        Case caseRecUpdate8 = new Case(id=caseRecInsert1.Id,CustomerTicketRef__c='Test1');
        update caseRecUpdate8;
        Case caseRecUpdate9 = new Case(id=caseRecInsert1.Id,EmailNotification__c='test2@gmail.com');
        update caseRecUpdate9;
        Case caseRecUpdate10 = new Case(id=caseRecInsert1.Id,Status='Delivered');
        update caseRecUpdate10;
        Test.stopTest();
    }
	
    
    
}