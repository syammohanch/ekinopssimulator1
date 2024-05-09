public class AccessCaseFeebackAutoClosure implements Database.Batchable<sObject>,Database.Stateful,Schedulable  { 
    Private String  feedbackStatus;
    Private integer durationInDays;
    Private boolean dryRunMode;
    Private String  dryRunModeEmailId;
    Private List<String> caseNumbersList = new List<String>();
    Private Datetime startDatetime;
    Private Datetime endDatetime;
    Private EkiCustomConfig__c customConfig;
    Private String comment;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        
        //List<AccessCaseAutoClosure__mdt> autoClosureConfig = AccessCaseAutoClosure__mdt.getAll().values();
        List<AccessCaseAutoClosure__mdt> autoClosureConfig   = EkinopsUtilities.getCustomMetaDataRecords('SELECT IsDryRunMode__c, Feedback_Auto_Closure_Duration__c, DryRunModeEmailId__c,Feedback_Auto_Closure_Comment__c FROM AccessCaseAutoClosure__mdt');
        
        feedbackStatus  	   = 'Waiting customer feedback';
        durationInDays 	   	   = 1000;
        dryRunMode			   = false;
        dryRunModeEmailId      = '';
        comment			       = '';
          
         if (!autoClosureConfig.isEmpty()) {
			dryRunMode        = autoClosureConfig[0].IsDryRunMode__c;
            durationInDays    = (Integer)autoClosureConfig[0].Feedback_Auto_Closure_Duration__c;
            dryRunModeEmailId = autoClosureConfig[0].DryRunModeEmailId__c; 
            comment			  = autoClosureConfig[0].Feedback_Auto_Closure_Comment__c; 
		 }
        Date currentDate       = Date.today();
        Date startDate 		   = currentDate.addDays(-durationInDays);
        
        startDatetime = Datetime.newInstance(2021,01,01, 0, 0,0);
        endDatetime   = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 23, 59, 59);
        String accessRecordType         = 'Access'; 
        return Database.getQueryLocator('SELECT Id,CaseNumber, Status, AccountId, Account.Name, CreatedBy.Email, Owner.Email, ContactEmail, EmailNotification__c FROM Case WHERE Case_Record_Type_Name__c =:accessRecordType AND Status =:feedbackStatus AND LastModifiedDate >=:startDatetime AND LastModifiedDate <=:endDatetime');
    }

    public void execute(Database.BatchableContext context, List<Case> scope) {
        for (Case caseInfo : scope) 
        {	
            caseNumbersList.add(caseInfo.CaseNumber); 
            
            if(dryRunMode != true) {
                caseInfo.Status = 'Closed';
                CustomCommentFeederController.createFeedItemRec(caseInfo.Id,comment);
            }
        }
        if(dryRunMode != true) {
            update scope;
        }
    }

    public void finish(Database.BatchableContext context) {
        String subject  = '[Access][Case] Auto Closure Case In Feedback Status';
        if(dryRunMode == true){
              subject  = '[Access][Case][DryRun] Auto Closure Case In Feedback Status';
        }
        String caseNumberMailBody = '';
        if(caseNumbersList.size() > 0) {
            caseNumberMailBody+= '<ul>';
            for(String caseNo : caseNumbersList) {
                caseNumberMailBody+='<li>'+caseNo+'</li>';
            }
            caseNumberMailBody+='</ul>';
        } else {
            caseNumberMailBody = 'No Cases in the qualified list';
        }
        
        String htmlBody = '<html><body><p>Below Cases are marked as Closed due to long time inactivity(No updates after '+endDatetime.format('yyyy-MM-dd HH:mm:ss')+')</p></br/>'+caseNumberMailBody+'</body></html>';
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        List<String> emailAddressesList    = new List<String>();
        List<String> ccAddressesList       = new List<String>();
        List<String> bccAddressesList      = new List<String>();
        
        List<String> dryRunModeEmailList   = dryRunModeEmailId.split(',');
        if(dryRunModeEmailList.size()>0) {
            for(String email : dryRunModeEmailList) {
                emailAddressesList.add(email.trim());
            }
            
        }
        emailList.add(EkinopsUtilities.composeMail(emailAddressesList,ccAddressesList, bccAddressesList, subject, htmlBody));
        Messaging.sendEmail(emailList);
   }
   public void execute(SchedulableContext ctx) {
      AccessCaseFeebackAutoClosure batch = new AccessCaseFeebackAutoClosure();
      Database.executebatch(batch, 200);
   } 
}