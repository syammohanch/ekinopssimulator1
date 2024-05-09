global class CustomSharingForRequestBatch implements System.Schedulable
{
    public void execute(SchedulableContext context) 
    {
       String objectName = 'Request__c';
       Map<String, List<SharingSetting__mdt>> sharingSettingsMap = ConstantManager.SHARING_SETTING_BY_OBJECT;
       Database.executeBatch(new CustomSharingCreateBatch(objectName, sharingSettingsMap.get(objectName)));
    }
}