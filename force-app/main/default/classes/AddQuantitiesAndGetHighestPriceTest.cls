@isTest
public class AddQuantitiesAndGetHighestPriceTest {
    
    @isTest static void testAddQuantitiesAndGetHighestPrice()   {
        
        //Create product
		Product2 prod = new Product2(
     	Name = 'Product X',
     	ProductCode = 'Pro-X',
     	isActive = true,
        GroupProductHierarchyLabelL1Pick__c = 'H/W Products',
        GroupProductHierarchyLabelL2Pick__c = 'DWDM - Infrastructure',
        GroupProductHierarchyLabelL3Pick__c = 'DWDM OPTICAL ADD/DROP/MUX'
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
  
        //Create account
        Account acc = new Account();
        acc.name = 'TestAccount';
        insert acc;
        
        //Create opportunity
        Opportunity opp = new Opportunity();
        opp.name = 'TestOpportunity';
        opp.CloseDate = Date.today();
        opp.AccountId = acc.Id;
        opp.StageName =  'Qualification';
        opp.CurrencyIsoCode = pbEntry.CurrencyIsoCode;
        opp.TechnicalAccountManagerRef__c = UserInfo.getUserId();
        opp.PLM_Ref__c = UserInfo.getUserId();
        
        
        Insert opp;
        
        //create opportunity line item 1
		OpportunityLineItem oli1 = new OpportunityLineItem(
     	OpportunityId = opp.Id,
     	Quantity = 5,
     	PricebookEntryId = pbEntry.Id,
     	UnitPrice = 5 
		);
		insert oli1;
        
        //create opportunity line item 2
		OpportunityLineItem oli2 = new OpportunityLineItem(
     	OpportunityId = opp.Id,
     	Quantity = 7,
     	PricebookEntryId = pbEntry.Id,
     	UnitPrice = 15
		);
		insert oli2;
        
        AddQuantitiesAndGetHighestPrice.FLowInputs FlowInput = new AddQuantitiesAndGetHighestPrice.FLowInputs();
        FlowInput.InputOpportunityId = opp.Id;
        List<AddQuantitiesAndGetHighestPrice.FLowInputs> testInputs = new List<AddQuantitiesAndGetHighestPrice.FLowInputs>();
        testInputs.add(FlowInput);
        List<List<ApexDefinedVariableOpportunityLineItem>> APEXOLIListList = new List<List<ApexDefinedVariableOpportunityLineItem>>();
        Decimal UnitPrice;
        Decimal Quantity;
        String PBEId;
        String OpportunityId;
        
        Test.startTest();
        
        APEXOLIListList = AddQuantitiesAndGetHighestPrice.ProcessOpportunityLineItems(testInputs);
        
        Test.stopTest();
        
        for (List<ApexDefinedVariableOpportunityLineItem> ApexOLIList : APEXOLIListList) {
            system.assertEquals(ApexOLIList.size(), 1);
            for (ApexDefinedVariableOpportunityLineItem ApexOLI : ApexOLIList) {
                OpportunityId = ApexOLI.OpportunityId;
                PBEId = ApexOLI.PricebookEntryId;
                Quantity = ApexOLI.Quantity;
                UnitPrice = ApexOLI.UnitPrice;
                break;
            }
        }
        system.assertEquals(OpportunityId, opp.Id);
        system.assertEquals(PBEId, pbEntry.Id);
        system.assertEquals(Quantity, oli1.Quantity + oli2.Quantity);
        system.assertEquals(UnitPrice, oli2.UnitPrice);
        
    }

}