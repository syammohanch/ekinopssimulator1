trigger CaseTrigger on Case (
    before insert,
    after insert,
    before update,
    after update,
    before delete,
    after delete,
    after undelete
) { 
    switch on Trigger.operationType {
        when  BEFORE_INSERT {
            CaseService.manageDailyRMACaseNumber(Trigger.new);
        }
    }
}