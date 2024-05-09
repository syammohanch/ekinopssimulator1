public class EmailNotificationCollection {
    @InvocableMethod(label='Email Notification Email')
    public static List<List<String>> sendEmailList(List<String> recEmailNotificationList){
        List<List<String>> emailReturnList = new List<List<String>>();
        System.debug('Inside 1');
        List<String> emailList = new List<String>();
        //emailList.add('syam.mohan@ekinops.com');
        //System.debug('recEmailNotificationList 123 : '+recEmailNotificationList); 
        //System.debug('recEmailNotificationList 123 Count : '+recEmailNotificationList.size()); 
        for(String emailVal:recEmailNotificationList){
            //System.debug('Val : '+emailVal);
            if(emailVal.contains(',')){
                System.debug('Contains , ');
                List<String> emailSplitList = emailVal.split(',');
                //System.debug('emailSplitList : '+emailSplitList);
                for(String emailValSplit:emailSplitList){
                    emailList.add(emailValSplit);
                }
            }else{
                System.debug('Not Contains , ');
                emailList.add(emailVal);
            }
        }
        emailReturnList.add(emailList);
        System.debug('Final List *** : '+emailList);
        System.debug('Final 2 : '+emailReturnList);
        return emailReturnList;
    }
}