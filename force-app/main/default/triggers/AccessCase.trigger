trigger AccessCase on Case (after insert, after update) {
    if(trigger.isInsert && trigger.isafter){
        List<Id> accessCaseList = new List<Id>();
        for(Case caseRec:trigger.new){
            System.debug('Case Record Type : '+caseRec.Case_Record_Type_Name__c);
            if(caseRec.Case_Record_Type_Name__c == 'Access'){
                accessCaseList.add(caseRec.Id);
            }
        }
        
        if(accessCaseList.size() > 0){
            AccessCaseHandler.caseInsertHandler(accessCaseList);
        }
    }
    
    
    if(trigger.isUpdate){
        System.debug('Inside Update 1');
        //Checking the Case Updated by JIRA Key Update. 
        //In that case we need to block the Update Trigger from execution by adding the flag 'canPerformUpdate' variable.
        System.debug('AccessCaseHandler.canPerformUpdate 2 : '+AccessCaseHandler.canPerformUpdate);
        if(AccessCaseHandler.canPerformUpdate){
            System.debug('Inside Update 2');
            List<Id> accessCaseStatusList = new List<Id>();
            List<Id> accessCaseUpdateList = new List<Id>();
            List<Id> accessCaseUpdateRecordType = new List<Id>();
            for(Case caseObj : trigger.new){
                if(caseObj.Case_Record_Type_Name__c == 'Access'){
                    //System.debug('Inside Update 123 : '+Trigger.oldMap.get(caseObj.Id).Status+' : '+Trigger.newMap.get(caseObj.Id).Status);
                    // Case Status Update
                    if(Trigger.oldMap.get(caseObj.Id).Status != Trigger.newMap.get(caseObj.Id).Status){
                        accessCaseStatusList.add(caseObj.Id);
                    }
                    if( (Trigger.oldMap.get(caseObj.Id).Subject != Trigger.newMap.get(caseObj.Id).Subject) || 
                       (Trigger.oldMap.get(caseObj.Id).Description != Trigger.newMap.get(caseObj.Id).Description) || 
                       (Trigger.oldMap.get(caseObj.Id).Detailed_Description__c != Trigger.newMap.get(caseObj.Id).Detailed_Description__c) || 
                       (Trigger.oldMap.get(caseObj.Id).PrivacyPick__c != Trigger.newMap.get(caseObj.Id).PrivacyPick__c) || 
                       (Trigger.oldMap.get(caseObj.Id).AccountId != Trigger.newMap.get(caseObj.Id).AccountId) || 
                       (Trigger.oldMap.get(caseObj.Id).PartnerCustomerRef__c != Trigger.newMap.get(caseObj.Id).PartnerCustomerRef__c) || 
                       (Trigger.oldMap.get(caseObj.Id).ContactId != Trigger.newMap.get(caseObj.Id).ContactId) || 
                       (Trigger.oldMap.get(caseObj.Id).RelatedCustomers__c != Trigger.newMap.get(caseObj.Id).RelatedCustomers__c) || 
                       (Trigger.oldMap.get(caseObj.Id).Type != Trigger.newMap.get(caseObj.Id).Type) || 
                       (Trigger.oldMap.get(caseObj.Id).Pname__c != Trigger.newMap.get(caseObj.Id).Pname__c) || 
                       (Trigger.oldMap.get(caseObj.Id).Priority != Trigger.newMap.get(caseObj.Id).Priority) || 
                       (Trigger.oldMap.get(caseObj.Id).ReproductibilityPick__c != Trigger.newMap.get(caseObj.Id).ReproductibilityPick__c) || 
                       (Trigger.oldMap.get(caseObj.Id).DetectionPhasePick__c != Trigger.newMap.get(caseObj.Id).DetectionPhasePick__c) || 
                       (Trigger.oldMap.get(caseObj.Id).IsServiceAffectingPick__c != Trigger.newMap.get(caseObj.Id).IsServiceAffectingPick__c) || 
                       (Trigger.oldMap.get(caseObj.Id).SoftwarePackPick__c != Trigger.newMap.get(caseObj.Id).SoftwarePackPick__c) ||
                       (Trigger.oldMap.get(caseObj.Id).SoftwareVersion__c != Trigger.newMap.get(caseObj.Id).SoftwareVersion__c) ||
                       (Trigger.oldMap.get(caseObj.Id).CustomerTicketRef__c != Trigger.newMap.get(caseObj.Id).CustomerTicketRef__c) ||
                       (Trigger.oldMap.get(caseObj.Id).RequestedDate__c != Trigger.newMap.get(caseObj.Id).RequestedDate__c) ||
                       (Trigger.oldMap.get(caseObj.Id).RelatedTicketRef__c != Trigger.newMap.get(caseObj.Id).RelatedTicketRef__c) ||
                       (Trigger.oldMap.get(caseObj.Id).EmailNotification__c != Trigger.newMap.get(caseObj.Id).EmailNotification__c))
                    {
                        accessCaseUpdateList.add(caseObj.Id);
                    }
                    /*else{
                      accessCaseUpdateList.add(caseObj.Id);  
                    }*/
                    // Case Description Update
                    /*if( (Trigger.oldMap.get(caseObj.Id).Description != Trigger.newMap.get(caseObj.Id).Description) || (Trigger.oldMap.get(caseObj.Id).Subject != Trigger.newMap.get(caseObj.Id).Subject) ){
                        accessCaseUpdateList.add(caseObj.Id);
                    }*/
                    /*if( (Trigger.oldMap.get(caseObj.Id).Status != Trigger.newMap.get(caseObj.Id).Status) && caseObj.Status=='In Progress' ){
                        accessCaseUpdateRecordType.add(caseObj.Id);
                    }*/
                }
                if(accessCaseStatusList.size() > 0){
                    System.debug('Inside 1');
                    AccessCaseHandler.caseUpdateStatusHandler(accessCaseStatusList);
                }
                if(accessCaseUpdateList.size() > 0){
                    AccessCaseHandler.caseUpdateHandler(accessCaseUpdateList);
                }
                /*if(accessCaseUpdateRecordType.size() > 0){
                    AccessCaseHandler.caseUpdateRecordType(accessCaseUpdateRecordType);
                }*/
            }    
        }
        
    }
    
}