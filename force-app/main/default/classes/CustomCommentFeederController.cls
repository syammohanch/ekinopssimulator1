public with sharing class CustomCommentFeederController {
	@AuraEnabled
    public static void createFeedItemRec(string parentId, string comments){
        System.debug('parentId : '+parentId);
        System.debug('comments : '+comments);
    	try {
            String commentsTemp = comments;
            if(commentsTemp.contains('class="ql-indent-1"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-1"', '');
            }
            if(commentsTemp.contains('class="ql-indent-2"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-2"', '');
            }
            if(commentsTemp.contains('class="ql-indent-3"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-3"', '');
            }
            if(commentsTemp.contains('class="ql-indent-4"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-4"', '');
            }
            if(commentsTemp.contains('class="ql-indent-5"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-5"', '');
            }
            if(commentsTemp.contains('class="ql-indent-6"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-6"', '');
            }
            if(commentsTemp.contains('class="ql-indent-7"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-7"', '');
            }
            if(commentsTemp.contains('class="ql-indent-8"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-8"', '');
            }
            if(commentsTemp.contains('class="ql-indent-9"')){
                commentsTemp = commentsTemp.replaceAll('class="ql-indent-9"', '');
            }
            if(commentsTemp.contains('<strong>')){
                commentsTemp = commentsTemp.replaceAll('<strong>', '<b>');
            }
            if(commentsTemp.contains('</strong>')){
                commentsTemp = commentsTemp.replaceAll('</strong>', '</b>');
            }
            if(commentsTemp.contains('<em>')){
                commentsTemp = commentsTemp.replaceAll('<em>', '<i>');
            }
            if(commentsTemp.contains('</em>')){
                commentsTemp = commentsTemp.replaceAll('</em>', '</i>');
            }
            if(commentsTemp.contains('<strike>')){
                commentsTemp = commentsTemp.replaceAll('<strike>', '<s>');
            }
            if(commentsTemp.contains('</strike>')){
                commentsTemp = commentsTemp.replaceAll('</strike>', '</s>');
            }
            if(commentsTemp.contains('<br>')){
                commentsTemp = commentsTemp.replaceAll('<br>', '<p>&nbsp;</p>');
            }
            FeedItem feedItemObj = new FeedItem();
            feedItemObj.ParentId = parentId;
            feedItemObj.Body = commentsTemp;
            feedItemObj.IsRichText = true;
            //System.debug('Inside Try');
            System.debug('comments : '+commentsTemp);
            insert feedItemObj;
            //return feedItemRec;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,String>> getAllowedAccessCaseStatus(String profileId, String currentStatus) {
        System.debug('profileId : '+profileId);
        System.debug('currentStatus : '+currentStatus);
        Map<String,Map<String,String>> allowedStatus = new Map<String,Map<String,String>>();
        Map<String,String> statusInfo = new Map<String,String>();
        
        //As of now, we are not considering the User Profile for getting the target Status options
        /*List<Id> workflowStepsId = new List<Id>(); 
        for (Access_Case_Workflow_Step_Profile__c workflowStepsProfileObj : [SELECT Access_Case_Workflow_Step__c FROM Access_Case_Workflow_Step_Profile__c]) {
        	 workflowStepsId.add(workflowStepsProfileObj.Access_Case_Workflow_Step__c);
        }
		if(workflowStepsId.size()>0) {
            for (Access_Workflow_Steps__c workflowStepsObj : [SELECT To_Status__c FROM Access_Workflow_Steps__c
                                                                     WHERE From_Status__c =:currentStatus AND Id IN:workflowStepsId]) {
                  statusInfo.put('name',workflowStepsObj.To_Status__c);
                  allowedStatus.put(workflowStepsObj.To_Status__c,statusInfo);     
            }
        }
		*/	
        for (Access_Workflow_Steps__c workflowStepsObj : [SELECT To_Status__c FROM Access_Workflow_Steps__c WHERE From_Status__c =:currentStatus]) {
                  statusInfo.put('name',workflowStepsObj.To_Status__c);
                  allowedStatus.put(workflowStepsObj.To_Status__c,statusInfo);     
        }
        System.debug(allowedStatus);
        return allowedStatus;
    }
    
}