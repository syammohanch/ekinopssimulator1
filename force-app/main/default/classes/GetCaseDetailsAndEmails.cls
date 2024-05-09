public class GetCaseDetailsAndEmails {
	@InvocableMethod(label='Get Case Emails')
    public static List<List<String>> sendEmailList(List<Id> recCaseId){
        List<List<String>> emailReturnList = new List<List<String>>();
        System.debug('Case Id : '+recCaseId);
        List<String> caseRecDetails = new List<String>();
        Set<String> caseRecDetailsTemp = new Set<String>();
        for(Case caseRec : [SELECT Id, CreatedById, CreatedBy.Email, Contact.Email, OwnerId, Owner.Email, EmailNotification__c FROM Case WHERE Id =: recCaseId]){
            String createdEmail = caseRec.CreatedBy.Email;
            String ownerEmail = caseRec.Owner.Email;
            String emailNotification = caseRec.EmailNotification__c;
            if(caseRec.CreatedBy.Email != null && caseRec.CreatedBy.Email != ''){
                //caseRecDetails.add(caseRec.CreatedBy.Email);
                caseRecDetailsTemp.add(caseRec.CreatedBy.Email);
            }
            if(caseRec.Owner.Email != null && caseRec.Owner.Email != ''){
                //caseRecDetails.add(caseRec.Owner.Email);
                caseRecDetailsTemp.add(caseRec.Owner.Email);
            }
            if(caseRec.Contact.Email != null && caseRec.Contact.Email != ''){
                //caseRecDetails.add(caseRec.Contact.Email);
                caseRecDetailsTemp.add(caseRec.Contact.Email);
            }
            if(caseRec.EmailNotification__c != null && caseRec.EmailNotification__c != ''){
                //caseRecDetails.add(caseRec.EmailNotification__c);
                //caseRecDetailsTemp.add(caseRec.EmailNotification__c);
                String emailVal = caseRec.EmailNotification__c;
                if(emailVal.contains(',')){
                    System.debug('Contains , ');
                    List<String> emailSplitList = emailVal.split(',');
                    //System.debug('emailSplitList : '+emailSplitList);
                    for(String emailValSplit:emailSplitList){
                        caseRecDetailsTemp.add(emailValSplit);
                    }
                }else{
                    caseRecDetailsTemp.add(emailVal);
                }
                
            }
        }
        caseRecDetails = new List<String>(caseRecDetailsTemp);
        emailReturnList.add(caseRecDetails);
        return emailReturnList;
    }
}