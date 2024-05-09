@isTest
public class JiraTicketTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        //create CustomSetting__c
        JIRA_Connect_Settings__c jiraJIRA_Connect_Settings = new JIRA_Connect_Settings__c();
        jiraJIRA_Connect_Settings.One_Ticket_Dev_Authorization__c = 'basic 123456789';
        jiraJIRA_Connect_Settings.One_Ticket_Dev_Endpoint__c = 'https://onetickets-acc.ekinops.com/rest/api/2/issue/';
        jiraJIRA_Connect_Settings.One_Ticket_Prod_Authorization__c = 'basic 123456789';
        jiraJIRA_Connect_Settings.One_Ticket_Prod_Endpoint__c = 'https://onetickets-acc.ekinops.com/rest/api/2/issue/';

        INSERT jiraJIRA_Connect_Settings;
        
        //Create product
        Product2 prod = new Product2(
        Name = 'Product X',
        ProductCode = 'Pro-X',
        isActive = true,
        GroupProductHierarchyLabelL1Pick__c = 'S/W & Services RR',//'H/W Products',
        GroupProductHierarchyLabelL2Pick__c = 'PROFESSIONAL SERVICES RR',//'DWDM - Infrastracture',
        GroupProductHierarchyLabelL3Pick__c = 'Support Contracts RR'//'DWDM OPTICAL ADD/DROP/MUX'
        );
        insert prod;

        // Get Standard Pricebook ID
        Id stdPriceBookRecId = Test.getStandardPricebookId();

        //Create pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
        Pricebook2Id = stdPriceBookRecId,
        Product2Id = prod.Id,
        UnitPrice = 100.00,
        IsActive = true,
        CurrencyIsoCode = 'EUR'
        );
        insert pbEntry;

        List<Account> listAccountToInsert = new List<Account>();
        //Create account for opportunity
        Account accountWithOpp = new Account();
        accountWithOpp.Region__c = 'France';
        accountWithOpp.name = 'TestAccountWithOpp';
        accountWithOpp.SoldTo__c = true;
        listAccountToInsert.add(accountWithOpp);

        //Create account for case
        Account accountWithCase = new Account();
        accountWithCase.name = 'TestAccountWithCase';
        accountWithOpp.Region__c = 'France';
        listAccountToInsert.add(accountWithCase);

        INSERT listAccountToInsert;
        
        //Create RelatedAccount
        RelatedAccount__c relatedAccount = new RelatedAccount__c();
        relatedAccount.SoldToRef__c = listAccountToInsert[1].Id;
        relatedAccount.RelatedAccountRef__c = listAccountToInsert[0].Id;
        relatedAccount.RelatedAccountTypePick__c = 'Final customer';
        
        INSERT relatedAccount;
        
        //Create opportunity
        Opportunity opp = new Opportunity();
        opp.name = 'TestOpportunity';
        opp.CloseDate = Date.today();
        opp.AccountId = accountWithOpp.Id;
        opp.StageName =  'Qualification';
        opp.CurrencyIsoCode = pbEntry.CurrencyIsoCode;
        opp.TechnicalAccountManagerRef__c = UserInfo.getUserId();
        opp.PLM_Ref__c = UserInfo.getUserId();
        INSERT opp;
        
        Case ca = new Case();
        ca.AccountId = accountWithCase.Id;
        ca.Subject = 'Case subject';
        ca.Description = 'Case description';
        ca.ReproductibilityPick__c = 'Always';
        ca.Priority = 'Minor';

        INSERT ca;
    }

    @isTest
    static void afterInsertPRT(){
        Test.setMock(HttpCalloutMock.class, new REST_API_JiraMock());
        List<Case> listCase = [SELECT id FROM Case];

        JiraTicket__c newJiraTicket = new JiraTicket__c();
        newJiraTicket.TypePick__c = 'PRT';
        newJiraTicket.CaseRef__c = listCase[0].Id;
        
        Test.startTest();
        INSERT newJiraTicket;
        Test.stopTest();
        
        List<JiraTicket__c> listJiraTicket = [SELECT id, Last_Jira_Synch_Date__c, Last_Jira_Synch_Message__c, Last_Jira_Synch_Statut__c 
                                                FROM JiraTicket__c];
        System.debug(listJiraTicket[0]);
        System.assert(listJiraTicket[0].Last_Jira_Synch_Statut__c);
    }
    

    @isTest
    static void afterInsertFRT(){
        Test.setMock(HttpCalloutMock.class, new REST_API_JiraMock());
        List<Opportunity> listOpp = [SELECT id FROM Opportunity];

        JiraTicket__c newJiraTicket = new JiraTicket__c();
        newJiraTicket.TypePick__c = 'FRT';
        newJiraTicket.StatusPick__c = 'Go for Quote';
        newJiraTicket.OpportunityRef__c = listOpp[0].Id;
        
        Test.startTest();
        INSERT newJiraTicket;
        newJiraTicket.StatusPick__c = 'Go for dev approved';
        UPDATE newJiraTicket;
        Test.stopTest();
        
        List<JiraTicket__c> listJiraTicket = [SELECT id, Last_Jira_Synch_Date__c, Last_Jira_Synch_Message__c, Last_Jira_Synch_Statut__c 
                                                FROM JiraTicket__c];
        System.debug(listJiraTicket[0]);
        System.assert(listJiraTicket[0].Last_Jira_Synch_Statut__c);
    }

    @isTest
    static void afterInsertSAP_SoldTo(){
        Test.setMock(HttpCalloutMock.class, new REST_API_JiraMock());
        List<Account> listAccount = [SELECT id FROM Account];

        JiraTicket__c newJiraTicket = new JiraTicket__c();
        newJiraTicket.TypePick__c = 'SAP';
        newJiraTicket.AccountRef__c = listAccount[0].Id;
        newJiraTicket.SubtypePick__c = 'Sold to';
        
        //Also test attachment
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        content.Type__c = 'Credit Application Form';
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=listAccount[0].Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        Test.startTest();
        INSERT newJiraTicket;
        Test.stopTest();
        
        List<JiraTicket__c> listJiraTicket = [SELECT id, Last_Jira_Synch_Date__c, Last_Jira_Synch_Message__c, Last_Jira_Synch_Statut__c 
                                                FROM JiraTicket__c];
        System.assert(listJiraTicket[0].Last_Jira_Synch_Statut__c);
    }

    @isTest
    static void afterInsertSAP_NotSoldTo(){
        Test.setMock(HttpCalloutMock.class, new REST_API_JiraMock());
        List<Account> listAccount = [SELECT id FROM Account];

        JiraTicket__c newJiraTicket = new JiraTicket__c();
        newJiraTicket.TypePick__c = 'SAP';
        newJiraTicket.AccountRef__c = listAccount[0].Id;
        newJiraTicket.SubtypePick__c = 'Final customer';
        
        Test.startTest();
        INSERT newJiraTicket;
        Test.stopTest();
        
        List<JiraTicket__c> listJiraTicket = [SELECT id, Last_Jira_Synch_Date__c, Last_Jira_Synch_Message__c, Last_Jira_Synch_Statut__c 
                                                FROM JiraTicket__c];
        System.debug(listJiraTicket[0]);
        System.assert(listJiraTicket[0].Last_Jira_Synch_Statut__c);
    }
}