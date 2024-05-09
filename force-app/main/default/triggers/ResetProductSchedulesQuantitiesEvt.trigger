trigger ResetProductSchedulesQuantitiesEvt on ResetProductSchedulesQuantities__e (after insert) {
    SalesAgreementManager.resetProductSchedulesQuantities(Trigger.new);
}