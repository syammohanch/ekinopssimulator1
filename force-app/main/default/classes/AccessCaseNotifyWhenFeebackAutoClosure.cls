public class AccessCaseNotifyWhenFeebackAutoClosure implements Database.Batchable<sObject>,Database.Stateful,Schedulable  {
    Private String  feedbackStatus;
    Private integer durationInDays;
    Private boolean dryRunMode;
    Private String  dryRunModeEmailId;
    Private String  additionalMailTo;
    Private List<String> caseNumbersList = new List<String>();
    Private String mailSubjectTemplate;
    Private String mailBodyTemplate;
    Private String portalUrl;
    Private Datetime startDatetime;
    Private Datetime endDatetime;
    Private EkiCustomConfig__c customConfig;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        //List<AccessCaseAutoClosure__mdt> autoClosureConfig = AccessCaseAutoClosure__mdt.getAll().values();
        List<AccessCaseAutoClosure__mdt> autoClosureConfig   = EkinopsUtilities.getCustomMetaDataRecords('SELECT IsDryRunMode__c, Feedback_Notify_Auto_Closure_Duration__c,PortalURL__c, DryRunModeEmailId__c,Feedback_Notify_Auto_Closure_Addi_Email__c FROM AccessCaseAutoClosure__mdt');
        
        feedbackStatus  	   = 'Waiting customer feedback';
        durationInDays 	   	   = 1000;
        dryRunMode			   = false;
        dryRunModeEmailId      = '';
        portalUrl			   = '';
        additionalMailTo       = '';
         if (!autoClosureConfig.isEmpty()) {
			dryRunMode        = autoClosureConfig[0].IsDryRunMode__c;
            durationInDays    = (Integer)autoClosureConfig[0].Feedback_Notify_Auto_Closure_Duration__c;
            portalUrl         = autoClosureConfig[0].PortalURL__c;
            dryRunModeEmailId = autoClosureConfig[0].DryRunModeEmailId__c; 
            additionalMailTo  = autoClosureConfig[0].Feedback_Notify_Auto_Closure_Addi_Email__c; 
		 }
        
        String emailTemplateName    = 'Access_Case_Feedback_Auto_Closure_Notification';
        EmailTemplate emailTemplate = [SELECT Id, Name, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :emailTemplateName];
        
		mailSubjectTemplate    = emailTemplate.Subject; 
        mailBodyTemplate 	   = emailTemplate.HtmlValue;
        Date currentDate       = Date.today();
        Date startDate 		   = currentDate.addDays(-durationInDays);
        
        customConfig = [SELECT Id,Value__c FROM EkiCustomConfig__c WHERE Namespace__c = 'AccessCase' AND Key__c = 'AccessCase:Feedback:AutoClosureNotification:LastProcessedOn'];
        
        startDatetime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 0, 0,0);
        endDatetime   = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 23, 59, 59);
        if(!String.isBlank(customConfig.Value__c)) {
           startDatetime = Datetime.valueOf(customConfig.Value__c);
        }
        String accessRecordType         = 'Access'; 
        return Database.getQueryLocator('SELECT Id,CaseNumber, Status, AccountId, Account.Name, CreatedBy.Email, Owner.Email, ContactEmail, EmailNotification__c FROM Case WHERE Case_Record_Type_Name__c =:accessRecordType AND Status =:feedbackStatus AND LastModifiedDate >=:startDatetime AND LastModifiedDate <=:endDatetime');
    }

    public void execute(Database.BatchableContext context, List<Case> scope) {
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        String casePermaLink, mailSubject, mailBody;
        for (Case caseInfo : scope) 
        {	
            caseNumbersList.add(caseInfo.CaseNumber); 
            
            if(!String.isBlank(caseInfo.AccountId) && dryRunMode != true) {
                mailSubject = mailSubjectTemplate;
                mailBody    = mailBodyTemplate;
                
                mailSubject = mailSubject.replace('{VAR.customerName}', caseInfo.Account.Name);
                mailSubject = mailSubject.replace('{VAR.caseNumber}', caseInfo.CaseNumber);
                
                
                casePermaLink = portalUrl.replace('{VAR.CaseId}', caseInfo.id);
                mailBody 	  = mailBody.replace('{VAR.caseLink}', casePermaLink);
                
                List<String> emailAddressesList    = new List<String>();
                List<String> ccAddressesList       = new List<String>();
                List<String> bccAddressesList      = new List<String>();
                
                emailAddressesList.add(caseInfo.CreatedBy.Email);
                if (!emailAddressesList.contains(caseInfo.Owner.Email)) {
                	emailAddressesList.add(caseInfo.Owner.Email);
                }
                if (!emailAddressesList.contains(caseInfo.Owner.Email)) {
                	emailAddressesList.add(caseInfo.Owner.Email);
                }
                
                String email = caseInfo.ContactEmail;
                if (!String.isBlank(email) && !emailAddressesList.contains(email)) {
                    emailAddressesList.add(email);
                }
                
                List<String> otherEmailList    = new List<String>();
                if(!String.isBlank(CaseInfo.EmailNotification__c))
                {
                    otherEmailList = CaseInfo.EmailNotification__c.split(',');
                    if(otherEmailList.size()>0) {
                        for(String otherMail : otherEmailList) {
                            otherMail = otherMail.trim();
                            if (!String.isBlank(otherMail)&& !emailAddressesList.contains(otherMail)) {
                                emailAddressesList.add(otherMail);
                            }
                        }
                    }
                }
                if(!String.isBlank(additionalMailTo))
                {
                    otherEmailList    = additionalMailTo.split(',');
                    if(otherEmailList.size()>0) {
                        for(String otherMail : otherEmailList) {
                            if (!String.isBlank(otherMail) && !emailAddressesList.contains(otherMail)) {
                                otherMail = otherMail.trim();
                                emailAddressesList.add(otherMail);
                            }
                        }
                    }
                }
                for(String toEmail : emailAddressesList) {
                   List<String> toEmailList    = new List<String>();
                   toEmailList.add(toEmail);
                   emailList.add(EkinopsUtilities.composeMail(toEmailList,ccAddressesList, bccAddressesList, mailSubject, mailBody));
                }
            }
        }
        if(emailList.size()>0 && dryRunMode != true) {
            try
            {
                Messaging.sendEmail(emailList);
            } catch(Exception e) {
                System.debug('Exception Line Number:'+e.getLineNumber());
                System.debug('Exception Message:'+e.getMessage());
                System.debug('Exception Cause:'+e.getCause());
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        String subject  = '[Access][Case] Notify Users Of Auto Closure Case In Feedback Status';
        if(dryRunMode == true){
              subject  = '[Access][Case][DryRun] Notify Users Of Auto Closure Case In Feedback Status';
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
        
        String htmlBody = '<html><body><p>Below Cases are marked for closure in 2 weeks from now due to long time inactivity(From: '+startDatetime.format('yyyy-MM-dd HH:mm:ss')+' To '+endDatetime.format('yyyy-MM-dd HH:mm:ss')+')</p></br/>'+caseNumberMailBody+'</body></html>';
        
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
        try
        {
            Messaging.sendEmail(emailList);
        } catch(Exception e) {
            System.debug('Exception Line Number:'+e.getLineNumber());
            System.debug('Exception Message:'+e.getMessage());
            System.debug('Exception Cause:'+e.getCause());
        }
        
         if(dryRunMode == false){
            customConfig.Value__c = endDatetime.format('yyyy-MM-dd HH:mm:ss');
            update customConfig;
          }
   }
   public void execute(SchedulableContext ctx) {
      AccessCaseNotifyWhenFeebackAutoClosure batch = new AccessCaseNotifyWhenFeebackAutoClosure();
      Database.executebatch(batch, 200);
   }
}