@isTest
public class CaseRedirectTest {
    
    @isTest static void verifyCaseUpdateAccess(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRec;
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
        testCase.Type = 'Other';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        insert testCase;
        
        
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirectEdit testAccPlan = new CaseRedirectEdit(sc);
        testAccPlan.Redirectedit();
        Test.StopTest();
    }
    
    @isTest static void verifyCaseUpdateTransport(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRec;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Transport'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        testCase.Description = 'Test';
        testCase.PrivacyPick__c = 'Customer';
        testCase.AccountId = accRec.Id;
        testCase.ProductId = prodRec.id;
        testCase.Type = 'Other';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        insert testCase;
        
        
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Transport');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirectEdit testAccPlan = new CaseRedirectEdit(sc);
        testAccPlan.Redirectedit();
        Test.StopTest();
    }
    
    @isTest static void verifyCaseSaveAccess(){
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseCreation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirect testAccPlan = new CaseRedirect(sc);
        testAccPlan.Redirect();
        Test.StopTest();
    }
    
    @isTest static void verifyCasedoCustomValidations(){
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        testCase.EmailNotification__c='test1@test.com,test2@test.com' ;
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseCreation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirect testAccPlan = new CaseRedirect(sc);
        testAccPlan.doCustomValidations();
        Test.StopTest();
    }
    
    @isTest static void verifyCasedoCustomValidationsInvalid(){
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Access'].Id;
        Case testCase = new Case();
        testCase.RecordTypeId = (Id)strRecordTypeId;
        testCase.Subject='Test Account record' ;
        testCase.EmailNotification__c='test1@test.com,@test.com' ;
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseCreation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirect testAccPlan = new CaseRedirect(sc);
        testAccPlan.doCustomValidations();
        Test.StopTest();
    }
    
    @isTest static void verifyCaseSaveNonAccess(){
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Case' and DeveloperName = 'Transport'].Id;
        Case testCase1 = new Case();
        testCase1.RecordTypeId = (Id)strRecordTypeId1;
        testCase1.Subject='Test Account record1' ;
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseCreation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase1.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId1);
        pageRef.getParameters().put('selectedRecTypeName','Transport');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase1);
        CaseRedirect testAccPlan = new CaseRedirect(sc);
        testAccPlan.Redirect();
        Test.StopTest();
    }
    
    @isTest static void verifyCaseEditdoCustomValidations(){
        
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRec;
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
        testCase.Type = 'Other';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        testCase.EmailNotification__c='test1@test.com,test2@test.com' ;
        insert testCase;
                
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirectEdit testAccPlan = new CaseRedirectEdit(sc);
        testAccPlan.doCustomValidations();
        Test.StopTest();
    }
    
    @isTest static void verifyCaseEditdoCustomValidationsInvalid(){
        Account accRec = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRec;
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
        testCase.Type = 'Other';
        testCase.Priority = 'Normal';
        testCase.DetectionPhasePick__c = 'CSO/FTE';
        testCase.EmailNotification__c='@test.com,test2@test.com' ;
        insert testCase;
                
        Test.StartTest(); 
        PageReference pageRef = Page.AccessCaseUpdate;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(testCase.Id));
        pageRef.getParameters().put('RecordType',(Id)strRecordTypeId);
        pageRef.getParameters().put('selectedRecTypeName','Access');
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        CaseRedirectEdit testAccPlan = new CaseRedirectEdit(sc);
        testAccPlan.doCustomValidations();
        Test.StopTest();
    }
    
}