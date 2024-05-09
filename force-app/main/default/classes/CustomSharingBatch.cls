global class CustomSharingBatch implements System.Schedulable
{
    public void execute(SchedulableContext context) 
    {
        Map<String, List<SharingSetting__mdt>> sharingSettingsMap = ConstantManager.SHARING_SETTING_BY_OBJECT;
        for(String objectName : sharingSettingsMap.keySet()) {
            if(Schema.getGlobalDescribe().get(objectName)?.getDescribe().isAccessible()) {
                Database.executeBatch(new CustomSharingDeleteBatch(objectName, sharingSettingsMap.get(objectName)));
            }
        }
    }
}