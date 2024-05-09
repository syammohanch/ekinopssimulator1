/**
 * Created by vladPersistent on 03.05.2023.
 */

trigger OpportunityLineItemTrigger on OpportunityLineItem (
        before insert,
        after insert,
        before update,
        after update,
        before delete,
        after delete,
        after undelete
) {
    switch on Trigger.operationType {
        when AFTER_INSERT{
            OpportunityLineItemTriggerHandler.updateSalesAgreementProductsWhenOLIPriceIsInserted(Trigger.newMap);
        }
        when AFTER_UPDATE{
            OpportunityLineItemTriggerHandler.updateSalesAgreementProductsWhenOLIPriceIsUpdated(Trigger.newMap, Trigger.oldMap);
        }
        when  AFTER_DELETE {
            OpportunityLineItemTriggerHandler.updateSalesAgreementProductsWhenPrimaryQuoteIsChanged(Trigger.oldMap);
        }
    }
}