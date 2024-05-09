public with sharing class SalesAgreementManager
{
    /**
     * @description resetProductSchedulesQuantities Reset Product Schedule Quantities
     * @param {List<ResetProductSchedulesQuantities__e>} events
     */
    public static void resetProductSchedulesQuantities(List<ResetProductSchedulesQuantities__e> events) 
    {
        Set<Id> orderIntakeIdSet = new Set<Id>();
        for(ResetProductSchedulesQuantities__e event : events) {
            orderIntakeIdSet.add(event.OrderIntakeId__c);
        }

        List<SalesAgreementProductSchedule> productScheduleList = [
            SELECT Id
            FROM SalesAgreementProductSchedule
            WHERE OrderIntakeRef__c = :orderIntakeIdSet
                AND (UpsideQuantity__c != 0 OR PlannedQuantity != 0)
        ];

        if(!productScheduleList.isEmpty()) 
        {
            for(SalesAgreementProductSchedule saps : productScheduleList) 
            {
                saps.PlannedQuantity = 0;
                saps.UpsideQuantity__c = 0;
            }
    
            update productScheduleList;
        }
    }
}