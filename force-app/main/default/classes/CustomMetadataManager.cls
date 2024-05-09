public with sharing class CustomMetadataManager 
{
    private static CustomMetadataManager instance;

    private Map<String, List<SharingSetting__mdt>> sharingSettingByObjectMap = new Map<String, List<SharingSetting__mdt>>();

    private CustomMetadataManager() 
    {
        List<SharingSetting__mdt> sharingSettingList = [
            SELECT Object__c, Field__c, RowCause__c, AccessLevel__c,
                ParentFieldname__c, AccessLevelFieldname__c
            FROM SharingSetting__mdt
            WHERE IsActive__c = true
        ];

        for(SharingSetting__mdt setting : sharingSettingList)
        {
            List<SharingSetting__mdt> sharingSettings = sharingSettingByObjectMap.get(setting.Object__c);
            if(sharingSettings == null) {
                sharingSettings = new List<SharingSetting__mdt>();
                sharingSettingByObjectMap.put(setting.Object__c, sharingSettings);
            }

            sharingSettings.add(setting);
        }
    }

    /**
     * @description getInstance Return a CustomMetadataManager instance
     * @return {CustomMetadataManager}
     */
    public static CustomMetadataManager getInstance() 
    {
        if(instance == null) {
            instance = new CustomMetadataManager();
        }

        return instance;
    }

    /**
     * @description getSharingSettingByObjectMap Return all active sharing settings
     * @return {Map<String, List<SharingSetting__mdt>>}
     */
    public Map<String, List<SharingSetting__mdt>> getSharingSettingByObjectMap() {
        return this.sharingSettingByObjectMap;
    }
}