public class EkinopsUtilities {
     @testVisible static Private Map<String, List<SObject>> customMetaDataRecordsMap = new Map<String, List<SObject>>();
     public static Messaging.SingleEmailMessage composeMail(List<String> toAddressesList,List<String> ccAddressesList,List<String> bccAddressesList, String subject, String message )
     {
         //List<Ekinops_Mail_Settings__mdt> ekiEmailSettings = Ekinops_Mail_Settings__mdt.getAll().values();
         List<Ekinops_Mail_Settings__mdt> ekiEmailSettings   = EkinopsUtilities.getCustomMetaDataRecords('SELECT Is_Rerouting_Enabled__c, Rerouting_Email_Address_1__c,Org_Name__c FROM Ekinops_Mail_Settings__mdt');
         boolean isReroutingEnabled  	       = false;
         String  reroutingEmailAddress         = '';
         String  reroutingSubjectPrefix        = ''; 
         if (!ekiEmailSettings.isEmpty()) {
			isReroutingEnabled      = ekiEmailSettings[0].Is_Rerouting_Enabled__c;
            reroutingEmailAddress   = ekiEmailSettings[0].Rerouting_Email_Address_1__c;
            reroutingSubjectPrefix  = ekiEmailSettings[0].Org_Name__c;
		 }
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
         if(toAddressesList.size() >0) {
             if(!isReroutingEnabled) {
                 email.setToAddresses(toAddressesList);
                 if(ccAddressesList.size() >0) {
                    email.setCcAddresses(ccAddressesList);
                 }
                 if(bccAddressesList.size() >0) {
                    email.setBccAddresses(bccAddressesList);
                 }
             }
             else {
                   if(!String.isBlank(reroutingEmailAddress))
                   {
                       List<String> reroutingEmailAddressList    = new List<String>();
                       reroutingEmailAddressList    = reroutingEmailAddress.split(',');
                       email.setToAddresses(reroutingEmailAddressList);
                   }
                 
                  String  recipientEmail =  String.join(toAddressesList, ', ');
                  if(ccAddressesList.size() >0) {
                     recipientEmail+=' CC:'+String.join(ccAddressesList, ', ');
                  }
                  if(bccAddressesList.size() >0) {
                     recipientEmail+=' BCC:'+String.join(bccAddressesList, ', ');
                  }
                 
                  //Append all original email id to the message.
                  message+='<br/><br/><div style="background-color:#fcf638;padding:4px;border:1px solid #999;">';
                  message+='This is a rerouted mail. Actual recipient is '+recipientEmail;
                  message+='</div>';
                 
                 subject = reroutingSubjectPrefix+subject;
                 
             }
             email.setSubject(subject);
             email.setHtmlBody(message);
         }
         return email;
    }
    public static List<SObject> getCustomMetaDataRecords(String query) 
    {
        if(!customMetaDataRecordsMap.containsKey(query)) {
            customMetaDataRecordsMap.put(query, Database.query(query));
        }
        return customMetaDataRecordsMap.get(query);
    }
    
    public static Boolean isValidEmail(String email) {
        String emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';
        if (String.isBlank(email)) {
            return false;
        }
        Boolean isValid = Pattern.matches(emailPattern, email);
        if (isValid) {
         	String[] parts = email.split('@');
            if (parts.size() != 2 || parts[1].indexOf('.') == -1) {
                isValid = false;
            }
        }
        return isValid;
    }    
}