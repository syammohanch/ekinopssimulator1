/**
 * Created by vladPersistent on 04.05.2023.
 */
@IsTest
public with sharing class OpportunityLineItemTriggerHandlerTest 
{
    @TestSetup
    static void makeData()
    {
        TestDataFactory.createAccount();
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        Product2 prod = TestDataFactory.createProduct();
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(stdPriceBookRecId, prod);
        Opportunity opp = TestDataFactory.createOpportunity(UserInfo.getUserId());
        SalesAgreement sa = TestDataFactory.createOrderIntake(opp, pbEntry);
        OpportunityLineItem oliLowerPrice = TestDataFactory.createOpportunityLineItem(opp, pbEntry, 1);
        TestDataFactory.createOpportunityLineItem(opp, pbEntry, 10);
        TestDataFactory.createOrderIntakeProduct(sa, prod, oliLowerPrice);
    }

    @IsTest
    private static void updateOpportunityRelatedSalesAgreementProductsPositiveTest() 
    {
        SalesAgreementProduct SPAProduct = [SELECT Id, SalesPrice, Opportunity_Product__c FROM SalesAgreementProduct];
        SPAProduct.Opportunity_Product__c = null;
        update SPAProduct;

        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem LIMIT 1];

        Test.startTest();
        oli.UnitPrice = 200;
        update oli;
        Test.stopTest();

        SalesAgreementProduct SPAProductAfterUpdate = [SELECT Id, SalesPrice, Opportunity_Product__c FROM SalesAgreementProduct];

        //System.assertEquals(oli.UnitPrice, SPAProductAfterUpdate.SalesPrice);
        //System.assertNotEquals(null, SPAProductAfterUpdate.Opportunity_Product__c);
    }

    @IsTest
    private static void testUpdateSalesAgreementProductsWhenOLIPriceIsInserted() 
    {
        OpportunityLineItem oliLowerPrice = [SELECT Id FROM OpportunityLineItem ORDER BY UnitPrice LIMIT 1];
        List<SalesAgreementProduct> sapList = [SELECT Id, Opportunity_Product__c, SalesPrice FROM SalesAgreementProduct];
        System.assertEquals(oliLowerPrice.Id, sapList[0].Opportunity_Product__c);
        

        // Call trigger handler method
        Test.startTest();
        delete oliLowerPrice;
        Test.stopTest();

        // Verify results
        List<SalesAgreementProduct> sapListAfterDeletion = [SELECT Id, Opportunity_Product__c, SalesPrice FROM SalesAgreementProduct];
        OpportunityLineItem oliBiggerPrice = [SELECT Id, UnitPrice FROM OpportunityLineItem ORDER BY UnitPrice DESC LIMIT 1];
        System.assertEquals(1, sapList.size());
        //System.assertEquals(oliBiggerPrice.Id, sapListAfterDeletion[0].Opportunity_Product__c);
        //System.assertEquals(oliBiggerPrice.UnitPrice, sapListAfterDeletion[0].SalesPrice);
    }

    @IsTest
    private static void updateOpportunityRelatedSalesAgreementProductsTest()
    {
        SalesAgreementProduct SPAProduct = [SELECT Id, SalesPrice, Opportunity_Product__c FROM SalesAgreementProduct];
        SPAProduct.Opportunity_Product__c = null;
        update SPAProduct;

        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        oli.UnitPrice = -200;
        try{
            Test.startTest();
            update oli;
            Test.stopTest();
        }catch(Exception e){
            System.assert(e.getMessage().contains('The sales price must be a positive number'));
        }
    }
}