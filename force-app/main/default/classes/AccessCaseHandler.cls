public class AccessCaseHandler {
    public static boolean canPerformUpdate = true;
    /* Fetching the JIRA Endpoint Details from Custom Metadata Types */
    public static Map<String, Object> jiraEndpointDetails(){
        List<Access_Case_Jira_SAC_Setting__mdt> customMetadataRec = Access_Case_Jira_SAC_Setting__mdt.getAll().values();
        Map<String, Object> valuesMap = new Map<String, Object>();
        for(Access_Case_Jira_SAC_Setting__mdt res : customMetadataRec){
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Jira_Endpoint_Details__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data );
            }
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Jira_Custom_Field__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data );
            }
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Jira_Custom_Field_Set_1__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data);
            }
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Jira_Custom_Field_Set_2__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data);
            }
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Jira_Custom_Field_Set_3__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data);
            }  
        }
        //System.debug('valuesMap : '+valuesMap);
        return valuesMap;
    }
    /* Fetching the JIRA Endpoint Details from Custom Metadata Types */
    
    /* Fetching the JIRA Case Status from Custom Metadata Types */
    public static Map<String, Object> jiraCaseStatusDetails(){
        List<Access_Case_Jira_SAC_Status__mdt> customMetadataRec = Access_Case_Jira_SAC_Status__mdt.getAll().values();
        System.debug('customMetadataRec : '+customMetadataRec);
        Map<String, Object> valuesMap = new Map<String, Object>();
        for(Access_Case_Jira_SAC_Status__mdt res : customMetadataRec){
            for(Object obj : (List<Object>)JSON.deserializeUntyped(res.Status__c)){
                //convert values to map
                Map<String, Object> data = (Map<String, Object>)obj;
                valuesMap.putAll(data );
            }
        }
        //System.debug('valuesMap : '+valuesMap);
        return valuesMap;
    }
    /* Fetching the JIRA Endpoint Details from Custom Metadata Types */
    
    /* Case Insert into SAC Project OneTickets */
    public static Map<Id,String> handleInsertAccessCasesBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError ){
        System.debug('Inside CaSE INERT');
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        String jiraProjectKeyValue = '';
        String jiraServiceAffectingField = '';
        String jiraRequestedDateField = '';
        String jiraCustomFields = '';
        String jiraPnameField = ''; 
        String jiraReproductibilityField = '';
        String jiraDetectionPhaseField = '';
        String jiraRelatedCustomersField = '';
        String jiraEmailNotificationField = '';
        String jiraPartnerCustomerField = '';
        String jiraSoftwareVersionField = '';
        String jiraAccountNameField = '';
        String jiraDetailedDescriptionField = '';
        String jiraCustomerTicketRefField = '';
        String jiraPrivacyField = '';
        String jiraContactNameField = '';
        String jiraRelatedTicketField = '';
        String jiraSoftwarePackField = '';
        System.debug('valuesMap : '+valuesMap);
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
                if(key == 'Key'){
                    jiraProjectKeyValue = (String)valuesMap.get(key);
                }
                if(key == 'IsServiceAffecting'){
                    jiraServiceAffectingField = (String)valuesMap.get(key);
                }
                if(key == 'RequestedDate'){
                    jiraRequestedDateField = (String)valuesMap.get(key);
                }
                if(key == 'Pname'){
                    jiraPnameField = (String)valuesMap.get(key);
                }
                if(key == 'Reproductibility'){
                    jiraReproductibilityField = (String)valuesMap.get(key);
                }
                if(key == 'DetectionPhase'){
                    jiraDetectionPhaseField = (String)valuesMap.get(key);
                }
                if(key == 'RelatedCustomers'){
                    jiraRelatedCustomersField = (String)valuesMap.get(key);
                }
                if(key == 'EmailNotification'){
                    jiraEmailNotificationField = (String)valuesMap.get(key);
                }
                if(key == 'PartnerCustomer'){
                    jiraPartnerCustomerField = (String)valuesMap.get(key);
                }
                if(key == 'SoftwareVersion'){
                    jiraSoftwareVersionField = (String)valuesMap.get(key);
                }
                if(key == 'AccountName'){
                    jiraAccountNameField = (String)valuesMap.get(key);
                }
                if(key == 'DetailedDescription'){
                    jiraDetailedDescriptionField = (String)valuesMap.get(key);
                }
                if(key == 'CustomerTicketRef'){
                    jiraCustomerTicketRefField = (String)valuesMap.get(key);
                }
                if(key == 'Privacy'){
                    jiraPrivacyField = (String)valuesMap.get(key);
                }
                if(key == 'ContactName'){
                    jiraContactNameField = (String)valuesMap.get(key);
                }
                if(key == 'RelatedTicket'){
                    jiraRelatedTicketField = (String)valuesMap.get(key);
                }
                if(key == 'SoftwarePack'){
                    jiraSoftwarePackField = (String)valuesMap.get(key);
                }
            }
        }
        System.debug('Inside Insert');
        List<Id> caseIds = new List<Id>();
        Map<Id,Access_Case__c> accCaseMap = new Map<Id,Access_Case__c>();
        Map<Id,Id> SFObjIdAccessCaseIdMap = new Map<Id,Id>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseIds.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseMap.put(CaseId,accCaseRec);
        }
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        //String Password = '1234567890'; //Needs to change
        String Password = jiraTokenValue; //Needs to change
    	//String jiraURL = 'https://onetickets-acc.ekinops.com';
    	String jiraURL = jiraURLValue;
        for(Case caseRec : [SELECT Id,PartnerCustomerRef__c,Pname__r.Name, RequestedDate__c,ReproductibilityPick__c,DetectionPhasePick__c,IsServiceAffectingPick__c,PartnerCustomerRef__r.Name,CustomerTicketRef__c,RelatedTicketRef__c,RelatedCustomers__c,AccountId,Account.Name,EmailNotification__c,SoftwarePackPick__c,RelatedTicketRef__r.Subject,SoftwareVersion__c,ContactId,Contact.Name,CaseNumber,Status,Subject,Description,SAC_Onetickets_Ticket__c,Type,Detailed_Description__c,PrivacyPick__c,Priority From Case WHERE Id IN :caseIds])
        {
            Id accessCaseMapId = accCaseMap.get(caseRec.Id).Id;
            //Subject
            String caseSubject = caseRec.Subject;
            String caseSubJson = JSON.serialize(caseSubject);
            System.debug('caseSubJson : '+caseSubJson);
            //Description
            String caseDescription = caseRec.Description;
            String caseDesJson = JSON.serialize(caseDescription);
            //Detailed Description
            String caseDetailedDescription = caseRec.Detailed_Description__c;
            String caseDetailedDescJson = null;
            if(caseDetailedDescription != null){
            	caseDetailedDescJson = caseDetailedDescription; 
                caseDetailedDescJson = JSON.serialize('{html}'+caseDetailedDescJson+'{html}');
            }
            /*String caseDetailedDescription = caseRec.Detailed_Description__c;
            String caseDetailedDescJson = '';
            if(caseDetailedDescription != null){
            	caseDetailedDescJson = caseDetailedDescription; 
                if(caseDetailedDescJson.contains('<br>')){
                   caseDetailedDescJson = caseDetailedDescJson.replaceAll('<br>',' <br> ');
                }
                if(caseDetailedDescJson.contains('<em>')){
                   caseDetailedDescJson = caseDetailedDescJson.replaceAll('<em>','<i>');
                }
                if(caseDetailedDescJson.contains('</em>')){
                   caseDetailedDescJson = caseDetailedDescJson.replaceAll('</em>','</i>');
                }
                //caseDetailedDescJson = JSON.serialize(caseDetailedDescJson);
                caseDetailedDescJson = '{html}'+caseDetailedDescJson+'{html}';
            }
            //String caseDetailedDescJson = JSON.serialize(caseDetailedDescription);*/
            //Privacy
            String casePrivacy = caseRec.PrivacyPick__c;
            String casePrivacyJson = null;
            if(casePrivacy != null){
                //casePrivacyJson = JSON.serialize(casePrivacy);
                casePrivacyJson = '{"value":"'+casePrivacy+'"}';
            }
            
            //Account/ Customer Name
            String caseAccountName = caseRec.Account.Name;
            String caseAccountNameJson = JSON.serialize(caseAccountName);
            
            //Partner Customer Name
            String casePartnerCustomerName = null;
            System.debug('Case Partner 1 : '+caseRec.PartnerCustomerRef__c);
            System.debug('Case Partner 2 : '+caseRec.PartnerCustomerRef__r.Name);
            if(caseRec.PartnerCustomerRef__c != null){
                System.debug('CS *');
            	casePartnerCustomerName = JSON.serialize(caseRec.PartnerCustomerRef__r.Name);
            }
            System.debug('casePartnerCustomerName : '+casePartnerCustomerName);
            //Contact Name
            String caseContactNameJson = null;
            if(caseRec.ContactId != null){
                String caseContactName = caseRec.Contact.Name;
            	caseContactNameJson = JSON.serialize(caseContactName);
            }
            System.debug('caseContactNameJson : '+caseContactNameJson);
            //Related Customers
            String caseRelatedCustomersJson = '';
            if(caseRec.RelatedCustomers__c != ''){
                String caseRelatedCustomers = caseRec.RelatedCustomers__c;
                caseRelatedCustomersJson = JSON.serialize(caseRelatedCustomers);
            }
            System.debug('caseRelatedCustomersJson : '+caseRelatedCustomersJson);
            //Type
            String caseType = caseRec.Type;
            if(caseType == 'Hardware'){
               caseType = 'Hardware Issue'; 
            }else if(caseType == 'Software'){
                caseType = 'Software Issue';
            }else if(caseType == 'Documentation'){
                caseType = 'Documentation Issue';
            }else if(caseType == 'Configuration request'){
                caseType = 'Configuration Request';
            }else if(caseType == 'Project tracking'){
                caseType = 'Project Tracking';
            }else if(caseType == 'Software delivery'){
                caseType = 'Software Delivery';
            }
            System.debug('caseType : '+caseType);
            String caseTypeJson = JSON.serialize(caseType);
            System.debug('caseTypeJson : '+caseTypeJson);
			//Pname
            String casePName = null;
            String casePNameJson = null;
            if(caseRec.Pname__r.Name != null && caseRec.Pname__r.Name != ''){
            	casePName = caseRec.Pname__r.Name;
            	casePNameJson = JSON.serialize(casePName);
	            System.debug('casecaseProductNameJson : '+casePNameJson);    
            }
            
            
            //Priority
            String casePriority = caseRec.Priority;
            String jiraPriority = '';
            if(casePriority == 'Critical'){
                jiraPriority = 'Very Urgent';
            }else if(casePriority == 'Major'){
                jiraPriority = 'Urgent';
            }else if(casePriority == 'Normal'){
                jiraPriority = 'Routine';
            }else if(casePriority == 'Minor'){
                jiraPriority = 'Not Urgent';
            }else{
                jiraPriority = 'Not Assigned';
            }
            System.debug('jiraPriority : '+jiraPriority);
            //Reproducibiliy
            String jiraReproductibility = caseRec.ReproductibilityPick__c;
            if(jiraReproductibility == null){
                jiraReproductibility = null;
            }else{
                if(jiraReproductibility == 'Have not tried'){
                    jiraReproductibility = '{"value":"Have Not Tried"}';
                }else if(jiraReproductibility == 'Unable to duplicate'){
                    jiraReproductibility = '{"value":"Unable To Duplicate"}';
                }else{
                    jiraReproductibility = '{"value":"'+caseRec.ReproductibilityPick__c+'"}';
                }
            }
            System.debug('jiraReproductibility : '+jiraReproductibility);
            
            //Detection 
            String jiraDetectionPhase = caseRec.DetectionPhasePick__c;
            System.debug('jiraDetectionPhase : '+jiraDetectionPhase);
            //Is Service Affecting
            String jiraServiceAffecting = null;
            if(caseRec.IsServiceAffectingPick__c != '' && caseRec.IsServiceAffectingPick__c != null){
            	jiraServiceAffecting = '{"value":"'+caseRec.IsServiceAffectingPick__c+'"}';
            }
            System.debug('jiraServiceAffecting : '+jiraServiceAffecting);
            //Software Pack
            String caseSoftwarePackPick = '';
            if(caseRec.SoftwarePackPick__c != null){
            	caseSoftwarePackPick = caseRec.SoftwarePackPick__c;  
            }
            System.debug('caseSoftwarePackPick : '+caseSoftwarePackPick);
            //Software Version
            String caseSoftwareVersion = caseRec.SoftwareVersion__c;
            String caseSoftwareVersionJson = '';
            if(caseSoftwareVersion != ''){
            	caseSoftwareVersionJson = JSON.serialize(caseSoftwareVersion);
            }
            System.debug('caseSoftwareVersionJson : '+caseSoftwareVersionJson);
            //CustomerTicketRef
            String caseCustomerTicketRef = caseRec.CustomerTicketRef__c;
            String caseCustomerTicketRefJson = null;
            if(caseCustomerTicketRef != ''){
            	caseCustomerTicketRefJson = JSON.serialize(caseCustomerTicketRef);
            }
            System.debug('caseCustomerTicketRefJson : '+caseCustomerTicketRefJson);
            //Requested Date
            String jiraRequestedDate = null;
            if(caseRec.RequestedDate__c != null){
            	Datetime jiraRequestedDateTemp = caseRec.RequestedDate__c;
            	jiraRequestedDate = '"'+jiraRequestedDateTemp.format('YYYY-MM-dd')+'"';    
            } 
            System.debug('jiraRequestedDate : '+jiraRequestedDate);
            //Related Tickets
            String caseRelatedTicketsJson = null;
            if(caseRec.RelatedTicketRef__c != null){
             	String caseRelatedTickets = caseRec.RelatedTicketRef__r.Subject;
            	caseRelatedTicketsJson = JSON.serialize(caseRelatedTickets);   
            }
            System.debug('caseRelatedTicketsJson : '+caseRelatedTicketsJson);
            //Email Notification
            String caseEmailNotification = caseRec.EmailNotification__c;
            String caseEmailNotificationJson = null;
            if(caseEmailNotification != ''){
            	caseEmailNotificationJson = JSON.serialize(caseEmailNotification);    
            }
            
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            String authorizationHeader = 'Bearer ' + Password;
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type','application/json');
            String endpoint = jiraURL+'/rest/api/2/issue';
            request.setMethod('POST');
            request.setEndpoint(endpoint);
            //System.debug('{"fields": {"issuetype":{"id":"1"},"project":{"key":"'+jiraProjectKeyValue+'"},"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"'+jiraReproductibilityField+'":'+jiraReproductibility+',"'+jiraProductField+'":'+casecaseProductNameJson+',"'+jiraDetectionPhaseField+'":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"'+jiraRelatedCustomersField+'":'+caseRelatedCustomersJson+',"'+jiraEmailNotificationField+'":'+caseEmailNotificationJson+',"'+jiraPartnerCustomerField+'":'+casePartnerCustomerName+',"'+jiraSoftwareVersionField+'":"'+caseSoftwareVersionJson+'","'+jiraAccountNameField+'":'+caseAccountNameJson+',"'+jiraDetailedDescriptionField+'":'+caseDetailedDescJson+',"'+jiraCustomerTicketRefField+'":'+caseCustomerTicketRefJson+',"'+jiraPrivacyField+'":'+casePrivacyJson+',"'+jiraContactNameField+'":'+caseContactNameJson+',"'+jiraRelatedTicketField+'":'+caseRelatedTicketsJson+',"'+jiraSoftwarePackField+'":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
            //request.setBody('{"fields": {"issuetype":{"id":"1"},"project":{"key":"'+jiraProjectKeyValue+'"},"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"customfield_14200":'+jiraReproductibility+',"customfield_16104":'+casecaseProductNameJson+',"customfield_16404":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"customfield_17920":'+caseRelatedCustomersJson+',"customfield_17921":'+caseEmailNotificationJson+',"customfield_17922":'+casePartnerCustomerName+',"customfield_17923":"'+caseSoftwareVersionJson+'","customfield_17924":'+caseAccountNameJson+',"customfield_17925":'+caseDetailedDescJson+',"customfield_17926":'+caseCustomerTicketRefJson+',"customfield_17927":'+casePrivacyJson+',"customfield_17928":'+caseContactNameJson+',"customfield_17929":'+caseRelatedTicketsJson+',"customfield_17930":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
            //request.setBody('{"fields": {"issuetype":{"id":"1"},"project":{"key":"'+jiraProjectKeyValue+'"},"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"'+jiraReproductibilityField+'":'+jiraReproductibility+',"'+jiraProductField+'":'+casecaseProductNameJson+',"'+jiraDetectionPhaseField+'":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"'+jiraRelatedCustomersField+'":'+caseRelatedCustomersJson+',"'+jiraEmailNotificationField+'":'+caseEmailNotificationJson+',"'+jiraPartnerCustomerField+'":'+casePartnerCustomerName+',"'+jiraSoftwareVersionField+'":'+caseSoftwareVersionJson+',"'+jiraAccountNameField+'":'+caseAccountNameJson+',"'+jiraDetailedDescriptionField+'":'+caseDetailedDescJson+',"'+jiraCustomerTicketRefField+'":'+caseCustomerTicketRefJson+',"'+jiraPrivacyField+'":'+casePrivacyJson+',"'+jiraContactNameField+'":'+caseContactNameJson+',"'+jiraRelatedTicketField+'":'+caseRelatedTicketsJson+',"'+jiraSoftwarePackField+'":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
            request.setBody('{"fields": {"issuetype":{"id":"1"},"project":{"key":"'+jiraProjectKeyValue+'"},"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"'+jiraReproductibilityField+'":'+jiraReproductibility+',"'+jiraPnameField+'":'+casePNameJson+',"'+jiraDetectionPhaseField+'":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"'+jiraRelatedCustomersField+'":'+caseRelatedCustomersJson+',"'+jiraEmailNotificationField+'":'+caseEmailNotificationJson+',"'+jiraPartnerCustomerField+'":'+casePartnerCustomerName+',"'+jiraSoftwareVersionField+'":'+caseSoftwareVersionJson+',"'+jiraAccountNameField+'":'+caseAccountNameJson+',"'+jiraDetailedDescriptionField+'":'+caseDetailedDescJson+',"'+jiraCustomerTicketRefField+'":'+caseCustomerTicketRefJson+',"'+jiraPrivacyField+'":'+casePrivacyJson+',"'+jiraContactNameField+'":'+caseContactNameJson+',"'+jiraRelatedTicketField+'":'+caseRelatedTicketsJson+',"'+jiraSoftwarePackField+'":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
            
            try 
            {
            	String jiraIssueId = '';
                String jiraIssueKey = '';
                response = http.send(request);
                System.debug('Response : '+response.getBody()+' : '+response.getStatusCode());
                if(response.getStatusCode() == 201)
                {
                    System.debug('Inside 201');
                	JSONParser parser = JSON.createParser(response.getBody());
                    while (parser.nextToken() != null) 
                    {
                    	if (parser.getCurrentName() == 'key'){
                        	jiraIssueKey = parser.getText();
                        }
                        if (parser.getCurrentName() == 'id'){
                        	jiraIssueId = parser.getText();
                        }
                    }
                    if(jiraIssueKey != ''){
                        String jiraKeyForMap = 'Case,'+jiraIssueKey+','+jiraIssueId+',Insert';
                        sfidAndJira.put(accessCaseMapId,jiraKeyForMap);
                    }
                }else{
                    sfidAndJiraError.put(accessCaseMapId,response.toString());
                }
                
           }
           	catch(System.CalloutException e){
                System.debug('Inside Error 123');
        		System.debug('ERROR:' + e.getLineNumber());
        		System.debug(response.toString());
                
    		}
        }
        return sfidAndJira;
    }
    /* Case Insert into SAC Project OneTickets */
    
    /* Case Status Update into SAC Project */
    public static Map<Id,String> handleUpdateAccessCasesStatusBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('Inside Handel Status Bath');
        Map<String, Object> statusMap = new Map<String, Object>();
        statusMap = AccessCaseHandler.jiraCaseStatusDetails();
        System.debug('Inside Handel Status Bath 1 : '+statusMap);
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        System.debug('Inside Handel Status Bath 2 : '+valuesMap);
        String jiraTokenValue = '';
        String jiraURLValue = '';
        String jiraProjectKeyValue = '';
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
                if(key == 'Key'){
                    jiraProjectKeyValue = (String)valuesMap.get(key);
                }
            }
        }
        System.debug('Inside Handel Status Bath 3');
        Set<Id> caseIds = new Set<Id>();
        Map<Id,Access_Case__c> accCaseMap = new Map<Id,Access_Case__c>();
        Map<Id,String> accCaseMapUpdateAccessCasesStatus = new Map<Id,String>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseIds.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseMap.put(CaseId,accCaseRec);
            
            if(accCaseMapUpdateAccessCasesStatus.size() > 0){
                if(accCaseMapUpdateAccessCasesStatus.containsKey(CaseId)){
                    String existVal = accCaseMapUpdateAccessCasesStatus.get(CaseId);
                    String newVal = existVal+':'+(String)accCaseRec.Id;
                    accCaseMapUpdateAccessCasesStatus.put(CaseId,newVal); 
                } 
            }else{
               String recAccessCaseIdString = (String)accCaseRec.Id;
               accCaseMapUpdateAccessCasesStatus.put(CaseId,recAccessCaseIdString); 
            }
            
        }
        System.debug('caseIds : '+caseIds);
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue; //Needs to change
    	//String jiraURL = 'https://onetickets-acc.ekinops.com';
    	String jiraURL = jiraURLValue;
        System.debug('SELECT Id,CaseNumber,Status,Subject,Description,Jira_Issue_Id__c From Case WHERE Id IN '+caseIds);
        for(Case caseRec : [SELECT Id,CaseNumber,Status,Subject,Description,SAC_Onetickets_Ticket__c From Case WHERE Id IN :caseIds]){
            // Case Status Details 
            String caseStatus = (String) caseRec.get('Status');
            System.debug('Case Status : '+caseStatus);
            String statusValToUpdate = '31';
            if(statusMap.size() > 0){
            	if(caseStatus == 'Closed' && statusMap.containskey('Close')){
                    statusValToUpdate = String.valueof(statusMap.get('Close'));
                }
                if(caseStatus == 'Assigned' && statusMap.containskey('Assign')){
                    statusValToUpdate = String.valueof(statusMap.get('Assign'));
                }
                if(caseStatus == 'Delivered' && statusMap.containskey('Deliver')){
                    statusValToUpdate = String.valueof(statusMap.get('Deliver'));
                }
                if(caseStatus == 'Resolved' && statusMap.containskey('Deliver')){
                    statusValToUpdate = String.valueof(statusMap.get('Deliver'));
                }
                if(caseStatus == 'Workaround Provided' && statusMap.containskey('Provide Workaround')){
                    statusValToUpdate = String.valueof(statusMap.get('Provide Workaround'));
                }
                if(caseStatus == 'Workaround Provided' && statusMap.containskey('Reopen')){
                    statusValToUpdate = String.valueof(statusMap.get('Reopen'));
                }
                if(caseStatus == 'Waiting customer feedback' && statusMap.containskey('Request Feedback')){
                    statusValToUpdate = String.valueof(statusMap.get('Request Feedback'));
                }
            }
            System.debug('statusValToUpdate : '+statusValToUpdate);
            Id caseIdToMap = caseRec.Id; System.debug('caseIdToMap : '+caseIdToMap);
            Id accessCaseMapId = accCaseMap.get(caseRec.Id).Id;
            // Case Details 
            
            // Getting Jira Issue Key from Access Case Custom Object 
            String jiraIssueKey = '';
            String jiraIssueId = '';
            System.debug('SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = \'Case\' AND SF_Type_Object_Id__c ='+caseRec.Id);
            List<Access_Case_Tracker__c> accessCaseList = [SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = 'Case' AND SF_Type_Object_Id__c =:caseRec.Id];
            if(accessCaseList.size() > 0){
                Access_Case_Tracker__c accessTrackerJiraIssueKey = [SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = 'Case' AND SF_Type_Object_Id__c =:caseRec.Id];
                jiraIssueKey = (String) accessTrackerJiraIssueKey.OTK_Issue_Key__c; System.debug('jiraIssueKey : '+jiraIssueKey);
                jiraIssueId = (String) accessTrackerJiraIssueKey.OTK_Object_Id__c; System.debug('jiraIssueId : '+jiraIssueId);
                // Getting Jira Issue Key from Access Case Custom Object
                
                // While Updating the Case, only one update is required to save the last details to Jira. 
                // So we are using the Set structure.And passing Case Id to Map
                
                 
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                //String endpoint = jiraURL+'/rest/api/2/issue/'+jiraIssueKey;
                String endpoint = jiraURL+'/rest/api/2/issue/'+jiraIssueKey+'/transitions?expand=transitions.fields';
                //System.debug('endpoint : '+endpoint);
                request.setMethod('POST');
                request.setBody('{"transition": {"id": \"'+statusValToUpdate+'\"}}');
                request.setEndpoint(endpoint);
                try{
                    response = http.send(request);
                    if(response.getStatusCode() == 204){
                        String tempMapList = accCaseMapUpdateAccessCasesStatus.get(caseIdToMap);
                        String jiraKeyForMap = 'Status,'+jiraIssueKey+','+jiraIssueId+',Update,'+tempMapList;
                        //sfidAndJira.put(caseIdToMap,jiraKeyForMap);
                        sfidAndJira.put(accessCaseMapId,jiraKeyForMap);
                    }else{
                        sfidAndJiraError.put(accessCaseMapId,response.toString());
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
            
        }
        return sfidAndJira;
    }
    /* Case Status Update into SAC Project */
    
    public static Map<Id,String> handleUpdateAccessCasesBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('Inside Update Access ** : '+accCaseList);
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        String jiraProjectKeyValue = '';
        String jiraServiceAffectingField = '';
        String jiraRequestedDateField = '';
        String jiraCustomFields = '';
        String jiraPnameField = '';
        String jiraReproductibilityField = '';
        String jiraDetectionPhaseField = '';
        String jiraRelatedCustomersField = '';
        String jiraEmailNotificationField = '';
        String jiraPartnerCustomerField = '';
        String jiraSoftwareVersionField = '';
        String jiraAccountNameField = '';
        String jiraDetailedDescriptionField = '';
        String jiraCustomerTicketRefField = '';
        String jiraPrivacyField = '';
        String jiraContactNameField = '';
        String jiraRelatedTicketField = '';
        String jiraSoftwarePackField = '';
        
        System.debug('valuesMap : '+valuesMap);
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
                if(key == 'Key'){
                    jiraProjectKeyValue = (String)valuesMap.get(key);
                }
                if(key == 'IsServiceAffecting'){
                    jiraServiceAffectingField = (String)valuesMap.get(key);
                }
                if(key == 'RequestedDate'){
                    jiraRequestedDateField = (String)valuesMap.get(key);
                }
                if(key == 'Pname'){
                    jiraPnameField = (String)valuesMap.get(key);
                }
                if(key == 'Reproductibility'){
                    jiraReproductibilityField = (String)valuesMap.get(key);
                }
                if(key == 'DetectionPhase'){
                    jiraDetectionPhaseField = (String)valuesMap.get(key);
                }
                if(key == 'RelatedCustomers'){
                    jiraRelatedCustomersField = (String)valuesMap.get(key);
                }
                if(key == 'EmailNotification'){
                    jiraEmailNotificationField = (String)valuesMap.get(key);
                }
                if(key == 'PartnerCustomer'){
                    jiraPartnerCustomerField = (String)valuesMap.get(key);
                }
                if(key == 'SoftwareVersion'){
                    jiraSoftwareVersionField = (String)valuesMap.get(key);
                }
                if(key == 'AccountName'){
                    jiraAccountNameField = (String)valuesMap.get(key);
                }
                if(key == 'DetailedDescription'){
                    jiraDetailedDescriptionField = (String)valuesMap.get(key);
                }
                if(key == 'CustomerTicketRef'){
                    jiraCustomerTicketRefField = (String)valuesMap.get(key);
                }
                if(key == 'Privacy'){
                    jiraPrivacyField = (String)valuesMap.get(key);
                }
                if(key == 'ContactName'){
                    jiraContactNameField = (String)valuesMap.get(key);
                }
                if(key == 'RelatedTicket'){
                    jiraRelatedTicketField = (String)valuesMap.get(key);
                }
                if(key == 'SoftwarePack'){
                    jiraSoftwarePackField = (String)valuesMap.get(key);
                }
            }
        }
        Set<Id> caseIds = new Set<Id>();
        Map<Id,Access_Case__c> accCaseMap = new Map<Id,Access_Case__c>();
        Map<Id,String> accCaseMapUpdateAccessCases = new Map<Id,String>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseIds.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseMap.put(CaseId,accCaseRec);
            if(accCaseMapUpdateAccessCases.size() > 0){
                if(accCaseMapUpdateAccessCases.containsKey(CaseId)){
                    String existVal = accCaseMapUpdateAccessCases.get(CaseId);
                    String newVal = existVal+':'+(String)accCaseRec.Id;
                    accCaseMapUpdateAccessCases.put(CaseId,newVal); 
                } 
            }else{
               String recAccessCaseIdString = (String)accCaseRec.Id;
               accCaseMapUpdateAccessCases.put(CaseId,recAccessCaseIdString); 
            }
        }
        System.debug('caseIds : '+caseIds);
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue;
    	//String jiraURL = 'https://onetickets-acc.ekinops.com';
        String jiraURL = jiraURLValue;
        //System.debug('SELECT Id,CaseNumber,Status,Subject,Description,Jira_Issue_Id__c From Case WHERE Id IN '+caseIds);
        //Id,PartnerCustomerRef__c,RequestedDate__c,ReproductibilityPick__c,DetectionPhasePick__c,IsServiceAffectingPick__c,PartnerCustomerRef__r.Name,CustomerTicketRef__c,RelatedTicketRef__c,RelatedCustomers__c,AccountId,Account.Name,EmailNotification__c,ProductId,Product.Name,SoftwarePackPick__c,RelatedTicketRef__r.Subject,SoftwareVersion__c,ContactId,Contact.Name,CaseNumber,Status,Subject,Description,SAC_Onetickets_Ticket__c,Type,Detailed_Description__c,PrivacyPick__c,Priority
        //Id,CaseNumber,Status,Subject,Description,SAC_Onetickets_Ticket__c
        for(Case caseRec : [SELECT Id,Pname__r.Name,PartnerCustomerRef__c,RequestedDate__c,ReproductibilityPick__c,DetectionPhasePick__c,IsServiceAffectingPick__c,PartnerCustomerRef__r.Name,CustomerTicketRef__c,RelatedTicketRef__c,RelatedCustomers__c,AccountId,Account.Name,EmailNotification__c,SoftwarePackPick__c,RelatedTicketRef__r.Subject,SoftwareVersion__c,ContactId,Contact.Name,CaseNumber,Status,Subject,Description,SAC_Onetickets_Ticket__c,Type,Detailed_Description__c,PrivacyPick__c,Priority From Case WHERE Id IN :caseIds]){
            // Case Details 
            Id caseIdToMap = caseRec.Id; 
            System.debug('caseIdToMap : '+caseIdToMap);
            Id accessCaseMapId = accCaseMap.get(caseRec.Id).Id;
            // Case Details 
            
            // Case Record Fields
            //Subject
            String caseSubject = caseRec.Subject;
            String caseSubJson = JSON.serialize(caseSubject);
            System.debug('caseSubJson : '+caseSubJson);
            //Description
            String caseDescription = caseRec.Description;
            String caseDesJson = JSON.serialize(caseDescription);
            //Detailed Description
            String caseDetailedDescription = caseRec.Detailed_Description__c;
            String caseDetailedDescJson = null;
            if(caseDetailedDescription != null){
            	caseDetailedDescJson = caseDetailedDescription; 
                caseDetailedDescJson = JSON.serialize('{html}'+caseDetailedDescJson+'{html}');
            }
            //Privacy
            String casePrivacy = caseRec.PrivacyPick__c;
            String casePrivacyJson = null;
            if(casePrivacy != null){
                casePrivacyJson = '{"value":"'+casePrivacy+'"}';
            }
            //Account/ Customer Name
            String caseAccountName = caseRec.Account.Name;
            String caseAccountNameJson = JSON.serialize(caseAccountName);
            
            //Partner Customer Name
            String casePartnerCustomerName = null;
            System.debug('Case Partner 1 : '+caseRec.PartnerCustomerRef__c);
            System.debug('Case Partner 2 : '+caseRec.PartnerCustomerRef__r.Name);
            if(caseRec.PartnerCustomerRef__c != null){
                System.debug('CS *');
            	casePartnerCustomerName = JSON.serialize(caseRec.PartnerCustomerRef__r.Name);
            }
            System.debug('casePartnerCustomerName : '+casePartnerCustomerName);
            //Contact Name
            String caseContactNameJson = null;
            if(caseRec.ContactId != null){
                String caseContactName = caseRec.Contact.Name;
            	caseContactNameJson = JSON.serialize(caseContactName);
            }
            System.debug('caseContactNameJson : '+caseContactNameJson);
            //Related Customers
            String caseRelatedCustomersJson = '';
            if(caseRec.RelatedCustomers__c != ''){
                String caseRelatedCustomers = caseRec.RelatedCustomers__c;
                caseRelatedCustomersJson = JSON.serialize(caseRelatedCustomers);
            }
            System.debug('caseRelatedCustomersJson : '+caseRelatedCustomersJson);
            //Type
            String caseType = caseRec.Type;
            if(caseType == 'Hardware'){
               caseType = 'Hardware Issue'; 
            }else if(caseType == 'Software'){
                caseType = 'Software Issue';
            }else if(caseType == 'Documentation'){
                caseType = 'Documentation Issue';
            }else if(caseType == 'Configuration request'){
                caseType = 'Configuration Request';
            }else if(caseType == 'Project tracking'){
                caseType = 'Project Tracking';
            }else if(caseType == 'Software delivery'){
                caseType = 'Software Delivery';
            }
            System.debug('caseType : '+caseType);
            String caseTypeJson = JSON.serialize(caseType);
            System.debug('caseTypeJson : '+caseTypeJson);
			//Pname 
            String casePName = null;
            String casePNameJson = null;
            if(caseRec.Pname__r.Name != null && caseRec.Pname__r.Name != ''){
            	casePName = caseRec.Pname__r.Name;
            	casePNameJson = JSON.serialize(casePName);
	            System.debug('casecaseProductNameJson : '+casePNameJson);    
            }
            
            //Priority
            String casePriority = caseRec.Priority;
            String jiraPriority = '';
            if(casePriority == 'Critical'){
                jiraPriority = 'Very Urgent';
            }else if(casePriority == 'Major'){
                jiraPriority = 'Urgent';
            }else if(casePriority == 'Normal'){
                jiraPriority = 'Routine';
            }else if(casePriority == 'Minor'){
                jiraPriority = 'Not Urgent';
            }else{
                jiraPriority = 'Not Assigned';
            }
            System.debug('jiraPriority : '+jiraPriority);
            //Reproducibiliy
            String jiraReproductibility = caseRec.ReproductibilityPick__c;
            if(jiraReproductibility == null){
                jiraReproductibility = null;
            }else{
                if(jiraReproductibility == 'Have not tried'){
                    jiraReproductibility = '{"value":"Have Not Tried"}';
                }else if(jiraReproductibility == 'Unable to duplicate'){
                    jiraReproductibility = '{"value":"Unable To Duplicate"}';
                }else{
                    jiraReproductibility = '{"value":"'+caseRec.ReproductibilityPick__c+'"}';
                }
            }
            System.debug('jiraReproductibility : '+jiraReproductibility);
            
            //Detection 
            String jiraDetectionPhase = caseRec.DetectionPhasePick__c;
            System.debug('jiraDetectionPhase : '+jiraDetectionPhase);
            //Is Service Affecting
            String jiraServiceAffecting = null;
            if(caseRec.IsServiceAffectingPick__c != '' && caseRec.IsServiceAffectingPick__c != null){
            	jiraServiceAffecting = '{"value":"'+caseRec.IsServiceAffectingPick__c+'"}';
            }
            System.debug('jiraServiceAffecting : '+jiraServiceAffecting);
            //Software Pack
            String caseSoftwarePackPick = '';
            if(caseRec.SoftwarePackPick__c != null){
            	caseSoftwarePackPick = caseRec.SoftwarePackPick__c;  
            }
            System.debug('caseSoftwarePackPick : '+caseSoftwarePackPick);
            //Software Version
            String caseSoftwareVersion = caseRec.SoftwareVersion__c;
            String caseSoftwareVersionJson = '';
            if(caseSoftwareVersion != ''){
            	caseSoftwareVersionJson = JSON.serialize(caseSoftwareVersion);
            }
            System.debug('caseSoftwareVersionJson : '+caseSoftwareVersionJson);
            //CustomerTicketRef
            String caseCustomerTicketRef = caseRec.CustomerTicketRef__c;
            String caseCustomerTicketRefJson = null;
            if(caseCustomerTicketRef != ''){
            	caseCustomerTicketRefJson = JSON.serialize(caseCustomerTicketRef);
            }
            System.debug('caseCustomerTicketRefJson : '+caseCustomerTicketRefJson);
            //Requested Date
            String jiraRequestedDate = null;
            if(caseRec.RequestedDate__c != null){
            	Datetime jiraRequestedDateTemp = caseRec.RequestedDate__c;
            	jiraRequestedDate = '"'+jiraRequestedDateTemp.format('YYYY-MM-dd')+'"';    
            } 
            System.debug('jiraRequestedDate : '+jiraRequestedDate);
            //Related Tickets
            String caseRelatedTicketsJson = null;
            if(caseRec.RelatedTicketRef__c != null){
             	String caseRelatedTickets = caseRec.RelatedTicketRef__r.Subject;
            	caseRelatedTicketsJson = JSON.serialize(caseRelatedTickets);   
            }
            System.debug('caseRelatedTicketsJson : '+caseRelatedTicketsJson);
            //Email Notification
            String caseEmailNotification = caseRec.EmailNotification__c;
            String caseEmailNotificationJson = null;
            if(caseEmailNotification != ''){
            	caseEmailNotificationJson = JSON.serialize(caseEmailNotification);    
            }
            // Case Record Fields 
            
            // Getting Jira Issue Key from Access Case Custom Object 
            String jiraIssueKey = '';
            String jiraIssueId = '';
            System.debug('SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = \'Case\' AND SF_Type_Object_Id__c ='+caseRec.Id);
            List<Access_Case_Tracker__c> accessCaseList = [SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = 'Case' AND SF_Type_Object_Id__c =:caseRec.Id];
            if(accessCaseList.size() > 0){
            	Access_Case_Tracker__c accessTrackerJiraIssueKey = [SELECT OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object__c = 'Case' AND SF_Type_Object_Id__c =:caseRec.Id LIMIT 1];
                jiraIssueKey = (String) accessTrackerJiraIssueKey.OTK_Issue_Key__c; System.debug('jiraIssueKey : '+jiraIssueKey);
                jiraIssueId = (String) accessTrackerJiraIssueKey.OTK_Object_Id__c; System.debug('jiraIssueId : '+jiraIssueId);
                // Getting Jira Issue Key from Access Case Custom Object
                
                // While Updating the Case, only one update is required to save the last details to Jira. 
                // So we are using the Set structure.And passing Case Id to Map
                
                 
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                String endpoint = jiraURL+'/rest/api/2/issue/'+jiraIssueKey;
                request.setMethod('PUT');
                //System.debug('{"fields": {"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"customfield_14200":'+jiraReproductibility+',"customfield_16104":'+casecaseProductNameJson+',"customfield_16404":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"customfield_17920":'+caseRelatedCustomersJson+',"customfield_17921":'+caseEmailNotificationJson+',"customfield_17922":'+casePartnerCustomerName+',"customfield_17923":"'+caseSoftwareVersion+'","customfield_17924":'+caseAccountNameJson+',"customfield_17925":"'+caseDetailedDescJson+'","customfield_17926":'+caseCustomerTicketRefJson+',"customfield_17927":'+casePrivacyJson+',"customfield_17928":'+caseContactNameJson+',"customfield_17929":'+caseRelatedTicketsJson+',"customfield_17930":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
                //System.debug('{"fields": {"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"customfield_14200":'+jiraReproductibility+',"customfield_16104":'+casecaseProductNameJson+',"customfield_16404":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"customfield_17920":'+caseRelatedCustomersJson+',"customfield_17921":'+caseEmailNotificationJson+',"customfield_17922":'+casePartnerCustomerName+',"customfield_17923":"'+caseSoftwareVersion+'","customfield_17924":'+caseAccountNameJson+',"customfield_17925":'+caseDetailedDescJson+',"customfield_17926":'+caseCustomerTicketRefJson+',"customfield_17927":'+casePrivacyJson+',"customfield_17928":'+caseContactNameJson+',"customfield_17929":'+caseRelatedTicketsJson+',"customfield_17930":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
                //request.setBody('{"fields": {"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"customfield_14200":'+jiraReproductibility+',"customfield_16104":'+casecaseProductNameJson+',"customfield_16404":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"customfield_17920":'+caseRelatedCustomersJson+',"customfield_17921":'+caseEmailNotificationJson+',"customfield_17922":'+casePartnerCustomerName+',"customfield_17923":"'+caseSoftwareVersion+'","customfield_17924":'+caseAccountNameJson+',"customfield_17925":'+caseDetailedDescJson+',"customfield_17926":'+caseCustomerTicketRefJson+',"customfield_17927":'+casePrivacyJson+',"customfield_17928":'+caseContactNameJson+',"customfield_17929":'+caseRelatedTicketsJson+',"customfield_17930":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
                request.setBody('{"fields": {"description":'+caseDesJson+',"priority":{"name":"'+jiraPriority+'"},"'+jiraServiceAffectingField+'":'+jiraServiceAffecting+',"'+jiraRequestedDateField+'":'+jiraRequestedDate+',"'+jiraReproductibilityField+'":'+jiraReproductibility+',"'+jiraPnameField+'":'+casePNameJson+',"'+jiraDetectionPhaseField+'":{"value":"'+jiraDetectionPhase+'"},"summary": '+caseSubJson+',"'+jiraRelatedCustomersField+'":'+caseRelatedCustomersJson+',"'+jiraEmailNotificationField+'":'+caseEmailNotificationJson+',"'+jiraPartnerCustomerField+'":'+casePartnerCustomerName+',"'+jiraSoftwareVersionField+'":'+caseSoftwareVersionJson+',"'+jiraAccountNameField+'":'+caseAccountNameJson+',"'+jiraDetailedDescriptionField+'":'+caseDetailedDescJson+',"'+jiraCustomerTicketRefField+'":'+caseCustomerTicketRefJson+',"'+jiraPrivacyField+'":'+casePrivacyJson+',"'+jiraContactNameField+'":'+caseContactNameJson+',"'+jiraRelatedTicketField+'":'+caseRelatedTicketsJson+',"'+jiraSoftwarePackField+'":"'+caseSoftwarePackPick+'","components": [{"name": '+caseTypeJson+'}]}}');
                
                request.setEndpoint(endpoint);
                try{
                    System.debug('Inside Try');
                    response = http.send(request);
                    System.debug(response.getBody()+' : '+response.getStatusCode());
                    if(response.getStatusCode() == 204){
                        System.debug('caseIdToMap : '+caseIdToMap);
                        String tempMapList = accCaseMapUpdateAccessCases.get(caseIdToMap);
                        
                        System.debug('INside 204');
                        String jiraKeyForMap = 'Case,'+jiraIssueKey+','+jiraIssueId+',Update,'+tempMapList;
                        //sfidAndJira.put(caseIdToMap,jiraKeyForMap);
                        sfidAndJira.put(accessCaseMapId,jiraKeyForMap);
                    }else{
                        sfidAndJiraError.put(accessCaseMapId,response.toString());
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }    
            }
            
        }
        return sfidAndJira;
    }
    
    /*public static void caseUpdateRecordType(List<Id> caseList){
        List<Case> updateCaseObjList = new List<Case>();
        for(Case caseRec : [SELECT Id, CaseNumber,RecordTypeId FROM Case WHERE Id IN :caseList]){
            Case caseRecObj = new Case();
            caseRecObj.Id = caseRec.Id;
            caseRecObj.RecordTypeId = '0122w000001S1VZAA0'; 
            updateCaseObjList.add(caseRecObj);
        }
        if(updateCaseObjList.size() > 0){
        	update updateCaseObjList;
        }
    }*/
    
	public static void caseInsertHandler(List<Id> caseList){
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        for(Case caseRec : [SELECT Id, CaseNumber FROM Case WHERE Id IN :caseList]){
            Access_Case__c accessCaseRec = new Access_Case__c();
            String accessCaseNumber = (String) caseRec.CaseNumber;
            String accessCaseId = (String) caseRec.Id;
            String accessTypeObjectId = (String) caseRec.Id;
            accessCaseRec.Action__c = 'Insert';
            accessCaseRec.Case_Id__c = accessCaseId;
            accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
            accessCaseRec.SF_Type_Object__c = 'Case';
            accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
            accessCaseObjList.add(accessCaseRec);
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    
    /* Case Update Status Actions */
    public static void caseUpdateStatusHandler(List<Id> caseList){
        System.debug('Inside 2: '+caseList);
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        for(Case caseRec : [SELECT Id, CaseNumber FROM Case WHERE Id IN :caseList]){
            Access_Case__c accessCaseRec = new Access_Case__c();
            String accessCaseNumber = (String) caseRec.CaseNumber;
            String accessCaseId = (String) caseRec.Id;
            String accessTypeObjectId = (String) caseRec.Id;
            accessCaseRec.Action__c = 'Update';
            accessCaseRec.Case_Id__c = accessCaseId;
            accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
            accessCaseRec.SF_Type_Object__c = 'Status';
            accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
            accessCaseObjList.add(accessCaseRec);
        }
        System.debug('Inside 3 : '+accessCaseObjList);
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    /* Case Update Status Actions */
    
    /* Case Update for Description and Subject */
    public static void caseUpdateHandler(List<Id> caseList){
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        for(Case caseRec : [SELECT Id, CaseNumber FROM Case WHERE Id IN :caseList]){
            Access_Case__c accessCaseRec = new Access_Case__c();
            String accessCaseNumber = (String) caseRec.CaseNumber;
            String accessCaseId = (String) caseRec.Id;
            String accessTypeObjectId = (String) caseRec.Id;
            accessCaseRec.Action__c = 'Update';
            accessCaseRec.Case_Id__c = accessCaseId;
            accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
            accessCaseRec.SF_Type_Object__c = 'Case';
            accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
            accessCaseObjList.add(accessCaseRec);
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    /* Case Update for Description and Subject */
    
    
    
    
    
}