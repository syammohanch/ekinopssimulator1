global class CustomMilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        
        Case cs1 = [SELECT Id,Priority, CreatedDate, Account.Primary_region__c
                    FROM Case 
                    WHERE id = :caseId]; 
        
        String BusinessHoursName;
        
        if(cs1.Account.Primary_region__c == 'Americas'){
            BusinessHoursName = 'US';
        }
        
        else{
            BusinessHoursName = 'EUROPE';
        }
        
        
        BusinessHours bh1 = [SELECT Id,Name,IsActive,IsDefault
                             FROM BusinessHours 
                             WHERE Name = :BusinessHoursName];
        
        
        MilestoneType[] mlt1 = [SELECT Id,Name
                                FROM MilestoneType 
                                WHERE Name = 'Engineer Call Back' and id = :milestoneTypeId];
        
        
        boolean MajorPriority = cs1.Priority == 'Major';
        boolean CriticalPriority = cs1.Priority == 'Critical';                
        boolean BHWithin = BusinessHours.isWithin(bh1.id,cs1.CreatedDate);
        system.debug('bh1 ' + bh1.Name);
        system.debug('BHWithin ' + BHWithin);
        system.debug('cs1.CreatedDate ' + cs1.CreatedDate);

        if(!mlt1.isEmpty()){ 
            
            if(MajorPriority){ 
                if(BHWithin){
                    return 30;
                }
                
                else{
                    return 120;
                }
                
            }
            else if(CriticalPriority){
                if(BHWithin){
                    return 20;
                }
                
                else{
                    return 60;
                }
            }
            
            return 24 * 60;
        }
        
        
        Date today = Date.today();
        Date endDate = Date.today().addMonths(4);
        Integer interval = today.daysBetween(endDate) * 24 * 60;
        return interval;
    }
}