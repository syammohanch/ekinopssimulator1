@isTest
public class CustomCommentFeederControllerTest {
	@isTest static void testCreateFeedItemRec(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRec;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        testCase.Description = 'Test';
        testCase.Detailed_Description__c = '<p class="ql-indent-5">Test1</p><p class="ql-indent-6">Test1</p><p class="ql-indent-7"><strike>Test1<br>Test2</strike></p><p class="ql-indent-8"><em>Test1</em></p><p class="ql-indent-9">Test1</p><p class="ql-indent-4">Test1</p><p class="ql-indent-3">Test1</p><p class="ql-indent-2">Test1</p><p class="ql-indent-1">Test1</p><strong>Test</strong>';
        testCase.PrivacyPick__c = 'Customer';
        testCase.AccountId = accRec.Id;
        testCase.ProductId = prodRec.id;
        testCase.Type = 'Other';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        insert testCase;
        CustomCommentFeederController.createFeedItemRec(testCase.Id, testCase.Detailed_Description__c);
        
        Case testCase1 = new Case();
        testCase1.RecordTypeId = (Id)strRecordTypeId;
        testCase1.Subject='Test Account record' ;
        testCase1.Description = 'Test';
        testCase1.Detailed_Description__c = 'Test';
        testCase1.PrivacyPick__c = 'Customer';
        testCase1.AccountId = accRec.Id;
        testCase1.ProductId = prodRec.id;
        testCase1.Type = 'Other';
        testCase1.Priority = 'Normal';
        testCase1.DetectionPhasePick__c = 'CSO/FTE';
        insert testCase1;
        CustomCommentFeederController.createFeedItemRec(testCase1.Id, testCase1.Detailed_Description__c);
        
        List<Access_Workflow_Steps__c> accessWorkflowList = new List<Access_Workflow_Steps__c>();
        Access_Workflow_Steps__c accessWorkflowRec = new Access_Workflow_Steps__c();
        accessWorkflowRec.From_Status__c = 'New';
        accessWorkflowRec.To_Status__c = 'Assigned';
        accessWorkflowList.add(accessWorkflowRec);
        Access_Workflow_Steps__c accessWorkflowRec1 = new Access_Workflow_Steps__c();
        accessWorkflowRec1.From_Status__c = 'New';
        accessWorkflowRec1.To_Status__c = 'Assigned';
        accessWorkflowList.add(accessWorkflowRec1);
        insert accessWorkflowList;
        String profileName = 'System Administrator';
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        String profileId = (String)p.id;
        CustomCommentFeederController.getAllowedAccessCaseStatus(profileId, 'New');
    }
}