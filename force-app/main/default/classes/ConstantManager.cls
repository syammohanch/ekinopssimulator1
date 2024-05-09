public with sharing class ConstantManager 
{
    public final static Map<String, List<SharingSetting__mdt>> SHARING_SETTING_BY_OBJECT = CustomMetadataManager.getInstance().getSharingSettingByObjectMap();
}