public class CaseRedirect {
    public Case cs;
    ApexPages.StandardController controller;
    public String emailNotificationErrorMessage {get; set;}
    public CaseRedirect(ApexPages.StandardController con)
    {
        controller = con;
        this.cs = (Case) con.getRecord();
    }
	public pagereference Redirect()
    {
        System.debug('Record Type * : '+ApexPages.currentPage().getParameters().get('RecordType'));
        System.debug('Record Type Name * : '+ApexPages.currentPage().getParameters().get('RecordType'));
        Id selectedRecType = ApexPages.currentPage().getParameters().get('RecordType');
        System.debug('selectedRecType * : '+selectedRecType);
        RecordType recordType = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE Id=:selectedRecType];
        String selectedRecTypeName = recordType.Name;
        System.debug('Record Type Name : '+selectedRecTypeName);
         If(selectedRecTypeName != 'Access')
         {
               String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
             	System.debug('hostname : '+hostname);
               String optyURL2 = 'https://'+hostname+'/'+'500/e?RecordType='+selectedRecType+'&nooverride=1&ent=Case';
               pagereference pageref = new pagereference(optyURL2);
               pageref.setredirect(true);
               return pageref;
         }
         else
              return null;
    }
    
    public PageReference  doCustomValidations() {
        Boolean isFormError  = false; 
        String  emailAddress = (String) this.cs.get('EmailNotification__c');
        List<String> invalidEmails = new List<String>();
        
        if(!String.isBlank(emailAddress)) {
            String[] emails      = emailAddress.split(',');
            for (String email : emails) {
                email = email.trim(); 
                if (!EkinopsUtilities.isValidEmail(email)) {
                    invalidEmails.add(email);
                }
            }
        }
        if (!invalidEmails.isEmpty()) {
          //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email: ' + String.join(invalidEmails,', ')+' in Email Notification');
          //ApexPages.addMessage(errorMessage);
          emailNotificationErrorMessage = 'Please check the email addresses you provided. Make sure they are correctly formatted and separated by commas.';
          isFormError = true;
        }
         
        if(!isFormError) {
            try {
                insert this.cs;
                PageReference pg = new PageReference('/'+this.cs.get('Id'));
                pg.setRedirect(true);
                return pg; 
            }catch (Exception e) {
                emailNotificationErrorMessage = '';
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while saving the record.'));
            	return null;
        	}
        }
        return null;
    }
}