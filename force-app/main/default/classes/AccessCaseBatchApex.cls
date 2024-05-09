global class AccessCaseBatchApex implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful,Schedulable  { //,Schedulable
	Map<Id,String> sfidAndJira = new Map<Id,String>();
    Map<Id,String> sfidAndJiraError = new Map<Id,String>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id,Name,CreatedDate,CreatedById,Case_Id__c,Action__c,SF_Type_Object__c,SF_Type_Object_Id__c,Status__c,Log__c,Salesforce_Case_Number__c,Created_On__c FROM Access_Case__c WHERE Status__c= \'Queued\' order by createddate asc';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Access_Case__c> accCaseList) {
        List<Access_Case__c> accCaseInsertList = new List<Access_Case__c>(); // Case Insert
        List<Access_Case__c> accCaseStatusUpdateList = new List<Access_Case__c>(); // Case Status Update
        List<Access_Case__c> accCaseUpdateList = new List<Access_Case__c>(); // Case Update
        List<Access_Case__c> accCaseCommentInsertList = new List<Access_Case__c>(); // Case Comment Insert
        List<Access_Case__c> accCaseCommentUpdateList = new List<Access_Case__c>(); // Case Comment Update
        List<Access_Case__c> accCaseCommentRepInsertList = new List<Access_Case__c>(); // Case Comment Reply Insert
        List<Access_Case__c> accCaseCommentRepUpdateList = new List<Access_Case__c>(); // Case Comment Reply Update
        for(Access_Case__c accCase : accCaseList) { 
            if(accCase.Action__c == 'Insert' && accCase.SF_Type_Object__c == 'Case' ){ // Case Insert
                accCaseInsertList.add(accCase);
            }
            if(accCase.Action__c == 'Update' && accCase.SF_Type_Object__c == 'Status' ){ // Status Update
                accCaseStatusUpdateList.add(accCase);
            }
            if(accCase.Action__c == 'Update' && accCase.SF_Type_Object__c == 'Case' ){  // Case Update
                accCaseUpdateList.add(accCase);
            }
            
            if(accCase.Action__c == 'Insert' && accCase.SF_Type_Object__c == 'Comment' ){ // Comment Insert
          		accCaseCommentInsertList.add(accCase);
            }
            if(accCase.Action__c == 'Update' && accCase.SF_Type_Object__c == 'Comment' ){ // Comment Update
                accCaseCommentUpdateList.add(accCase);
            }
            if(accCase.Action__c == 'Insert' && accCase.SF_Type_Object__c == 'CommentRep' ){ // Comment Insert
          		accCaseCommentRepInsertList.add(accCase);
            }
            if(accCase.Action__c == 'Update' && accCase.SF_Type_Object__c == 'CommentRep' ){ // Comment Update
          		accCaseCommentRepUpdateList.add(accCase);
            }
        }
		if(accCaseInsertList.size() > 0){
            System.debug('Inside Access Case INsert');
            sfidAndJira = AccessCaseHandler.handleInsertAccessCasesBatch(accCaseInsertList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseStatusUpdateList.size() > 0){
            System.debug('Inside Status Update');
            AccessCaseHandler.handleUpdateAccessCasesStatusBatch(accCaseStatusUpdateList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseUpdateList.size() > 0){
            System.debug('Inside Case Update');
            AccessCaseHandler.handleUpdateAccessCasesBatch(accCaseUpdateList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseCommentInsertList.size() > 0){
            AccessCaseCommentsHandler.handleInsertAccessCommentsBatch(accCaseCommentInsertList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseCommentUpdateList.size() > 0){
            AccessCaseCommentsHandler.handleUpdateAccessCommentsBatch(accCaseCommentUpdateList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseCommentRepInsertList.size() > 0){
            AccessCaseCommentsHandler.handleInsertAccessCommentsRepBatch(accCaseCommentRepInsertList,sfidAndJira,sfidAndJiraError);
        }
        if(accCaseCommentRepUpdateList.size() > 0){
            AccessCaseCommentsHandler.handleUpdateAccessCommentsRepBatch(accCaseCommentRepUpdateList,sfidAndJira,sfidAndJiraError);
        }
    }
    
    global void execute(SchedulableContext ctx){
      //String soql = 'SELECT Id, Name FROM Account';
      AccessCaseBatchApex batch = new AccessCaseBatchApex();
      Database.executebatch(batch, 100);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Inside Finish. Success : '+sfidAndJira);
        System.debug('Inside Finish. Error : '+sfidAndJiraError);
        /* Case Status Update Section */
        List<Access_Case__c> listAccessCaseStatusUpdate = new List<Access_Case__c>(); //Access Case Records to Update after Insert
        /* Case Status Update Section */
        /* Case Update Section */
        List<Access_Case__c> listAccessCaseUpdate = new List<Access_Case__c>(); //Access Case Records to Update after Insert
        /* Case Update Section */
        /* Case Insert Section */
        List<Case> listCaseInsert = new List<Case>(); //Case Records to Update after Insert
        List<Access_Case__c> listAccessCaseInsert = new List<Access_Case__c>(); //Access Case Records to Update after Insert
        List<Access_Case__c> listAccessCaseInsertError = new List<Access_Case__c>(); //Access Case Records to Update after Insert if any Error
        List<Access_Case_Tracker__c> listAccessCaseTrackerInsert = new List<Access_Case_Tracker__c>(); //Access Case Tracker to Update after Case Insert
        /* Case Insert Section */
        
        /* New Section */
        //Case Insert Scenario
        List<Access_Case__c> recAccessCaseOnCaseInsert = new List<Access_Case__c>();
        List<Access_Case_Tracker__c> recAccessCaseTrackerOnCaseInsert = new List<Access_Case_Tracker__c>();
        List<Case> recCaseOnCaseInsert = new List<Case>();
        //Case Insert Scenario
        //
        //Case Update Scenario
        List<Access_Case__c> recAccessCaseOnCaseUpdate = new List<Access_Case__c>();
        //Case Update Scenario
        //
        //Case Status Update Scenario
        List<Access_Case__c> recAccessCaseOnCaseStatusUpdate = new List<Access_Case__c>();
        //Case Status Update Scenario
        //
        //Case Comment Insert Scenario 
        List<Access_Case__c> recAccessCaseOnCaseCommentInsert = new List<Access_Case__c>();
        List<Access_Case_Tracker__c> recAccessCaseTrackerOnCaseCommentInsert = new List<Access_Case_Tracker__c>();
        //Case Comment Insert Scenario 
        //
        //Case Comment Update Scenario 
        List<Access_Case__c> recAccessCaseOnCaseCommentUpdate = new List<Access_Case__c>();
        //Case Comment Update Scenario 
        //
        //Case Comment Reply Insert Scenario 
        List<Access_Case__c> recAccessCaseOnCaseCommentReplyInsert = new List<Access_Case__c>();
        List<Access_Case_Tracker__c> recAccessCaseTrackerOnCaseCommentReplyInsert = new List<Access_Case_Tracker__c>();
        //Case Comment Reply Insert Scenario 
        //
        //Case Comment Reply Update Scenario 
        List<Access_Case__c> recAccessCaseOnCaseCommentReplyUpdate = new List<Access_Case__c>();
        //Case Comment Reply Insert Scenario 
        System.debug('Inside Finish. Map : '+sfidAndJira);
        if(sfidAndJiraError.size() > 0){
            String accessCaseIdStr = '';
            for(Access_Case__c accessCaseErrorObj : [SELECT Id, Log__c FROM Access_Case__c WHERE Id IN :sfidAndJiraError.keySet()]){
                Id AccessCaseId = accessCaseErrorObj.Id;
                if(accessCaseIdStr == ''){
                    accessCaseIdStr = String.valueOf(accessCaseErrorObj.Id);
                }else{
                    accessCaseIdStr = accessCaseIdStr+', '+String.valueOf(accessCaseErrorObj.Id); 
                }
                Access_Case__c accessCaseErrorRec = new Access_Case__c();
                accessCaseErrorRec.id = AccessCaseId;
                accessCaseErrorRec.Log__c = sfidAndJiraError.get(AccessCaseId);
                listAccessCaseInsertError.add(accessCaseErrorRec);
            }
            if(listAccessCaseInsertError.size() > 0){
                update listAccessCaseInsertError;
                if(accessCaseIdStr != ''){
                    List<String> toAddress = new List<String>();
                    toAddress.add('syam.mohan@ekinops.com');
                    //toAddress.add('jansan.john@ekinops.com');
                    //toAddress.add('sumeshkumar.areekara@ekinops.com');
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                    mail.setToAddresses(toAddress);
                    mail.setSubject('Error Log - Jira Sync Issue');
                    mail.setPlainTextBody('Issue found while pushing Access Cases to OneTickets.\n For details, Please check the Log field for the below records Ids in Access Case Object. \n \n Record Id/s : '+accessCaseIdStr+'');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
                    
                }
            }
        }
        if(sfidAndJira.size() > 0){
            for(Access_Case__c accessCaseObj : [SELECT Id, Name, Action__c, Case_Id__c, Log__c, Salesforce_Case_Number__c, SF_Type_Object__c, Status__c, SF_Type_Object_Id__c, Updated_On__c, Created_On__c FROM Access_Case__c WHERE Id IN :sfidAndJira.keySet()  ]){
                String mapVal = sfidAndJira.get(accessCaseObj.Id);
                List<String> mapVals = mapVal.split(',');
                String sfObjectType = mapVals[0];
                String otkObjectKey = mapVals[1];
                String otkObjectId = mapVals[2];
                String action = mapVals[3];
                
                String sfObjectTypeVal = accessCaseObj.SF_Type_Object__c;
                String actionVal = accessCaseObj.Action__c;
                System.debug('sfObjectTypeVal : '+sfObjectTypeVal);
                System.debug('actionVal : '+actionVal);
                
                if(sfObjectTypeVal == 'Comment' && actionVal == 'Update' ){
                    Access_Case__c recCaseInsert = new Access_Case__c();
                    recCaseInsert.Id = accessCaseObj.Id;
                    recCaseInsert.Status__c = 'Processed';
                    recAccessCaseOnCaseCommentUpdate.add(recCaseInsert);
                }
                
                if(sfObjectTypeVal == 'Comment' && actionVal == 'Insert' ){
                    Access_Case__c recCaseInsert = new Access_Case__c();
                    recCaseInsert.Id = accessCaseObj.Id;
                    recCaseInsert.Status__c = 'Processed';
                    recAccessCaseOnCaseCommentInsert.add(recCaseInsert);
                    
                    Access_Case_Tracker__c accessTracker = new Access_Case_Tracker__c();
                    accessTracker.SF_Type_Object__c = sfObjectType;
                    accessTracker.SF_Type_Object_Id__c = (String) accessCaseObj.get('SF_Type_Object_Id__c');
                    accessTracker.Salesforce_Case_Number__c = (String) accessCaseObj.get('Salesforce_Case_Number__c');
                    accessTracker.OTK_Issue_Key__c = otkObjectKey;
                    accessTracker.OTK_Object_Id__c = otkObjectId;
                    recAccessCaseTrackerOnCaseCommentInsert.add(accessTracker);
                }
                
                if(sfObjectTypeVal == 'CommentRep' && actionVal == 'Insert' ){
                    Access_Case__c recCaseInsert = new Access_Case__c();
                    recCaseInsert.Id = accessCaseObj.Id;
                    recCaseInsert.Status__c = 'Processed';
                    recAccessCaseOnCaseCommentReplyInsert.add(recCaseInsert);
                    
                    Access_Case_Tracker__c accessTracker = new Access_Case_Tracker__c();
                    accessTracker.SF_Type_Object__c = sfObjectType;
                    accessTracker.SF_Type_Object_Id__c = (String) accessCaseObj.get('SF_Type_Object_Id__c');
                    accessTracker.Salesforce_Case_Number__c = (String) accessCaseObj.get('Salesforce_Case_Number__c');
                    accessTracker.OTK_Issue_Key__c = otkObjectKey;
                    accessTracker.OTK_Object_Id__c = otkObjectId;
                    recAccessCaseTrackerOnCaseCommentReplyInsert.add(accessTracker);
                }
                
                if(sfObjectTypeVal == 'CommentRep' && actionVal == 'Update' ){
                    Access_Case__c recCaseInsert = new Access_Case__c();
                    recCaseInsert.Id = accessCaseObj.Id;
                    recCaseInsert.Status__c = 'Processed';
                    recAccessCaseOnCaseCommentReplyUpdate.add(recCaseInsert);
                }
                
                if(sfObjectTypeVal == 'Case' && actionVal == 'Insert' ){
                    System.debug('Inside Case Insert **');
                    Access_Case__c recCaseInsert = new Access_Case__c();
                    recCaseInsert.Id = accessCaseObj.Id;
                    recCaseInsert.Status__c = 'Processed';
                    recCaseInsert.Log__c = '';
                    recAccessCaseOnCaseInsert.add(recCaseInsert);
                    
                    Access_Case_Tracker__c recAccessTracker = new Access_Case_Tracker__c();
                    recAccessTracker.SF_Type_Object__c = 'Case';
                    recAccessTracker.SF_Type_Object_Id__c = (String) accessCaseObj.get('SF_Type_Object_Id__c');
                    recAccessTracker.Salesforce_Case_Number__c = (String) accessCaseObj.get('Salesforce_Case_Number__c');
                    recAccessTracker.OTK_Issue_Key__c = otkObjectKey;
                    recAccessTracker.OTK_Object_Id__c = otkObjectId;
                    recAccessCaseTrackerOnCaseInsert.add(recAccessTracker);
                    
                    Case recCase = new Case();
                    recCase.Id = (Id)accessCaseObj.SF_Type_Object_Id__c;
                    recCase.SAC_Onetickets_Ticket__c = otkObjectKey;
                    recCaseOnCaseInsert.add(recCase);
                }
                
                if(sfObjectTypeVal == 'Case' && actionVal == 'Update'){
                    System.debug('Inside Update 201');
                    String accessCaseIds =mapVals[4];
                    if(mapVals[4] != 'null'){
                    	string[] splitted = accessCaseIds.split(':');
                        System.debug('splitted 1 : '+splitted);
                        System.debug('splitted Length 2 : '+splitted.size());
                        for(Integer splitindex=0;splitindex<splitted.size();splitindex++){
                            Id AccessCaseId = (Id)splitted[splitindex];
                            System.debug('AccessCaseId : '+AccessCaseId);
                            Access_Case__c recCaseUpdate = new Access_Case__c();
                            recCaseUpdate.Id = AccessCaseId;
                            recCaseUpdate.Status__c = 'Processed';
                            recAccessCaseOnCaseUpdate.add(recCaseUpdate);
                        }    
                    }
                    
                    /*System.debug('Inside Case Update **');
                    Access_Case__c recCaseUpdate = new Access_Case__c();
                    recCaseUpdate.Id = accessCaseObj.Id;
                    recCaseUpdate.Status__c = 'Processed';
                    recAccessCaseOnCaseUpdate.add(recCaseUpdate);*/
                }
                
                if(sfObjectTypeVal == 'Status' && actionVal == 'Update'){
                    System.debug('Inside Update 222');
                    if(mapVals[4] != 'null'){
                       String accessCaseIds = mapVals[4];
                        string[] splitted = accessCaseIds.split(':');
                        System.debug('splitted 3: '+splitted);
                        System.debug('splitted Length 4: '+splitted.size());
                        for(Integer splitindex=0;splitindex<splitted.size();splitindex++){
                            Id AccessCaseId = (Id)splitted[splitindex];
                            System.debug('AccessCaseId : '+AccessCaseId);
                            Access_Case__c recCaseUpdate = new Access_Case__c();
                            recCaseUpdate.Id = AccessCaseId;
                            recCaseUpdate.Status__c = 'Processed';
                            recAccessCaseOnCaseStatusUpdate.add(recCaseUpdate);
                        } 
                    }
                    
                    /*System.debug('Inside Status Update **');
                    Access_Case__c recCaseStatusUpdate = new Access_Case__c();
                    recCaseStatusUpdate.Id = accessCaseObj.Id;
                    recCaseStatusUpdate.Status__c = 'Processed';
                    recAccessCaseOnCaseStatusUpdate.add(recCaseStatusUpdate);*/
                }
            }
        }
        if(recAccessCaseOnCaseInsert.size() > 0){
            update recAccessCaseOnCaseInsert;
        }
        if(recAccessCaseTrackerOnCaseInsert.size() > 0){
            insert recAccessCaseTrackerOnCaseInsert;
        }
        if(recCaseOnCaseInsert.size() > 0){
            update recCaseOnCaseInsert;
        }
        if(recAccessCaseOnCaseUpdate.size() > 0){
            update recAccessCaseOnCaseUpdate;
        }
        if(recAccessCaseOnCaseStatusUpdate.size() > 0){
            update recAccessCaseOnCaseStatusUpdate;
        }
        if(recAccessCaseOnCaseCommentInsert.size() > 0){
            update recAccessCaseOnCaseCommentInsert;
        }
        if(recAccessCaseTrackerOnCaseCommentInsert.size() > 0){
            insert recAccessCaseTrackerOnCaseCommentInsert;
        }
        if(recAccessCaseOnCaseCommentUpdate.size() > 0){
            update recAccessCaseOnCaseCommentUpdate;
        }
        if(recAccessCaseOnCaseCommentReplyInsert.size() > 0){
            update recAccessCaseOnCaseCommentReplyInsert;
        }
        if(recAccessCaseTrackerOnCaseCommentReplyInsert.size() > 0){
            insert recAccessCaseTrackerOnCaseCommentReplyInsert;
        }
        if(recAccessCaseOnCaseCommentReplyUpdate.size() > 0){
            update recAccessCaseOnCaseCommentReplyUpdate;
        }
        /* New Section */
        /*
        if(sfidAndJira.size() > 0){
            for(Id key:sfidAndJira.keySet()){
                String mapVal = sfidAndJira.get(key);
                List<String> mapVals = mapVal.split(',');
                String sfObjectType = mapVals[0];
                String otkObjectKey = mapVals[1];
                String otkObjectId = mapVals[2];
                String action = mapVals[3];
                
                if(sfObjectType == 'Case' && action == 'Update' ){
                    String sfObjectId = (String) key;
                    for(Access_Case__c accessCaseObj : [SELECT Id, Name, CreatedDate, CreatedById, Case_Id__c, Action__c, SF_Type_Object__c, SF_Type_Object_Id__c, Status__c, Salesforce_Case_Number__c, Created_On__c FROM Access_Case__c WHERE SF_Type_Object_Id__c =:sfObjectId AND Action__c = 'Update' AND SF_Type_Object__c='Case' ]){
                        Access_Case__c accessCaseRec = new Access_Case__c();
                        accessCaseRec.Id = accessCaseObj.Id;
                        accessCaseRec.Status__c = 'Processed';
                        listAccessCaseUpdate.add(accessCaseRec);
                    }
                }
                
                if(sfObjectType == 'Status' && action == 'Update' ){
                    String sfObjectId = (String) key;
                    for(Access_Case__c accessCaseObj : [SELECT Id, Name, CreatedDate, CreatedById, Case_Id__c, Action__c, SF_Type_Object__c, SF_Type_Object_Id__c, Status__c, Salesforce_Case_Number__c, Created_On__c FROM Access_Case__c WHERE SF_Type_Object_Id__c =:sfObjectId AND Action__c = 'Update' AND SF_Type_Object__c='Status' ]){
                        Access_Case__c accessCaseRec = new Access_Case__c();
                        accessCaseRec.Id = accessCaseObj.Id;
                        accessCaseRec.Status__c = 'Processed';
                        listAccessCaseStatusUpdate.add(accessCaseRec);
                    }
                    
                }
                if(sfObjectType == 'Case' && action == 'Insert' ){
                    
                    System.debug('Inside Case Insert - Batch Apex');
                    AccessCaseHandler.canPerformUpdate = false;
                    System.debug('AccessCaseHandler.canPerformUpdate 1 : '+AccessCaseHandler.canPerformUpdate);
                    Access_Case__c accessCaseRec = [SELECT Id, Name, CreatedDate, CreatedById, Case_Id__c, Action__c, SF_Type_Object__c, SF_Type_Object_Id__c, Status__c, Salesforce_Case_Number__c, Created_On__c FROM Access_Case__c WHERE Id =:key ];
                    Id caseId = (Id)accessCaseRec.SF_Type_Object_Id__c;
                    Access_Case__c accessCaseRecToUpdate = new Access_Case__c();
                    accessCaseRecToUpdate.Id = accessCaseRec.Id;
                    accessCaseRecToUpdate.Status__c = 'Processed';
                    listAccessCaseInsert.add(accessCaseRecToUpdate);
                    //update accessCaseRecToUpdate;
                    
                    Case caseRecToUpdate = new Case();
                    caseRecToUpdate.Id = caseId;
                    caseRecToUpdate.SAC_Onetickets_Ticket__c = otkObjectKey;
                    listCaseInsert.add(caseRecToUpdate);
                    //update caseRecToUpdate;
                    
                    Access_Case_Tracker__c accessTracker = new Access_Case_Tracker__c();
                    accessTracker.SF_Type_Object__c = 'Case';
                    accessTracker.SF_Type_Object_Id__c = (String) accessCaseRec.get('SF_Type_Object_Id__c');
                    accessTracker.Salesforce_Case_Number__c = (String) accessCaseRec.get('Salesforce_Case_Number__c');
                    accessTracker.OTK_Issue_Key__c = otkObjectKey;
                    accessTracker.OTK_Object_Id__c = otkObjectId;
                    listAccessCaseTrackerInsert.add(accessTracker);
                    //insert accessTracker;
                }
                if( (sfObjectType == 'Comment' || sfObjectType == 'CommentRep') && action == 'Insert' ){
                    Access_Case__c accessCaseRec = [SELECT Id, Name, CreatedDate, CreatedById, Case_Id__c, Action__c, SF_Type_Object__c, SF_Type_Object_Id__c, Status__c, Salesforce_Case_Number__c, Created_On__c FROM Access_Case__c WHERE Id =:key ];
                    Id caseCommentId = (Id)accessCaseRec.SF_Type_Object_Id__c;
                    Access_Case__c accessCaseRecToUpdate = new Access_Case__c();
                    accessCaseRecToUpdate.Id = accessCaseRec.Id;
                    accessCaseRecToUpdate.Status__c = 'Processed';
                    update accessCaseRecToUpdate;
                    
                    Access_Case_Tracker__c accessTracker = new Access_Case_Tracker__c();
                    accessTracker.SF_Type_Object__c = sfObjectType;
                    accessTracker.SF_Type_Object_Id__c = (String) accessCaseRec.get('SF_Type_Object_Id__c');
                    accessTracker.Salesforce_Case_Number__c = (String) accessCaseRec.get('Salesforce_Case_Number__c');
                    accessTracker.OTK_Issue_Key__c = otkObjectKey;
                    accessTracker.OTK_Object_Id__c = otkObjectId;
                    insert accessTracker;
                }
                if( (sfObjectType == 'Comment' || sfObjectType == 'CommentRep') && action == 'Update' ){
                    String sfObjectId = (String) key;
                    List<Access_Case__c> accessCaseRec = new List<Access_Case__c>();
                    accessCaseRec = [SELECT Id, Name, CreatedDate, CreatedById, Case_Id__c, Action__c, SF_Type_Object__c, SF_Type_Object_Id__c, Status__c, Salesforce_Case_Number__c, Created_On__c FROM Access_Case__c WHERE Id =:sfObjectId AND Action__c = 'Update' ];
                    for(Access_Case__c accessCaseObj : accessCaseRec){
                        accessCaseObj.Status__c = 'Processed';
                    }
                    if(accessCaseRec.size() > 0){
                    	update accessCaseRec;    
                    }
                }
            }
        }
        */
        /*
        //Case Status Update
        if(listAccessCaseStatusUpdate.size() > 0){
            update listAccessCaseStatusUpdate;
        }
        //Case Update
        if(listAccessCaseUpdate.size() > 0){
            update listAccessCaseUpdate;
        }
        //Case Insert
        if(listCaseInsert.size() > 0){
            System.debug('Inside Case Update');
            update listCaseInsert;
        }
        if(listAccessCaseTrackerInsert.size() > 0){
            System.debug('Inside Access Case Tracker Insert');
            insert listAccessCaseTrackerInsert;
        }
        if(listAccessCaseInsert.size() > 0){
            System.debug('Inside Access Case Update');
            update listAccessCaseInsert;
        }
		*/
    }
}