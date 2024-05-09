public without sharing class CaseService {

    public static void manageDailyRMACaseNumber(List<Case> newCases) {
        //Tracking Numbers are reset each day, so we'll query for the current number and add to it for the workorder
        Decimal todaysRMATransportNumber = 1;
        //get the current number - there might not be one, so we'll query into a list

        Case[] todaysCases = [
            SELECT Id, DailyRMATransportNumber__c
            FROM Case
            WHERE CreatedDate = TODAY
            ORDER BY DailyRMATransportNumber__c DESC
            LIMIT 1
        ];

        //if there is a WorkOrder, then use the first one, since it is ordered by number
        if (todaysCases.size() > 0) {
             todaysRMATransportNumber = todaysCases[0].DailyRMATransportNumber__c + 1;
        }

        //Now loop through the new workorder and allocate a number

        for (Case newCase: newCases) {
            newCase.DailyRMATransportNumber__c = todaysRMATransportNumber;
            todaysRMATransportNumber = todaysRMATransportNumber + 1;
        }
    }

}