/**
 * @description Batch class to update Pricebook Entries based on exchange rates.
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class UpdatePriceBookEntriesBatch  implements Database.Batchable<sObject>, Schedulable {
    
    public final String query;
    // public final Map<String, PricebookEntry> MapPBEEUR;
    // public final Map<String, Decimal> MapExchangeRate;
    public final DateTime dateToCompare = System.now().addDays(-230);
    // public final DateTime DateToCompare = DateTime.valueOf('2023-06-20 13:30:00');
    
    /**
     * @description Constructor to initialize the batch job.
     */
    public UpdatePriceBookEntriesBatch() {

        // if (Test.isRunningTest()) { System.now().addYears(-10); }

        Id accessPBId = [SELECT Id FROM Pricebook2 WHERE Name = 'Access' LIMIT 1][0].Id;
        Id standardPBId = (Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1][0].Id);

        // Map<String, PricebookEntry> MapPBEEUR = new Map<String,PricebookEntry>();
        // for (PricebookEntry PBE : [SELECT Product2.IDEkinops__c, UnitPrice 
        //             FROM PricebookEntry 
        //             WHERE Pricebook2Id = :accessPBId 
        //             AND CurrencyIsoCode = 'EUR' 
        //             AND UnitPrice != 0]) {

        //     MapPBEEUR.put(PBE.Product2.IDEkinops__c, PBE);
        // }

        Map<String, Decimal> mapExchangeRate = ExchangeRateService.GetExchangeRates(dateToCompare);
        
        String exchangeRateStringFilter = String.join(new List<String>(mapExchangeRate.keySet()), '\',\'');

        query = 
            'SELECT Id, Product2.IDEkinops__c, CurrencyIsoCode, UnitPrice, LastModifiedDate FROM PricebookEntry ' +
            'WHERE (Pricebook2Id = \'' + accessPBId + '\' OR Pricebook2Id = \'' + standardPBId + '\') AND CurrencyIsoCode IN (\'' + exchangeRateStringFilter + '\') ' +
            'ORDER BY Pricebook2Id';
    }
    
    /**
     * @description Start method to initialize the batch job.
     * @param BC The batchable context.
     * @return The query locator.
     */
    @SuppressWarnings('PMD.FormalParameterNamingConventions')
    public Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }
    
    /**
     * @description Execute method to execute the scheduledÒ batch job.
     * @param schedContext The schedulable context.
     */
    global void execute(SchedulableContext schedContext)
    {
        Database.executeBatch(new UpdatePriceBookEntriesBatch());
    }

    /**
     * @description Execute method to process Pricebook Entries.
     * @param BC The batchable context.
     * @param scope The list of Pricebook Entries to process.
     */
    @SuppressWarnings('PMD.FormalParameterNamingConventions, PMD.LocalVariableNamingConventions')
    public void execute(Database.BatchableContext BC, List<PricebookEntry> scope) {

        Id accessPBId = [SELECT Id FROM Pricebook2 WHERE Name = 'Access' LIMIT 1][0].Id;

        Map<String, PricebookEntry> mapPBEEUR = new Map<String,PricebookEntry>();
        for (PricebookEntry PBE : [SELECT Product2.IDEkinops__c, UnitPrice 
                    FROM PricebookEntry 
                    WHERE Pricebook2Id = :accessPBId 
                    AND CurrencyIsoCode = 'EUR' 
                    AND UnitPrice != 0]) {

            mapPBEEUR.put(PBE.Product2.IDEkinops__c, PBE);
        }

        Map<String, Decimal> mapExchangeRate = ExchangeRateService.GetExchangeRates(dateToCompare);

        ExchangeRateService.UpdatePriceBookEntries(scope, mapPBEEUR, mapExchangeRate);
    }   
    
    /**
     * @description Finish method executed after batch job completion.
     * @param BC The batchable context.
     */
    @SuppressWarnings('PMD.EmptyStatementBlock, PMD.FormalParameterNamingConventions')
    public void finish(Database.BatchableContext BC) {
    }
}