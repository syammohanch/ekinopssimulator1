@isTest
public class AccessCaseBatchApexTest {
    
    @isTest static void testCaseInsert(){
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        sfidAndJira.put(accessCaseCustRec11.Id,'Case,'+'SAC-100,'+'1234,Insert');
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(201)); 
        //Test.setMock(HttpCalloutMock.class, new BatchSyncMock(204)); 
        Test.startTest();
        AccessCaseBatchApex obj = new AccessCaseBatchApex();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest static void testCaseUpdate(){
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Case caseRecInsert12 = new Case(Id=caseRecInsert11.id,Subject='Test23');
        update caseRecInsert12;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        sfidAndJira.put(accessCaseCustRec11.Id,'Case,'+'SAC-100,'+'1234,Update');
        //Test.setMock(HttpCalloutMock.class, new BatchSyncMock(201)); 
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(204)); 
        Test.startTest();
        AccessCaseBatchApex obj = new AccessCaseBatchApex();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest static void testStatusUpdate(){
        System.debug('Iniside UPDATE ###');
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Case caseRecInsert12 = new Case(Id=caseRecInsert11.id,Status='Delivered');
        update caseRecInsert12;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Status',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='Case',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        sfidAndJira.put(accessCaseCustRec11.Id,'Status,'+'SAC-100,'+'1234,Update');
        //Test.setMock(HttpCalloutMock.class, new BatchSyncMock(201)); 
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(204)); 
        Test.startTest();
        AccessCaseBatchApex obj = new AccessCaseBatchApex();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest static void testCommentInsert(){
        System.debug('Iniside UPDATE ###');
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Comment',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='Case',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        
        FeedItem feed = new FeedItem (parentid = caseRecInsert11.id,type = 'ContentPost',Body = 'Hello');
		insert feed ;
        
        sfidAndJira.put(accessCaseCustRec11.Id,'Comment,'+'SAC-100,'+'1234,Insert');
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(201)); 
        //Test.setMock(HttpCalloutMock.class, new BatchSyncMock(204)); 
        Test.startTest();
        AccessCaseBatchApex obj = new AccessCaseBatchApex();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest static void testCommentUpdate(){
        System.debug('Iniside UPDATE ###');
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='Case',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        
        FeedItem feed = new FeedItem (parentid = caseRecInsert11.id,type = 'ContentPost',Body = 'Hello');
		insert feed ;
        Access_Case__c accessCaseCommentCustRec11 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Comment',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCommentCustRec11;
        Access_Case_Tracker__c accesCaseCommentTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='Case',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseCommentTracker11;
        FeedItem feed1 = new FeedItem (Id=feed.Id,Body = 'Hello 123');
		update feed1 ;
        Access_Case__c accessCaseCustRec22 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Comment',SF_Type_Object_Id__c=String.valueOf(feed.Id),Status__c='Queued');
        insert accessCaseCustRec22;
        Access_Case_Tracker__c accesCaseTracker22 = new Access_Case_Tracker__c(SF_Type_Object__c='Comment',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(feed.Id));
        insert accesCaseTracker22;
        
        sfidAndJira.put(accessCaseCustRec22.Id,'Comment,'+'SAC-100,'+'1234,Update');
        
        
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(200)); 
        Test.startTest();
        AccessCaseBatchApex obj1 = new AccessCaseBatchApex();
        DataBase.executeBatch(obj1); 
        Test.stopTest();
    }
    
    @isTest static void testCommentRepInsert(){
        System.debug('Iniside INSERT REP ###');
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='Case',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        
        FeedItem feed = new FeedItem (parentid = caseRecInsert11.id,type = 'ContentPost',Body = 'Hello');
		insert feed ;
        
        FeedComment fc = new FeedComment(FeedItemId = feed.Id, CommentBody = 'Test Comment');
		insert fc;
        
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(201)); 
        Test.startTest();
        AccessCaseBatchApex obj1 = new AccessCaseBatchApex();
        DataBase.executeBatch(obj1); 
        Test.stopTest();
        
    }
    
    @isTest static void testCommentRepUpdate(){
        System.debug('Iniside Update REP ###');
        Map<Id,String> sfidAndJira = new Map<Id,String>();
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Hardware',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        Access_Case__c accessCaseCustRec11 = new Access_Case__c(Action__c='Update',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id),Status__c='Queued');
        insert accessCaseCustRec11;
        Access_Case_Tracker__c accesCaseTracker11 = new Access_Case_Tracker__c(SF_Type_Object__c='CommentRep',OTK_Issue_Key__c='SAC-100',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object_Id__c=String.valueOf(caseRecInsert11.Id));
        insert accesCaseTracker11;
        
        FeedItem feed = new FeedItem (parentid = caseRecInsert11.id,type = 'ContentPost',Body = 'Hello');
		insert feed ;
        
        FeedComment fc = new FeedComment(FeedItemId = feed.Id, CommentBody = 'Test Comment');
		insert fc;
        
        FeedComment fc1 = new FeedComment(Id=fc.Id,CommentBody = 'Test Comment 123');
		update fc;
        
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(200)); 
        Test.startTest();
        AccessCaseBatchApex obj1 = new AccessCaseBatchApex();
        DataBase.executeBatch(obj1); 
        Test.stopTest();
        
    }
    
	@isTest static void testCaseInsertion(){
        Account accRecInsert = new Account(Name = 'Test',AccountStatusPick__c = 'Active',Primary_region__c = 'Americas');
        insert accRecInsert;
        Account accRecUpdate = new Account(Name='Account',AccountStatusPick__c='Active',Primary_region__c='Americas');
    	insert accRecUpdate;
        Product2 prodRec = new Product2(Name='Test',GroupProductHierarchyLabelL1Pick__c='H/W PRODUCTS',GroupProductHierarchyLabelL2Pick__c='EAD',GroupProductHierarchyLabelL3Pick__c='1222');
        insert prodRec;
        
        Case caseRecInsert08 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Major',Type='Hardware',AccountId=accRecInsert.Id); //ProductId=prodRec.Id,
        insert caseRecInsert08;
        Case caseRecInsert09 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Minor',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert09;
        Case caseRecInsert10 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Critical',Type='Documentation',AccountId=accRecInsert.Id);
        insert caseRecInsert10;
        Case caseRecInsert11 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Configuration request',AccountId=accRecInsert.Id);
        insert caseRecInsert11;
        
        
        //FeedItem feed = new FeedItem (parentid = caseRecInsert11.id,type = 'ContentPost',Body = 'Hello');
		//insert feed ; 
        
        //Access_Case__c accessCaseCustRec111 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert11.Id),Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Comment',SF_Type_Object_Id__c=String.valueOf(feed.Id),Status__c='Queued');
        //insert accessCaseCustRec111;
        //Access_Case_Tracker__c accesCaseTracker1111 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-101',OTK_Object_Id__c='12345',Salesforce_Case_Number__c=caseRecInsert11.CaseNumber,SF_Type_Object__c='Comment',SF_Type_Object_Id__c=String.valueOf(feed.Id));
        //insert accesCaseTracker1111;
        
        
        Case caseRecInsert12 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Documentation',AccountId=accRecInsert.Id);
        insert caseRecInsert12;
        Access_Case__c accessCaseCustRec12 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert12.Id),Salesforce_Case_Number__c=caseRecInsert12.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert12.Id),Status__c='Queued');
        insert accessCaseCustRec12;
        Access_Case_Tracker__c accesCaseTracker12 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-101',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert12.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert12.Id));
        insert accesCaseTracker12;
        
        Case caseRecInsert13 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Configuration request',AccountId=accRecInsert.Id);
        insert caseRecInsert13;
        Access_Case__c accessCaseCustRec13 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert13.Id),Salesforce_Case_Number__c=caseRecInsert13.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert13.Id),Status__c='Queued');
        insert accessCaseCustRec13;
        Access_Case_Tracker__c accesCaseTracker13 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-102',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert13.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert13.Id));
        insert accesCaseTracker13;
        
        Case caseRecInsert14 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Project tracking',AccountId=accRecInsert.Id);
        insert caseRecInsert14;
        Access_Case__c accessCaseCustRec14 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert14.Id),Salesforce_Case_Number__c=caseRecInsert14.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert14.Id),Status__c='Queued');
        insert accessCaseCustRec14;
        Access_Case_Tracker__c accesCaseTracker14 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-103',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert14.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert14.Id));
        insert accesCaseTracker14;
        
        Case caseRecInsert15 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='CSO/FTE',Priority='Normal',Type='Software delivery',AccountId=accRecInsert.Id);
        insert caseRecInsert15;
        Access_Case__c accessCaseCustRec15 = new Access_Case__c(Action__c='Insert',Case_Id__c=String.valueOf(caseRecInsert15.Id),Salesforce_Case_Number__c=caseRecInsert15.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert15.Id),Status__c='Queued');
        insert accessCaseCustRec15;
        Access_Case_Tracker__c accesCaseTracker15 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-104',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert15.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert15.Id));
        insert accesCaseTracker15;
        
        Case caseRecInsert1 = new Case(Subject='Test 1',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert1;
        Access_Case_Tracker__c accesCaseTracker1 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-105',OTK_Object_Id__c='1234',Salesforce_Case_Number__c=caseRecInsert1.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert1.Id));
        insert accesCaseTracker1;
        
        
        Case caseRecInsert2 = new Case(Subject='Test 2',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert2;
        Access_Case_Tracker__c accesCaseTracker2 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-106',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert2.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert2.Id));
        insert accesCaseTracker2;
        
        Case caseRecInsert3 = new Case(Subject='Test 3',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert3;
        Access_Case_Tracker__c accesCaseTracker3 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-107',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert3.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert3.Id));
        insert accesCaseTracker3;
        
        Case caseRecInsert4 = new Case(Subject='Test 4',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert4;
        Access_Case_Tracker__c accesCaseTracker4 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-108',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert4.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert4.Id));
        insert accesCaseTracker4;
        
        Case caseRecInsert5 = new Case(Subject='Test 5',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert5;
        Access_Case_Tracker__c accesCaseTracker5 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-109',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert5.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert5.Id));
        insert accesCaseTracker5;
        
        Case caseRecInsert6 = new Case(Subject='Test 6',Description='Test',Detailed_Description__c='Test',ReproductibilityPick__c='Random',IsServiceAffectingPick__c='Yes',SoftwarePackPick__c='H323',SoftwareVersion__c='Test 123',CustomerTicketRef__c='Test 123',RequestedDate__c=System.now(),EmailNotification__c='test1@gmail.com',DetectionPhasePick__c='Customer Live Network',Priority='Normal',Type='Software',AccountId=accRecInsert.Id);
        insert caseRecInsert6;
        Access_Case_Tracker__c accesCaseTracker6 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-110',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert6.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert6.Id));
        insert accesCaseTracker6;
        
        //Access_Case_Tracker__c accesCaseTracker7 = new Access_Case_Tracker__c(OTK_Issue_Key__c='SAC-111',OTK_Object_Id__c='1235',Salesforce_Case_Number__c=caseRecInsert7.CaseNumber,SF_Type_Object__c='Case',SF_Type_Object_Id__c=String.valueOf(caseRecInsert7.Id));
        //insert accesCaseTracker7;
        //Case caseRecUpdate1 = new Case(Id=caseRecInsert1.Id,Subject='Test 2');
        //update caseRecUpdate1;
        //Case caseRecUpdate2 = new Case(Id=caseRecInsert1.Id,Status='Delivered');
        //update caseRecUpdate2;
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock(200)); 
        Test.startTest();
        AccessCaseBatchApex obj1 = new AccessCaseBatchApex();
        DataBase.executeBatch(obj1); 
        Test.stopTest();        
    }
}