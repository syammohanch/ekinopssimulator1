public with sharing class ExchangeRateService {
    
    public static void UpdatePriceBookEntries(List<PricebookEntry> listPBE, 
                                            Map<String, PricebookEntry> MapPBEEUR, 
                                            Map<String, Decimal> mapExchangeRate) {
        
        List<PricebookEntry> listPBEToUpdate = new List<PricebookEntry>();
        for (PricebookEntry PBE : listPBE) {

            PricebookEntry referencePBE = MapPBEEUR.get(PBE.Product2.IDEkinops__c);
            Decimal exchangeRate = mapExchangeRate.get(PBE.CurrencyIsoCode);
            if (referencePBE != null && exchangeRate != null) {                              

                PBE.UnitPrice = referencePBE.UnitPrice * exchangeRate;

            } else {
                
                PBE.UnitPrice = 0;
            }
            
            listPBEToUpdate.add(PBE);
        }

        update listPBEToUpdate;
    }

    public static Map<String, Decimal> GetExchangeRates(DateTime dateToCompare) {
    
        Map<String, Decimal> mapExchangeRate = new Map<String, Decimal>();

        for (CurrencyType currType : [SELECT IsoCode, ConversionRate 
                                        FROM CurrencyType 
                                        WHERE LastModifiedDate >= :dateToCompare
                                        AND IsoCode != 'EUR' 
                                        AND IsoCode != 'USD']) {
            
            mapExchangeRate.put(currType.IsoCode, currType.ConversionRate);
        }

        return mapExchangeRate;
    }
}