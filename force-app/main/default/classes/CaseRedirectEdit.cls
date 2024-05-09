public class CaseRedirectEdit {
	public Case cs;
    ApexPages.StandardController controller;
    private String vid;
    public String emailNotificationErrorMessage {get; set;}
    public CaseRedirectEdit(ApexPages.StandardController con)
    {
        controller = con;
        this.cs = (Case) con.getRecord();  
       
    }
	public pagereference Redirectedit()
    {
        System.debug('Record Type : '+ApexPages.currentPage().getParameters().get('RecordType'));
        System.debug('Id : '+ApexPages.currentPage().getParameters().get('Id'));
        Id caseRecId = ApexPages.currentPage().getParameters().get('Id');
        this.vid = ApexPages.currentPage().getParameters().get('Id');
        Case caseRec = [SELECT Id, RecordTypeId, RecordType.Name FROM Case WHERE Id=:caseRecId];
        System.debug('Record Type Name : '+caseRec.RecordType.Name);
         If(caseRec.RecordType.Name != 'Access')
         {
               Case c = (Case)controller.getRecord();
               PageReference newPage;
               newPage = new PageReference('/' + c.id + '/e');
               newPage.getParameters().put('nooverride', '1');
               return newPage;
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
                //controller.save();
                update this.cs;
                PageReference pg = new PageReference('/'+Apexpages.currentPage().getParameters().get('id'));
                pg.setRedirect(true);
                return pg;
            }
            catch (Exception e) {
                emailNotificationErrorMessage = '';
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while saving the record.'));
            	return null;
        	}
        }
        return null;
    } 
    
}