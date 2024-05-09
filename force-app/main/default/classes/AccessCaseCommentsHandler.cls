public class AccessCaseCommentsHandler {
    public static Map<Id,String> handleUpdateAccessCommentsBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('handleUpdateAccessCommentsBatch');
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
            }
        }
        
        List<Id> caseCommentIdList = new List<Id>();
        Map<Id,Access_Case__c> accCaseCommentMap = new Map<Id,Access_Case__c>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseCommentIdList.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseCommentId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseCommentMap.put(CaseCommentId,accCaseRec);
        }
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue;
        //String jiraURL = 'https://onetickets-acc.ekinops.com';
        String jiraURL = jiraURLValue;
        for(FeedItem cseComment : [SELECT Id, ParentId, Type, CreatedById, CreatedBy.Name, CreatedDate, IsDeleted, Body, Title, HasContent, Status FROM FeedItem WHERE Id IN :caseCommentIdList]){
            Id accessCaseCommentMapId = accCaseCommentMap.get(cseComment.Id).Id; // This Id is used as a Key to the returning Map.
            String JiraCaseCommentId = (String) cseComment.Id;
            String caseId = (String) cseComment.ParentId; //This is used to get Case Jira Issue from Access Case Tracker Object
            String caseCommentCreatedByName = cseComment.CreatedBy.Name;
            String caseCommentCreatedDate = cseComment.CreatedDate.format('dd-MM-yyyy');
            
            String caseCommentBody = null;
            if(cseComment.Body != null && cseComment.Body != ''){
                System.debug('Inside Body ');
                caseCommentBody = cseComment.Body; 
                caseCommentBody = JSON.serialize('{html}<div style="border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;">Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}');
            }
            System.debug('caseCommentBody : '+caseCommentBody);
            List<Access_Case_Tracker__c> accessCaseList = [SELECT Id, OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:JiraCaseCommentId AND SF_Type_Object__c='Comment'];
            if(accessCaseList.size() > 0){
                Access_Case_Tracker__c accTrackerRec = [SELECT Id, OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:JiraCaseCommentId AND SF_Type_Object__c='Comment' LIMIT 1];
                String caseJiraIssueKey = accTrackerRec.OTK_Issue_Key__c;
                String caseJiraIssueId = accTrackerRec.OTK_Object_Id__c;
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                String endpoint = jiraURL+'/rest/api/2/issue/'+caseJiraIssueKey+'/comment/'+caseJiraIssueId;
                System.debug('endpoint : '+endpoint);
                request.setMethod('PUT');
                //request.setBody('{"body": \"{html}<div style=\'border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;\'>Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}\"}');
                request.setBody('{"body": '+caseCommentBody+'}');
                request.setEndpoint(endpoint);
                try{
                    String jiraCaseCommentIdUpdate = '';
                    response = http.send(request);
                    System.debug('response : '+response);
                    if(response.getStatusCode() == 200){
                        JSONParser parser = JSON.createParser(response.getBody());
                        while (parser.nextToken() != null){
                            if (parser.getCurrentName() == 'id'){
                                jiraCaseCommentIdUpdate = parser.getText();
                            }
                        }
                    }else{
                        sfidAndJiraError.put(accessCaseCommentMapId,response.toString());
                    }
                    if(jiraCaseCommentIdUpdate != ''){
                        String jiraKeyForMap = 'Comment,'+caseJiraIssueKey+','+jiraCaseCommentIdUpdate+',Update';
                        sfidAndJira.put(accessCaseCommentMapId,jiraKeyForMap);
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
            
            
        }
        return sfidAndJira;
    }
    
    public static Map<Id,String> handleUpdateAccessCommentsRepBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('handleUpdateAccessCommentsRepBatch');
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
            }
        }
        
        List<Id> caseCommentIdList = new List<Id>();
        Map<Id,Access_Case__c> accCaseCommentMap = new Map<Id,Access_Case__c>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseCommentIdList.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseCommentId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseCommentMap.put(CaseCommentId,accCaseRec);
        }
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue;
        //String jiraURL = 'https://onetickets-acc.ekinops.com';
        String jiraURL = jiraURLValue;
        for(FeedComment cseComment : [SELECT Id, ParentId, FeedItemId, CreatedBy.Name, CreatedDate, CommentBody FROM FeedComment WHERE Id IN :caseCommentIdList]){
            Id accessCaseCommentMapId = accCaseCommentMap.get(cseComment.Id).Id; // This Id is used as a Key to the returning Map.
            //String caseCommentBody = cseComment.CommentBody;
            String JiraCaseCommentId = (String) cseComment.Id;
            String caseId = (String) cseComment.ParentId; //This is used to get Case Jira Issue from Access Case Tracker Object
            String caseCommentCreatedByName = cseComment.CreatedBy.Name;
            String caseCommentCreatedDate = cseComment.CreatedDate.format('dd-MM-yyyy');
            
            String caseCommentBody = cseComment.CommentBody;
            if(cseComment.CommentBody != null && cseComment.CommentBody != ''){
                caseCommentBody = cseComment.CommentBody; 
                caseCommentBody = JSON.serialize('{html}<div style="border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;">Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}');
            }
            List<Access_Case_Tracker__c> accessCaseList = [SELECT Id, OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:JiraCaseCommentId AND SF_Type_Object__c='CommentRep'];
            if(accessCaseList.size() > 0){
                Access_Case_Tracker__c accTrackerRec = [SELECT Id, OTK_Issue_Key__c,OTK_Object_Id__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:JiraCaseCommentId AND SF_Type_Object__c='CommentRep'];
                String caseJiraIssueKey = accTrackerRec.OTK_Issue_Key__c;
                String caseJiraIssueId = accTrackerRec.OTK_Object_Id__c;
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                String endpoint = jiraURL+'/rest/api/2/issue/'+caseJiraIssueKey+'/comment/'+caseJiraIssueId;
                System.debug('endpoint : '+endpoint);
                request.setMethod('PUT');
                //request.setBody('{"body": \"{html}<div style=\'border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;\'>Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}\"}');
                request.setBody('{"body": '+caseCommentBody+'}');
                request.setEndpoint(endpoint);
                try{
                    String jiraCaseCommentIdUpdate = '';
                    response = http.send(request);
                    System.debug('response : '+response);
                    if(response.getStatusCode() == 200){
                        JSONParser parser = JSON.createParser(response.getBody());
                        while (parser.nextToken() != null){
                            if (parser.getCurrentName() == 'id'){
                                jiraCaseCommentIdUpdate = parser.getText();
                            }
                        }
                    }else{
                        sfidAndJiraError.put(accessCaseCommentMapId,response.toString());
                    }
                    if(jiraCaseCommentIdUpdate != ''){
                        String jiraKeyForMap = 'CommentRep,'+caseJiraIssueKey+','+jiraCaseCommentIdUpdate+',Update';
                        sfidAndJira.put(accessCaseCommentMapId,jiraKeyForMap);
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
            
            
        }
        return sfidAndJira;
    }
    
    public static Map<Id,String> handleInsertAccessCommentsRepBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('handleInsertAccessCommentsRepBatch');
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
            }
        }
        
        
        List<Id> caseCommentIdList = new List<Id>();
        Map<Id,Access_Case__c> accCaseCommentMap = new Map<Id,Access_Case__c>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseCommentIdList.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseCommentId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseCommentMap.put(CaseCommentId,accCaseRec);
        }
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue;
        //String jiraURL = 'https://onetickets-acc.ekinops.com';
        String jiraURL = jiraURLValue;
        for(FeedComment cseComment : [SELECT Id, ParentId, FeedItemId, CreatedBy.Name, CreatedDate, CommentBody FROM FeedComment WHERE Id IN :caseCommentIdList]){
            Id accessCaseCommentMapId = accCaseCommentMap.get(cseComment.Id).Id; // This Id is used as a Key to the returning Map.
            String caseId = (String) cseComment.ParentId; //This is used to get Case Jira Issue from Access Case Tracker Object
            String caseCommentCreatedByName = cseComment.CreatedBy.Name;
            String caseCommentCreatedDate = cseComment.CreatedDate.format('dd-MM-yyyy');
            String caseCommentBody = cseComment.CommentBody;
            if(cseComment.CommentBody != null && cseComment.CommentBody != ''){
                caseCommentBody = cseComment.CommentBody; 
                caseCommentBody = JSON.serialize('{html}<div style="border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;">Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}');
            }
            List<Access_Case_Tracker__c> accessCaseList = [SELECT Id, OTK_Issue_Key__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:caseId AND SF_Type_Object__c='Case'];
            if(accessCaseList.size() > 0){
                Access_Case_Tracker__c accTrackerRec = [SELECT Id, OTK_Issue_Key__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:caseId AND SF_Type_Object__c='Case'];
                String caseJiraIssueKey = accTrackerRec.OTK_Issue_Key__c;
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                String endpoint = jiraURL+'/rest/api/2/issue/'+caseJiraIssueKey+'/comment';
                request.setMethod('POST');
                //request.setBody('{"body": \"{html}<div style=\'border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;\'>Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}\"}');
                request.setBody('{"body": '+caseCommentBody+'}');
                request.setEndpoint(endpoint);
                try{
                    String jiraCaseCommentId = '';
                    response = http.send(request);
                    if(response.getStatusCode() == 201){
                        JSONParser parser = JSON.createParser(response.getBody());
                        while (parser.nextToken() != null){
                            if (parser.getCurrentName() == 'id'){
                                jiraCaseCommentId = parser.getText();
                            }
                        }
                    }else{
                        sfidAndJiraError.put(accessCaseCommentMapId,response.toString());
                    }
                    if(jiraCaseCommentId != ''){
                        String jiraKeyForMap = 'CommentRep,'+caseJiraIssueKey+','+jiraCaseCommentId+',Insert';
                        sfidAndJira.put(accessCaseCommentMapId,jiraKeyForMap);
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
            }
            
            
            
        }
        return sfidAndJira;
    }
    
    
    public static Map<Id,String> handleInsertAccessCommentsBatch(List<Access_Case__c> accCaseList, Map<Id,String> sfidAndJira,Map<Id,String> sfidAndJiraError){
        System.debug('handleInsertAccessCommentsBatch');
        Map<String, Object> valuesMap = new Map<String, Object>();
        valuesMap = AccessCaseHandler.jiraEndpointDetails();
        String jiraTokenValue = '';
        String jiraURLValue = '';
        if(valuesMap.size() > 0){
            for(String key:valuesMap.keyset()){
                if(key == 'URL'){
                    jiraURLValue = (String)valuesMap.get(key);
                }
                if(key == 'Token'){
                    jiraTokenValue = (String)valuesMap.get(key);
                }
            }
        }
        
        List<Id> caseCommentIdList = new List<Id>();
        Map<Id,Access_Case__c> accCaseCommentMap = new Map<Id,Access_Case__c>();
        for(Access_Case__c accCaseRec:accCaseList){
            caseCommentIdList.add(accCaseRec.SF_Type_Object_Id__c);
            Id CaseCommentId = (Id) accCaseRec.SF_Type_Object_Id__c;
            accCaseCommentMap.put(CaseCommentId,accCaseRec);
        }
        //String Password = 'NDA3Njk1MTc1NDgzOgIujUhqOcxxk+20TXcXLMAFY7hX'; //Needs to change
        String Password = jiraTokenValue;
        //String jiraURL = 'https://onetickets-acc.ekinops.com';
        String jiraURL = jiraURLValue;
        for(FeedItem cseComment : [SELECT Id, ParentId, Type, CreatedById, CreatedBy.Name, CreatedDate, IsDeleted, Body, Title, HasContent, Status FROM FeedItem WHERE Id IN :caseCommentIdList]){
            Id accessCaseCommentMapId = accCaseCommentMap.get(cseComment.Id).Id; // This Id is used as a Key to the returning Map.
            //String caseCommentBody = cseComment.Body;
            String caseId = (String) cseComment.ParentId; //This is used to get Case Jira Issue from Access Case Tracker Object
            String caseCommentCreatedByName = cseComment.CreatedBy.Name;
            String caseCommentCreatedDate = cseComment.CreatedDate.format('dd-MM-yyyy');
            
            String caseCommentBody = null;
            if(cseComment.Body != null && cseComment.Body != ''){
                System.debug('Inside Body ');
                caseCommentBody = cseComment.Body; 
                caseCommentBody = JSON.serialize('{html}<div style="border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;">Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}');
            }
            System.debug('caseCommentBody : '+caseCommentBody);
            List<Access_Case_Tracker__c> accessCaseList = [SELECT Id, OTK_Issue_Key__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:caseId AND SF_Type_Object__c='Case'];
            if(accessCaseList.size() > 0){
                Access_Case_Tracker__c accTrackerRec = [SELECT Id, OTK_Issue_Key__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:caseId AND SF_Type_Object__c='Case' LIMIT 1];
                String caseJiraIssueKey = accTrackerRec.OTK_Issue_Key__c;
                System.debug('SELECT Id, OTK_Issue_Key__c FROM Access_Case_Tracker__c WHERE SF_Type_Object_Id__c=:'+caseId+' AND SF_Type_Object__c=\'Case\'');
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                String authorizationHeader = 'Bearer ' + Password;
                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Content-Type','application/json');
                String endpoint = jiraURL+'/rest/api/2/issue/'+caseJiraIssueKey+'/comment';
                request.setMethod('POST');
                //request.setBody('{"body": \"{html}<div style=\'border: 1px solid #ccc; background: #ccff99; font-size: 13px; line-height: 1.33333333333333; font-family: monospace;padding:5px;margin:5px;\'>Original comment was added by <b>'+caseCommentCreatedByName+'</b> to Salesforce Access Case On <b>'+caseCommentCreatedDate+'</b></div>{html}{html}'+caseCommentBody+'{html}\"}');
                request.setBody('{"body": '+caseCommentBody+'}');
                request.setEndpoint(endpoint);
                try{
                    String jiraCaseCommentId = '';
                    response = http.send(request);
                    if(response.getStatusCode() == 201){
                        JSONParser parser = JSON.createParser(response.getBody());
                        while (parser.nextToken() != null){
                            if (parser.getCurrentName() == 'id'){
                                jiraCaseCommentId = parser.getText();
                            }
                        }
                    }else{
                        sfidAndJiraError.put(accessCaseCommentMapId,response.toString());
                    }
                    if(jiraCaseCommentId != ''){
                        String jiraKeyForMap = 'Comment,'+caseJiraIssueKey+','+jiraCaseCommentId+',Insert';
                        sfidAndJira.put(accessCaseCommentMapId,jiraKeyForMap);
                    }
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                
            }
            
            
        }
        return sfidAndJira;
    }
    
    /* Update - Case Posts */
    public static void afterUpdateFeedsHandler(Map<Id,FeedItem> comments){
        System.debug('comments'+comments);
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,CaseFeed> caseFeedMap = new Map<Id,CaseFeed>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        for(FeedItem feedItemRec : [SELECT Id,ParentId,Body,Title,CreatedById,CreatedDate FROM FeedItem WHERE Id IN :comments.keyset()]){
            caseIdSet.add(feedItemRec.ParentId);
        }
        System.debug('caseIdSet : '+caseIdSet);
        if(caseIdSet.size() > 0){
            for(Case caseRec : [SELECT Id,CaseNumber,Case_Record_Type_Name__c, (SELECT Id,ParentId,Body,Type,CreatedById,CreatedDate,IsDeleted,Title FROM Feeds) FROM Case WHERE Id IN :caseIdSet]){
                if(caseRec.Case_Record_Type_Name__c == 'Access'){
                    Access_Case__c accessCaseRec = new Access_Case__c();
                    String accessCaseNumber = (String) caseRec.CaseNumber;
                    String accessCaseId = (String) caseRec.Id;
                    caseMap.put(caseRec.Id,caseRec);
                    if(caseRec.Feeds.size() > 0){
                        for(CaseFeed caseFeedRec : caseRec.Feeds){
                            System.debug('Id : '+caseFeedRec.Id+', ParentId : '+caseFeedRec.ParentId+', Body : '+caseFeedRec.Body);
                            if(caseFeedRec.Body != null && comments.containskey(caseFeedRec.Id)){
                                caseFeedMap.put(caseFeedRec.Id,caseFeedRec);
                            }
                        }
                    }
                }
            }
        }
        if(caseFeedMap.size() > 0){
            System.debug('Inside DEBUG 1');
            for(Id caseFeedId : caseFeedMap.keyset()){
                Id caseId = caseFeedMap.get(caseFeedId).ParentId;
                System.debug('caseId : '+caseId);
                String accessCaseNumber = '';
                String accessCaseId = '';
                String accessTypeObjectId = '';
                if(caseMap.containsKey(caseId)){
                    System.debug('Inside DEBUG 2');
                    accessCaseNumber = (String) caseMap.get(caseId).CaseNumber;
                    accessCaseId = (String) caseMap.get(caseId).Id;
                    accessTypeObjectId = (String) caseFeedId;
                }
                if(accessCaseNumber != '' && accessCaseId != '' && accessTypeObjectId != ''){
                    Access_Case__c accessCaseRec = new Access_Case__c();
                    accessCaseRec.Action__c = 'Update';
                    accessCaseRec.Case_Id__c = accessCaseId;
                    accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
                    accessCaseRec.SF_Type_Object__c = 'Comment';
                    accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
                    accessCaseObjList.add(accessCaseRec);
                }
            }
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    /* Update - Case Posts */
    
    /* Update - Case Post Reply */
    public static void feedCommentsUpdateHandler(Map<Id,FeedComment> comments){
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,FeedComment> caseFeedCommentsMap = new Map<Id,FeedComment>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        Map<String, Object> flowMapParam = new Map<String, Object>();
        for(FeedComment feedItemCommentRec : [SELECT Id,ParentId,FeedItemId,CreatedBy.Name,CreatedDate,CommentBody FROM FeedComment WHERE Id IN :comments.keyset()]){
            caseIdSet.add(feedItemCommentRec.ParentId);
            flowMapParam.put('recordId',feedItemCommentRec.Id);
        }
        if(flowMapParam.size() > 0){
            Flow.Interview.ACC_Send_Email_on_Edit_Case_Comment_Reply flowObj = new Flow.Interview.ACC_Send_Email_on_Edit_Case_Comment_Reply(flowMapParam);
            flowObj.start();
        }
        if(caseIdSet.size() > 0){
            for(Case caseRec : [SELECT Id,CaseNumber,Case_Record_Type_Name__c FROM Case WHERE Id IN :caseIdSet]){
                if(caseRec.Case_Record_Type_Name__c == 'Access'){
                    caseMap.put(caseRec.Id,caseRec);
                }
            }
        }
        for(FeedComment feedCommentRec : [SELECT Id,ParentId,FeedItemId,CreatedBy.Name,CreatedDate,CommentBody FROM FeedComment WHERE Id IN :comments.keyset()]){
            String accessCaseNumber = '';
            String accessCaseId = '';
            String accessTypeObjectId = '';
            if(caseMap.containskey(feedCommentRec.ParentId)){
                accessCaseNumber = (String) caseMap.get(feedCommentRec.ParentId).CaseNumber;
                accessCaseId = (String) caseMap.get(feedCommentRec.ParentId).Id;
                accessTypeObjectId = (String) feedCommentRec.Id;
            }
            if(accessCaseId != ''){
                Access_Case__c accessCaseRec = new Access_Case__c();
                accessCaseRec.Action__c = 'Update';
                accessCaseRec.Case_Id__c = accessCaseId;
                accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
                accessCaseRec.SF_Type_Object__c = 'CommentRep';
                accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
                accessCaseObjList.add(accessCaseRec);
            }
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    /* Update - Case Post Reply */
    
    /* Insert - Case Post Reply */
    public static void feedCommentsInsertHandler(Map<Id,FeedComment> comments){
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,FeedComment> caseFeedCommentsMap = new Map<Id,FeedComment>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        Map<String, Object> flowMapParam = new Map<String, Object>();
        for(FeedComment feedItemCommentRec : [SELECT Id,ParentId,FeedItemId,CreatedBy.Name,CreatedDate,CommentBody FROM FeedComment WHERE Id IN :comments.keyset()]){
            flowMapParam.put('recordId',feedItemCommentRec.Id);
            caseIdSet.add(feedItemCommentRec.ParentId);
        }
        if(flowMapParam.size() > 0){
            //Flow.Interview.ACC_Email_on_Case_Comment_Reply_Create flowObj = new Flow.Interview.ACC_Email_on_Case_Comment_Reply_Create(flowMapParam);
            Flow.Interview.ACC_Send_Email_on_Case_Comment_Reply flowObj = new Flow.Interview.ACC_Send_Email_on_Case_Comment_Reply(flowMapParam);
            flowObj.start();
        }
        if(caseIdSet.size() > 0){
            for(Case caseRec : [SELECT Id,CaseNumber,Case_Record_Type_Name__c FROM Case WHERE Id IN :caseIdSet]){
                if(caseRec.Case_Record_Type_Name__c == 'Access'){
                    caseMap.put(caseRec.Id,caseRec);
                }
            }
        }
        for(FeedComment feedCommentRec : [SELECT Id,ParentId,FeedItemId,CreatedBy.Name,CreatedDate,CommentBody FROM FeedComment WHERE Id IN :comments.keyset()]){
            String accessCaseNumber = '';
            String accessCaseId = '';
            String accessTypeObjectId = '';
            if(caseMap.containskey(feedCommentRec.ParentId)){
                accessCaseNumber = (String) caseMap.get(feedCommentRec.ParentId).CaseNumber;
                accessCaseId = (String) caseMap.get(feedCommentRec.ParentId).Id;
                accessTypeObjectId = (String) feedCommentRec.Id;
            }
            if(accessCaseId != ''){
                Access_Case__c accessCaseRec = new Access_Case__c();
                accessCaseRec.Action__c = 'Insert';
                accessCaseRec.Case_Id__c = accessCaseId;
                accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
                accessCaseRec.SF_Type_Object__c = 'CommentRep';
                accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
                accessCaseObjList.add(accessCaseRec);
            }
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
    /* Insert - Case Post Reply */
    
    /* Insert - Case Posts */
    public static void feedsInsertHandler(Map<Id,FeedItem> comments){
        System.debug('comments'+comments);
        List<Access_Case__c> accessCaseObjList = new List<Access_Case__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,CaseFeed> caseFeedMap = new Map<Id,CaseFeed>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        Map<String, Object> flowMapParam = new Map<String, Object>();
        for(FeedItem feedItemRec : [SELECT Id,ParentId,Body,Title,CreatedById,CreatedDate FROM FeedItem WHERE Id IN :comments.keyset()]){
            caseIdSet.add(feedItemRec.ParentId);
            flowMapParam.put('recordId',feedItemRec.Id);
        }
        if(flowMapParam.size() > 0){
            Flow.Interview.ACC_Send_Email_on_Adding_Comment_Apex_1 flowObj = new Flow.Interview.ACC_Send_Email_on_Adding_Comment_Apex_1(flowMapParam);
            flowObj.start();
        }
        System.debug('caseIdSet : '+caseIdSet);
        if(caseIdSet.size() > 0){
            for(Case caseRec : [SELECT Id,CaseNumber,Case_Record_Type_Name__c, (SELECT Id,ParentId,Body,Type,CreatedById,CreatedDate,IsDeleted,Title FROM Feeds) FROM Case WHERE Id IN :caseIdSet]){
                if(caseRec.Case_Record_Type_Name__c == 'Access'){
                    Access_Case__c accessCaseRec = new Access_Case__c();
                    String accessCaseNumber = (String) caseRec.CaseNumber;
                    String accessCaseId = (String) caseRec.Id;
                    caseMap.put(caseRec.Id,caseRec);
                    if(caseRec.Feeds.size() > 0){
                        for(CaseFeed caseFeedRec : caseRec.Feeds){
                            System.debug('Id : '+caseFeedRec.Id+', ParentId : '+caseFeedRec.ParentId+', Body : '+caseFeedRec.Body);
                            if(caseFeedRec.Body != null && comments.containskey(caseFeedRec.Id)){
                                caseFeedMap.put(caseFeedRec.Id,caseFeedRec);
                            }
                        }
                    }
                }
            }
        }
        if(caseFeedMap.size() > 0){
            System.debug('Inside DEBUG 1');
            for(Id caseFeedId : caseFeedMap.keyset()){
                Id caseId = caseFeedMap.get(caseFeedId).ParentId;
                System.debug('caseId : '+caseId);
                String accessCaseNumber = '';
                String accessCaseId = '';
                String accessTypeObjectId = '';
                if(caseMap.containsKey(caseId)){
                    System.debug('Inside DEBUG 2');
                    accessCaseNumber = (String) caseMap.get(caseId).CaseNumber;
                    accessCaseId = (String) caseMap.get(caseId).Id;
                    accessTypeObjectId = (String) caseFeedId;
                }
                if(accessCaseNumber != '' && accessCaseId != '' && accessTypeObjectId != ''){
                    Access_Case__c accessCaseRec = new Access_Case__c();
                    accessCaseRec.Action__c = 'Insert';
                    accessCaseRec.Case_Id__c = accessCaseId;
                    accessCaseRec.Salesforce_Case_Number__c = accessCaseNumber;
                    accessCaseRec.SF_Type_Object__c = 'Comment';
                    accessCaseRec.SF_Type_Object_Id__c = accessTypeObjectId;
                    accessCaseObjList.add(accessCaseRec);
                }
            }
        }
        if(accessCaseObjList.size() > 0){
            insert accessCaseObjList;
        }
    }
}