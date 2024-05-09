@isTest
public class ApexDefinedVariableOLITest {
    public static testMethod void testApexConstructor() {
        ApexDefinedVariableOpportunityLineItem ApexOLI = new ApexDefinedVariableOpportunityLineItem();

    	system.assertEquals(ApexOLI.Id, null);
        system.assertEquals(ApexOLI.Quantity, null);
        system.assertEquals(ApexOLI.UnitPrice, null);
        system.assertEquals(ApexOLI.PricebookEntryId, null);
        system.assertEquals(ApexOLI.OpportunityId, null);
        system.assertEquals(ApexOLI.TECH_Product, null);
        system.assertEquals(ApexOLI.QuoteLine, null);
        system.assertEquals(ApexOLI.SubscriptionType, null);
    }
}