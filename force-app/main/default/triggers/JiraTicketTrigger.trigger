trigger JiraTicketTrigger on JiraTicket__c (after insert, after update) {

    switch on Trigger.operationType {
        when  AFTER_INSERT{
            JiraTicketTriggerHandler.afterInsertHandlerMethod(Trigger.new);
        }
        when AFTER_UPDATE{
            JiraTicketTriggerHandler.afterUpdateHandlerMethod(Trigger.oldMap, Trigger.new);
        }
    }
}