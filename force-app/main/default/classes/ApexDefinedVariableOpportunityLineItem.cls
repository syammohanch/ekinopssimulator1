public class ApexDefinedVariableOpportunityLineItem {
		@AuraEnabled @InvocableVariable public String Id;
    	@AuraEnabled @InvocableVariable public Decimal Quantity;
    	@AuraEnabled @InvocableVariable public Decimal UnitPrice;
    	@AuraEnabled @InvocableVariable public String PricebookEntryId;
    	@AuraEnabled @InvocableVariable public String OpportunityId;
    	@AuraEnabled @InvocableVariable public String TECH_Product;
    	@AuraEnabled @InvocableVariable public String TECH_SAPIDECC;
    	@AuraEnabled @InvocableVariable public String QuoteLine;
    	@AuraEnabled @InvocableVariable public String SubscriptionType;
    
    	public ApexDefinedVariableOpportunityLineItem() {}
}