@IsTest
class Test_CustomMilestoneTimeCalculator {
	@IsTest
    static void calculate_AnyMilestone_ReturnFourMonths() {
        Case cs = new Case(Priority='Major', Origin='Phone', Subject='TestFourMonthsTime', ReproductibilityPick__c= 'Always');
        insert cs;
        Support.MilestoneTriggerTimeCalculator calculator = new CustomMilestoneTimeCalculator();
        Integer interval = calculator.calculateMilestoneTriggerTime(cs.Id, null);
        Integer realInterval = Date.today().addMonths(4).daysBetween(Date.today()) * 24 * 60;
        System.assertEquals(-realInterval, interval);
    }
    
    @IsTest 
    
    static void testMilestonePriority() {
       
        Account acct = new Account(Name='TestMilestoneTime', AccountStatusPick__c='Active', BillingCountryCode='FR');
        insert acct;
        
        Case cs = new Case(Priority='Major', Origin='Phone', Subject='TestMilestoneTime', AccountId=acct.Id, ReproductibilityPick__c= 'Always');
        insert cs;
        Test.setCreatedDate(cs.Id, DateTime.newInstance(2022, 2, 1, 0, 0, 0));
        
        MilestoneType mlt1 = [SELECT Id,Name
                             FROM MilestoneType 
                             WHERE Name = 'Engineer Call Back'];
        
        Support.MilestoneTriggerTimeCalculator calculator = new CustomMilestoneTimeCalculator();
		Integer interval = calculator.calculateMilestoneTriggerTime(cs.Id, mlt1.Id);
        System.assertEquals(120, interval);
    }
    

}