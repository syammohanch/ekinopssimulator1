global class CustomSharingCreateBatch implements Database.Batchable<SObject>, Database.Stateful
{
    private String originalTransactionId;
    private String objectName;
    private List<SharingSetting__mdt> sharingSettings;

    public CustomSharingCreateBatch(String objName, List<SharingSetting__mdt> settings) {
        this.objectName = objName;
        this.sharingSettings = settings;
    }

    /**
    * @description start Call when the batch begin
    * @param  {BatchableContext} BC
    * @return Database.QueryLocator
    */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // Each batchable method runs in a separate transaction,
        // so store the first transaction ID to later relate the other transactions
        this.originalTransactionId = Nebula.Logger.getTransactionId();

        Set<String> fieldSet = new Set<String>();
        for(SharingSetting__mdt setting : this.sharingSettings) {
            fieldSet.add(setting.Field__c);
        }

        return Database.getQueryLocator('SELECT Id,OwnerId,' + String.join(fieldSet, ',') + ' FROM ' + this.objectName);
    }

    /**
    * @description execute Call when the start method retrieve data
    * @param  {BatchableContext} BC
    * @param {List<Case>} items
    */
    global void execute(Database.BatchableContext BC, List<SObject> sObjectList) 
    {
        // One-time call (per transaction) to set the parent log
        Nebula.Logger.setParentLogTransactionId(this.originalTransactionId);

        Boolean isStandardObject = !this.objectName.endsWith('__c');
        Map<String, SObject> sharingObjectMap = new Map<String, SObject>();
        String shareObjName = this.objectName.replaceAll('^(.+)__c$', '$1__') + 'Share';
        SObjectType sObjectShareType = Schema.getGlobalDescribe().get(shareObjName);        
        String shareAccessLevelFieldname = (isStandardObject ? this.objectName : '' ) + 'AccessLevel';
        String shareObjParentFieldname = (isStandardObject ? this.objectName : 'Parent' ) + 'Id';

        try {
            if(sObjectShareType.getDescribe().isAccessible())
            {
                Map<Id, SObject> sObjectMap = new Map<Id, SObject>(sObjectList);
                for(SObject sObj : sObjectList)
                {
                    for(SharingSetting__mdt setting : this.sharingSettings) 
                    {
                        List<String> fields = String.isNotBlank(setting.Field__c) ? setting.Field__c.split('\\.') : new List<String>();
                        SObject sharingObj = sObjectShareType?.newSObject();
                        String currentLookupId;
                        Map<String, Object> tmpObj = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj, false));

                        for(String field : fields) 
                        {
                            Object value = tmpObj.get(field);
                            if(value != null) {
                                if(Pattern.matches('^[0-9a-zA-Z]{15,18}$', String.valueOf(value))) {
                                    currentLookupId = String.valueOf(value);
                                } else {
                                    tmpObj = (Map<String, Object>)tmpObj.get(field);
                                }
                            } else {
                                break;
                            }
                        }
        
                        if(sharingObj != null 
                        && String.isNotBlank(currentLookupId)
                        && !currentLookupId.equals(sObj.get('OwnerId'))) 
                        {
                            if(String.isNotBlank(setting.AccessLevelFieldname__c)) {
                                shareAccessLevelFieldname = setting.AccessLevelFieldname__c;
                            }
                            if(String.isNotBlank(setting.ParentFieldname__c)) {
                                shareObjParentFieldname = setting.ParentFieldname__c;
                            }

                            sharingObj.put(shareAccessLevelFieldname, setting.AccessLevel__c);
                            sharingObj.put(shareObjParentFieldname, sObj.Id);
                            sharingObj.put('RowCause', setting.RowCause__c);
                            sharingObj.put('UserOrGroupId', currentLookupId);
                            sharingObjectMap.put(sObj.Id + '_' + currentLookupId, sharingObj);
                        }
                    }
                }
        
                if(!sharingObjectMap.isEmpty())
                {
                    Database.SaveResult[] results =  Database.insert(sharingObjectMap.values(), false);
                    for(Database.SaveResult result : results) 
                    {
                        if(!result.isSuccess())
                        {
                            for(Database.Error err : result.getErrors()) 
                            {
                                Nebula.Logger.error('The following error has occurred.', sObjectMap.get(result.getId()));
                                Nebula.Logger.error(err.getStatusCode() + ': ' + err.getMessage());
                                if(err.getFields() != null && !err.getFields().isEmpty()) {
                                    Nebula.Logger.error('Fields that affected this error: ' + err.getFields());
                                }
                            }
                        }
                    }
                }
            }
        } catch(Exception e) {
            Nebula.Logger.error('The following exception occured.', e);
            Nebula.Logger.error('[' + e.getLineNumber() + '] ' + e.getMessage()).parseStackTrace(e.getStackTraceString());
        }

        Nebula.Logger.saveLog();
    }

    /**
    * @description finish Call at the end of the batch
    * @param  {BatchableContext} BC
    */
    global void finish(Database.BatchableContext BC) {}
}