@isTest
private class ApprovalProcessManagerTest {

    @isTest
    static void testApproveOrRejectAll() {
        // Créer des données de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        acc.RegionalManagerRef__c = UserInfo.getUserId();
        acc.SalesDirectorRef__c = UserInfo.getUserId();
        update acc;
        User u = TestDataFactory.createDirectionSalesUser();
        TestDataFactory.createAccount();
        Opportunity opp = TestDataFactory.createOpportunity(u);
        opp.TechnicalAccountManagerRef__c = UserInfo.getUserId();
        opp.PLM_Ref__c = UserInfo.getUserId();        
        update opp;
        JiraTicket__c ticket = new JiraTicket__c(
            TypePick__c = 'FRT',
            OpportunityRef__c = opp.Id,
            StatusPick__c = 'Go for quote requested'
        );
        insert ticket;
        Request__c request = [SELECT Id FROM Request__c WHERE JiraTicketRef__c = :ticket.Id LIMIT 1];
        request.TAMRef__c = UserInfo.getUserId();
        update request;

        // Créer des entrées pour la classe InvocableMethod
        ApprovalProcessManager.Inputs input = new ApprovalProcessManager.Inputs();
        input.requestId = request.Id;
        input.choice = 'Approve';
        input.comment = 'Test Comment';

        List<ApprovalProcessManager.Inputs> inputList = new List<ApprovalProcessManager.Inputs>();
        inputList.add(input);

        // Appeler la méthode à tester
        Test.startTest();
        List<String> resultList = ApprovalProcessManager.approveOrRejectAll(inputList);
        Test.stopTest();

        // Vérifier le résultat
        System.assertEquals(0, resultList.size(), 'Expected zero result');
        //System.assertNotEquals(null, resultList[0], 'Result should not be null');
    }
}