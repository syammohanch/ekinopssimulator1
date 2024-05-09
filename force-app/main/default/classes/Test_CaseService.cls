@IsTest
class Test_CaseService {

	@TestSetup
    static void initData() {
        Account accountWithCase = new Account();
        accountWithCase.Name = 'TestAccountWithCase';
        accountWithCase.Region__c = 'France';

        insert accountWithCase;

        Case existingCase = new Case();
        existingCase.AccountId = accountWithCase.Id;
        existingCase.Subject = 'Test Case';
        existingCase.Description = 'Some description here';
        existingCase.ReproductibilityPick__c = 'Always';

        insert existingCase;
    }

    @IsTest
    static void insertCase_OneCaseExisted_CaseRmaNumberTwo() {
        Account caseAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountWithCase'];

        Case newCase1 = new Case();
        newCase1.AccountId = caseAccount.Id;
        newCase1.Subject = 'Test Case 2';
        newCase1.Description = 'Some description here 2';
        newCase1.ReproductibilityPick__c = 'Always';

        Case newCase2 = new Case();
        newCase2.AccountId = caseAccount.Id;
        newCase2.Subject = 'Test Case 3';
        newCase2.Description = 'Some description here 3';
        newCase2.ReproductibilityPick__c = 'Always';

        List<Case> newCases = new List<Case> { newCase1, newCase2 };

        Test.startTest();
        insert newCases;
        Test.stopTest();

        newCases = [SELECT DailyRMATransportNumber__c FROM Case WHERE Id IN :newCases];

        System.assertEquals(2, newCases[0].DailyRMATransportNumber__c);
        System.assertEquals(3, newCases[1].DailyRMATransportNumber__c);
    }

    @IsTest
    static void insertCase_NoCaseExistedToday_CaseRmaNumberOne() {
        Account caseAccount = [SELECT Id FROM Account WHERE Name = 'TestAccountWithCase'];

        Case existingCase = [SELECT Id FROM Case WHERE AccountId = :caseAccount.Id AND Subject = 'Test Case'];
        Test.setCreatedDate(existingCase.Id, DateTime.now().addDays(-2));

        Case newCase = new Case();
        newCase.AccountId = caseAccount.Id;
        newCase.Subject = 'Test Case 2';
        newCase.Description = 'Some description here 2';
        newCase.ReproductibilityPick__c = 'Always';

        Test.startTest();
        insert newCase;
        Test.stopTest();

        newCase = [SELECT DailyRMATransportNumber__c FROM Case WHERE Id = :newCase.Id];

        System.assertEquals(1, newCase.DailyRMATransportNumber__c);
    }
}