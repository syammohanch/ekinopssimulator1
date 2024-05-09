global class CustomSharingDeleteBatch implements Database.Batchable<SObject>, Database.Stateful
{
    private String originalTransactionId;
    private String objectName;
    private List<SharingSetting__mdt> sharingSettings;

    public CustomSharingDeleteBatch(String objName, List<SharingSetting__mdt> settings) {
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

        String shareObjName = this.objectName.replaceAll('^(.+)__c$', '$1__') + 'Share';
        String userId = UserInfo.getUserId();
        Set<String> rowCauseSet = new Set<String>();
        for(SharingSetting__mdt setting : this.sharingSettings) {
            rowCauseSet.add(setting.RowCause__c);
        }
        
        return Database.getQueryLocator('SELECT Id FROM ' + shareObjName + ' WHERE LastModifiedById = :userId AND RowCause = :rowCauseSet');
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

        Map<Id, SObject> sObjectMap = new Map<Id, SObject>(sObjectList);
        Database.DeleteResult[] results = Database.delete(sObjectList, false);
        for(Database.DeleteResult result : results) {
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

        Nebula.Logger.saveLog();
    }

    /**
    * @description finish Call at the end of the batch
    * @param  {BatchableContext} BC
    */
    global void finish(Database.BatchableContext BC) {
        Database.executeBatch(new CustomSharingCreateBatch(this.objectName, this.sharingSettings));
    }
}