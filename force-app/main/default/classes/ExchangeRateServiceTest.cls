@isTest(SeeAllData=false)
private  class ExchangeRateServiceTest {

    private static Pricebook2 priceBook;    
    private static Pricebook2 getPriceBook() {
        
        if (priceBook == null) {

            priceBook = new Pricebook2(Name = 'Access', IsActive = true);
            insert priceBook;
        } 

        return priceBook;
    }

    private static Map<String, Decimal>  mapExchangeRate;
    private static Map<String, Decimal> getMapExchangeRate() {
        
        if (mapExchangeRate == null) {

            mapExchangeRate = ExchangeRateService.GetExchangeRates(System.now().addYears(-10));
            mapExchangeRate.put('EUR', 1);
            mapExchangeRate.put('USD', 1);
            mapExchangeRate.put('AUD', 1);
            mapExchangeRate.put('INR', 1);
        } 

        return mapExchangeRate;
    }
    
    @TestSetup
    static void createTestData() {

        Product2[] productList = new List<Product2>();
        for (Integer i=0; i<20; i++) {
            Product2 prod = new Product2(
                Name = 'Prod' + i, 
                IsActive = true, 
                IDEkinops__c = 'Prod' + i,
                GroupProductHierarchyLabelL1Pick__c = 'S/W & Services RR',
        		GroupProductHierarchyLabelL2Pick__c = 'PROFESSIONAL SERVICES RR',
        		GroupProductHierarchyLabelL3Pick__c = 'Support Contracts RR'
            );
            productList.add(prod);
        }
        insert productList;

        PricebookEntry[] PBElist = new List<PricebookEntry>();
        PricebookEntry[] stdPBElist = new List<PricebookEntry>();
        Id stdPBID = Test.getStandardPricebookId();
        Id accessPBID = getPriceBook().Id;
        for(Product2 product : productList) { 

            Decimal unitPrice = Math.random() * 100;
            PricebookEntry stdPBE, pbe;
            for(String isoCode : getMapExchangeRate().keySet()) { 
                
                if (isoCode == 'EUR') {
                
                    /* In order to simulate some unti price at 0 */
                    unitPrice = Math.random() > 0.5 ? 0 : unitPrice; 
                } else {

                    Decimal exchangeRate = mapExchangeRate.get(isoCode);
                    unitPrice = unitPrice * exchangeRate;                
                }

                stdPBE = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = stdPBID, UnitPrice = unitPrice, IsActive = true, CurrencyIsoCode = isoCode);
                pbe = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = accessPBId, UnitPrice = unitPrice, IsActive = true, CurrencyIsoCode = isoCode);

                stdPBElist.add(stdPBE);
                PBElist.add(pbe);
            }
        }

        insert stdPBElist;
        insert PBElist;
    }

    @isTest
    static void testUpdatePriceBookEntriesBatch() {

        Test.startTest();
        UpdatePriceBookEntriesBatch ba = new UpdatePriceBookEntriesBatch();
        Id jobid = Database.executeBatch(ba);
        Test.stopTest();
    }

    @isTest
    static void testUpdatePriceBookEntries() {

        UpdatePriceBookEntriesBatch batch = new UpdatePriceBookEntriesBatch();
        Id accessPBId = [SELECT Id FROM Pricebook2 WHERE Name = 'Access' LIMIT 1][0].Id;
        PricebookEntry[] listPBE =
                            [SELECT Id, Product2.IDEkinops__c, CurrencyIsoCode, UnitPrice, LastModifiedDate 
                                FROM PricebookEntry
                                WHERE Pricebook2Id = :accessPBId// AND CurrencyIsoCode IN :batch.MapExchangeRate.keySet() 
                                ORDER BY Pricebook2Id];
        
        Test.startTest();
        ExchangeRateService.UpdatePriceBookEntries(listPBE, batch.MapPBEEUR, batch.MapExchangeRate);
        Test.stopTest();
    }

    @isTest
    static void testGetExchangeRates() {

        Map<String, Decimal> mapExchangeRate = ExchangeRateService.GetExchangeRates(System.now().addYears(-10));

        Assert.isTrue(mapExchangeRate.size() >= 3);
    }
}