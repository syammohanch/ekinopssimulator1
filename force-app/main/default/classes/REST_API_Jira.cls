/**
 * Test Method:
 */
public with sharing class REST_API_Jira {

    private static Map<String, String> mapTranscoPriority_PRT = new Map<String, String>{
        'Critical'=> 'Urgent',
        'Major'=> 'Urgent',
        'Minor'=> 'Not urgent',
        'Normal'=> 'Routine',
        'Very urgent'=> 'Urgent'
    };
    
    private static Map<String, String> mapTranscoJiraStatus_FRT = new Map<String, String>{
        'Go for Quote'=> '81',
        'Go for dev approved'=> '211',
        'Go for Quote Declined'=> '281',
        'Go for Dev Declined'=> '291'
    };

    /**
     * fieldMapAccount SingleTon
     * @return instanciating it or getting it
     */ 
    public static Map<String, Schema.SObjectField> fieldMapAccount {
        get {
            if(fieldMapAccount == null) {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchemaAccount = schemaMap.get('Account');
                fieldMapAccount = leadSchemaAccount.getDescribe().fields.getMap();
            }
            return fieldMapAccount;
        }
       private set;
    }

    /**
     * fieldMapJiraTicket SingleTon
     * @return instanciating it or getting it
     */ 
    public static Map<String, Schema.SObjectField> fieldMapJiraTicket {
        get {
            if(fieldMapJiraTicket == null) {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchemaJiraTicket = schemaMap.get('JiraTicket__c');
                fieldMapJiraTicket = leadSchemaJiraTicket.getDescribe().fields.getMap();
            }
            return fieldMapJiraTicket;
        }
       private set;
    }

    /**
     * fieldMapJiraTicket SingleTon
     * @return instanciating it or getting it
     */ 
    public static Map<String, Schema.SObjectField> fieldMapUser {
        get {
            if(fieldMapUser == null) {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchemaUser = schemaMap.get('User');
                fieldMapUser = leadSchemaUser.getDescribe().fields.getMap();
            }
            return fieldMapUser;
        }
       private set;
    }

/* PUBLIC METHODS */
    public static void createToJiraFromJiraTicket(List<JiraTicket__c> listJiraTicketsToSend){
        List<JiraTicket__c> listJiraTicketFRT = new List<JiraTicket__c>();
        List<JiraTicket__c> listJiraTicketPRT = new List<JiraTicket__c>();
        List<JiraTicket__c> listJiraTicketSAP = new List<JiraTicket__c>();

        //We have to order the different TypePick__c in order to send the corresponding flow
        for (JiraTicket__c jiraTicket : listJiraTicketsToSend) {
            switch on jiraTicket.TypePick__c {
                when 'FRT' {
                    listJiraTicketFRT.add(jiraTicket);
                }
                when 'PRT' {
                    listJiraTicketPRT.add(jiraTicket);
                }
                when 'SAP' {
                    listJiraTicketSAP.add(jiraTicket);
                }
            }
        }

        if (!listJiraTicketFRT.isEmpty()) {
            manageFlowJiraTicketFRT(listJiraTicketFRT);
        } else if (!listJiraTicketPRT.isEmpty()) {
            manageFlowJiraTicketPRT(listJiraTicketPRT);
        } else if (!listJiraTicketSAP.isEmpty()) {
            manageFlowJiraTicketSAP(listJiraTicketSAP);
        }
    } 
    
    public static void updateToJiraFromJiraTicket(List<JiraTicket__c> listJiraTicketsToSend){
        List<JiraTicket__c> listJiraTicketFRT = new List<JiraTicket__c>();

        //We have to order the different TypePick__c in order to send the corresponding flow
        for (JiraTicket__c jiraTicket : listJiraTicketsToSend) {
            switch on jiraTicket.TypePick__c {
                when 'FRT' {
                    listJiraTicketFRT.add(jiraTicket);
                }
            }
        }

        if (!listJiraTicketFRT.isEmpty()) {
            manageFlowJiraTicketFRTUpdate(listJiraTicketFRT);
        }
    }
    
    private static string getReporterEmail(JiraTicket__c jiraTicketFRT) {

        JIRA_Connect_Settings__c setting = JIRA_Connect_Settings__c.getInstance();
        String defaultEmail = setting.One_Ticket_Default_Reporter_Email__c;

        return (
            IsSandbox() || Test.isRunningTest() ? 
            defaultEmail : 
            (jiraTicketFRT.Owner.Email.contains('ekinops.com') ? jiraTicketFRT.Owner.Email : defaultEmail ) );
    }

    /* PRIVATE METHODS */

    /*
     * Method: manageFlowJiraTicketFRT build specific FRT flow
     * Origin: case EKI-284
     */
    private static void manageFlowJiraTicketFRT(List<JiraTicket__c> listJiraTicketsFRTToSend){
        REST_API_JIRA_Settings.FRT_Body frtBody;
        Map<String,String> mapBodyByJiraTicket;
        String serializedBody;

        JIRA_Connect_Settings__c setting = JIRA_Connect_Settings__c.getInstance();

        for (JiraTicket__c jiraTicketFRT : listJiraTicketsFRTToSend) {
            frtBody = new REST_API_JIRA_Settings.FRT_Body();
            mapBodyByJiraTicket = new Map<String,String>();

            frtBody.fields.summary = avoidNullValue(jiraTicketFRT.Summary__c);//OpportunityRef__r.Summary__c);
            //frtBody.fields.customfield_11625 = jiraTicketFRT.OpportunityRef__c;
            frtBody.fields.customfield_17702 = jiraTicketFRT.OpportunityRef__r.Opportunity_ID__c;
            frtBody.fields.description = avoidNullValue(jiraTicketFRT.FRTDescription__c);//OpportunityRef__r.Description);
            frtBody.fields.reporter.name = getReporterEmail(jiraTicketFRT);//'SA-SALESFORCE-ONETICKETS@ekinops.com';
            frtBody.fields.customfield_11605 = setting.One_Ticket_Default_Product_Manager__c;//'Luc Peyrat';
            frtBody.fields.customfield_11703 = setting.One_Ticket_Default_Component_Assignee__c;//'Luc.peyrat@ekinops.com';

            serializedBody = JSON.serialize(frtBody);
            system.debug('#### : ' + serializedBody);
            mapBodyByJiraTicket.put(jiraTicketFRT.Id, serializedBody);
            sendJiraRequest(JSON.serialize(mapBodyByJiraTicket));
        }
    }
    
    /*
     * Method: manageFlowJiraTicketFRTUpdate build specific FRT flow
     * 
     */
    private static void manageFlowJiraTicketFRTUpdate(List<JiraTicket__c> listJiraTicketsFRTToUpdate){
        REST_API_JIRA_Settings.FRT_Update_Body frtUpdateBody;
        Map<String,String> mapBodyByJiraTicket;
        String serializedBody;
        
        Map<Id, List<String>> mapRequestComments = getRequestComments(listJiraTicketsFRTToUpdate);
        
        for (JiraTicket__c jiraTicketFRT : listJiraTicketsFRTToUpdate) {
            frtUpdateBody = new REST_API_JIRA_Settings.FRT_Update_Body();
            mapBodyByJiraTicket = new Map<String,String>();
            
            frtUpdateBody.transition.id = mapTranscoJiraStatus_FRT.get(jiraTicketFRT.StatusPick__c);//'81';
            frtUpdateBody.updateVar.comment.add(new REST_API_JIRA_Settings.FRT_Update_commment());
            List<String> listComments = mapRequestComments.get(jiraTicketFRT.Id);
            String strCommentForJira = '';
            if (listComments != null) {
                for (String comment : listComments) {
                    strCommentForJira += comment + '\n';
                }
            }
            frtUpdateBody.updateVar.comment[0].add.body = strCommentForJira;
            
            serializedBody = JSON.serialize(frtUpdateBody);
            serializedBody = serializedBody.replace('updateVar', 'update');
            system.debug('#### : ' + serializedBody);
            mapBodyByJiraTicket.put(jiraTicketFRT.Id, serializedBody);
            updateJiraRequest(JSON.serialize(mapBodyByJiraTicket));
        }
    }

    /*
     * Method: manageFlowJiraTicketPRT build specific PRT flow
     * Origin: case EKI-284
     */
    private static void manageFlowJiraTicketPRT(List<JiraTicket__c> listJiraTicketsPRTToSend){
        REST_API_JIRA_Settings.PRT_Body prtBody;
        Map<String,String> mapBodyByJiraTicket;
        String serializedBody;

        for (JiraTicket__c jiraTicketPRT : listJiraTicketsPRTToSend) {
            prtBody = new REST_API_JIRA_Settings.PRT_Body();
            mapBodyByJiraTicket = new Map<String,String>();

            prtBody.fields.summary = jiraTicketPRT.CaseRef__r.Subject;
            prtBody.fields.reporter.name =  getReporterEmail(jiraTicketPRT);//'SA-SALESFORCE-ONETICKETS@ekinops.com';
            prtBody.fields.customfield_13517 = avoidNullValue(jiraTicketPRT.CaseRef__r.Description);
            prtBody.fields.customfield_13508 = jiraTicketPRT.CaseRef__r.Account.Name;
            prtBody.fields.customfield_13562 = new List<String>{jiraTicketPRT.CaseRef__r.AccountId};
            prtBody.fields.customfield_15201 = jiraTicketPRT.CaseRef__r.Status;
            prtBody.fields.customfield_13529 = jiraTicketPRT.CaseRef__r.Product.Name;
            prtBody.fields.components.add(new REST_API_JIRA_Settings.PRT_components());
            prtBody.fields.components[0].name = jiraTicketPRT.CaseRef__r.Type;
            prtBody.fields.priority.name = mapTranscoPriority_PRT.get(jiraTicketPRT.CaseRef__r.Priority);

            serializedBody = JSON.serialize(prtBody);
            mapBodyByJiraTicket.put(jiraTicketPRT.Id, serializedBody);
            sendJiraRequest(JSON.serialize(mapBodyByJiraTicket));
        }        
    }

    /*
     * Method: manageFlowJiraTicketSAP build specific SAP flow
     * Origin: case EKI-286
     */
    private static void manageFlowJiraTicketSAP(List<JiraTicket__c> listJiraTicketsSAPToSend){
        Map<String,String> mapBodyByJiraTicket;
        String serializedBody;
        
        Map<Id, RelatedAccount__c> mapRelatedAccountsData = getRelatedAccountsData(listJiraTicketsSAPToSend);

        for (JiraTicket__c jiraTicketSAP : listJiraTicketsSAPToSend) {
            mapBodyByJiraTicket = new Map<String,String>();
            if(jiraTicketSAP.AccountRef__c != null && jiraTicketSAP.SubtypePick__c == 'Sold to'){
                REST_API_JIRA_Settings.SAP_Account_Sold_To_Body sapAccountSoldToBody = new REST_API_JIRA_Settings.SAP_Account_Sold_To_Body();

                sapAccountSoldToBody.fields.summary = 'Sold To Customer Creation Request: '+jiraTicketSAP.AccountRef__r.Name;
                sapAccountSoldToBody.fields.reporter.name = getReporterEmail(jiraTicketSAP);//'SA-SALESFORCE-ONETICKETS@ekinops.com';
                sapAccountSoldToBody.fields.customfield_13901 = jiraTicketSAP.AccountRef__c;
                sapAccountSoldToBody.fields.description = buildTableForSAPDescriptionField_soldTo(jiraTicketSAP);

                serializedBody = JSON.serialize(sapAccountSoldToBody);
                mapBodyByJiraTicket.put(jiraTicketSAP.Id, serializedBody);
            }else if(jiraTicketSAP.AccountRef__c != null && jiraTicketSAP.SubtypePick__c != 'Sold to'){
                REST_API_JIRA_Settings.SAP_Other_Account_Body sapOtherAccountBody = new REST_API_JIRA_Settings.SAP_Other_Account_Body();
                
                RelatedAccount__c relatedAccount = mapRelatedAccountsData.get(jiraTicketSAP.AccountRef__c);

                sapOtherAccountBody.fields.reporter.name = getReporterEmail(jiraTicketSAP);//'SA-SALESFORCE-ONETICKETS@ekinops.com';
                sapOtherAccountBody.fields.summary = 'Create :'+jiraTicketSAP.SubtypePick__c;
                sapOtherAccountBody.fields.issueType.name = jiraTicketSAP.SubtypePick__c == 'Final customer' ? 'Create: Final Customer' 
                                                            : jiraTicketSAP.SubtypePick__c == 'Bill to' ? 'Create: Bill-To Customer'
                                                            : jiraTicketSAP.SubtypePick__c == 'Shipped to'	? 'Create: Ship-To Customer'
                                                            : '';
                sapOtherAccountBody.fields.customfield_13901 = jiraTicketSAP.AccountRef__c;
                sapOtherAccountBody.fields.description = buildTableForSAPDescriptionField_NOTsoldTo(jiraTicketSAP, relatedAccount);

                serializedBody = JSON.serialize(sapOtherAccountBody);
                mapBodyByJiraTicket.put(jiraTicketSAP.Id, serializedBody);

            }else if(jiraTicketSAP.ProjectRef__c != null){
                REST_API_JIRA_Settings.SAP_Project_Body sapProjectBody = new REST_API_JIRA_Settings.SAP_Project_Body();

            }
            if(!mapBodyByJiraTicket.isEmpty()){
                sendJiraRequest(JSON.serialize(mapBodyByJiraTicket));
            }
        }
    }

    /**
     * Method: buildTableForSAPDescriptionField_soldTo use to build a table for description field on SAP ticket
     * each line below is a line on the table
     * Origin: case EKI-284 & EKI-286
     */
    private static String buildTableForSAPDescriptionField_soldTo(JiraTicket__c jiraTicketSAP){
        String JUMP_LINE = '\r\n';
        String BORDER = '|';        
        String table = '';

        table += BORDER+fieldMapAccount.get('Name').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Name)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Description').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Description)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Classification_type__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Classification_type__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('BillingCountry').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.BillingCountry)+BORDER+JUMP_LINE;
        //table += BORDER+fieldMapAccount.get('CurrencyPick__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.CurrencyPick__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('CurrencyIsoCode').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.CurrencyIsoCode)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('BillingCity').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.BillingCity)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('BillingStreet').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.BillingStreet)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('BillingPostalCode').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.BillingPostalCode)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Phone').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Phone)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Fax').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Fax)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('VATTaxNumber__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.VATTaxNumber__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('TimeZone__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.TimeZone__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('LanguagePick__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.LanguagePick__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('IncotermsPick__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.IncotermsPick__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('PaymentTerms__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.PaymentTerms__c)+BORDER+JUMP_LINE;
        //table += BORDER+fieldMapAccount.get('Owner.Name').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Region__c)+BORDER+JUMP_LINE;
        //table += BORDER+'Nom'+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Region__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Region__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Region__c)+BORDER+JUMP_LINE;
        //table += BORDER+fieldMapUser.get('Name').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Owner.Name)+BORDER+JUMP_LINE;
        //table += BORDER+fieldMapUser.get('Name').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.RegionalManagerRef__r.Name)+BORDER;
		table += BORDER+fieldMapAccount.get('Line_of_business__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Line_of_business__c)+BORDER+JUMP_LINE;
        table += BORDER+'AM Name'+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Owner.Name)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('RegionalManagerRef__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.RegionalManagerRef__r.Name)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('SalesDirectorRef__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.SalesDirectorRef__r.Name)+BORDER;
        
        return table;
    }

    /**
     * Method: buildTableForSAPDescriptionField_soldTo use to build a table for description field on SAP ticket
     * each line below is a line on the table
     * Origin: case EKI-284 & EKI-286
     */
    private static String buildTableForSAPDescriptionField_NOTsoldTo(JiraTicket__c jiraTicketSAP, RelatedAccount__c relatedAccount){
        String JUMP_LINE = '\r\n';
        String BORDER = '|';
        String table = '';
        
        table += BORDER+fieldMapAccount.get('Name').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Name)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapJiraTicket.get('AccountRef__c').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__c)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('Description').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.Description)+BORDER+JUMP_LINE;
        table += BORDER+fieldMapAccount.get('BillingCountry').getDescribe().getLabel()+BORDER+avoidNullValue(jiraTicketSAP.AccountRef__r.BillingCountry)+BORDER+JUMP_LINE;
		table += 
            BORDER+'Sold to Account'+BORDER
            +(relatedAccount.SoldToRef__r.AccountSAPECCID__c != null ? 'SAP ECC Id: '+avoidNullValue(relatedAccount.SoldToRef__r.AccountSAPECCID__c) + ' / ' : '')
            +'Salesforce Id: '+avoidNullValue(relatedAccount.SoldToRef__c)
            +BORDER;
        
        return table;
    }
    
    private static Map<Id, RelatedAccount__c> getRelatedAccountsData(List<JiraTicket__c> listNewJiraTicket){
        Map<Id, RelatedAccount__c> mapRelatedAccountsData = new Map<Id, RelatedAccount__c>();
        for (RelatedAccount__c relAccount : [SELECT id, SoldToRef__c, SoldToRef__r.Name, SoldToRef__r.AccountSAPECCID__c, RelatedAccountRef__c
                                                FROM RelatedAccount__c 
                                              WHERE RelatedAccountRef__c IN (SELECT AccountRef__c FROM JiraTicket__c WHERE ID IN :listNewJiraTicket) ]) {
        	
			mapRelatedAccountsData.put(relAccount.RelatedAccountRef__c, relAccount);      	                                          
        }
        return mapRelatedAccountsData;
    }
    
    private static Map<Id, List<String>> getRequestComments(List<JiraTicket__c> listUpdatedJiraTicket){
        Map<Id, List<String>> mapRequestComments = new Map<Id, List<String>>();
        Map<Id, Request__c> mapRequests = 
            new Map<Id, Request__c>([SELECT Id, JiraTicketRef__c FROM Request__c WHERE JiraTicketRef__c IN :listUpdatedJiraTicket]);
        
        for (ProcessInstance procInst : [SELECT TargetObjectId, (SELECT Id, StepStatus, OriginalActor.Name, Actor.Name, Comments, CreatedDate from StepsAndWorkitems ORDER BY CreatedDate) 
                                           FROM ProcessInstance 
                                           WHERE TargetObjectId IN (SELECT Id FROM Request__c WHERE JiraTicketRef__c IN :listUpdatedJiraTicket)
                                           ORDER BY CreatedDate ASC
                                        ]) {
                                               
        	List<String> listComments = new List<String>();
            for (ProcessInstanceHistory procInstHist : procInst.StepsAndWorkitems) {
				
                String comment = (procInstHist.Comments != null ? procInstHist.Comments : 'No comment');
                String actor = (procInstHist.StepStatus == 'Reassigned' ? procInstHist.OriginalActor.Name : procInstHist.Actor.Name);
                listComments.add(procInstHist.CreatedDate + ' - ' + actor + ' - ' + comment);//procInstHist.Comments);      	    
            }
            Request__c req = mapRequests.get(procInst.TargetObjectId);                                   
            mapRequestComments.put(req.JiraTicketRef__c, listComments);
        }
        return mapRequestComments;
    }
    
    /**
     * Method: updateJiraRequest
     */
    @future(callout=true)
    private static void updateJiraRequest(String mapBodyByJiraTicketSerialized){        
        Map<String, String> mapBodyByJiraTicket = (Map<String, String>)System.JSON.deserializeStrict(mapBodyByJiraTicketSerialized, Map<String, String>.class);
        JiraTicket__c jiraTicket = [SELECT Id, Jira_Id__c
                                    	FROM JiraTicket__c 
                                        WHERE Id IN :mapBodyByJiraTicket.keySet() LIMIT 1];
        
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Boolean IsSandbox = IsSandbox();
            JIRA_Connect_Settings__c JiraCustomSettings = JIRA_Connect_Settings__c.getInstance();
            //manage sandbox or production endpoint
            String endPoint = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Endpoint__c : JiraCustomSettings.One_Ticket_Prod_Endpoint__c;
            //manage if we are in update or insert context on Jira
            endPoint += '/'+ jiraTicket.Jira_Id__c + '/transitions?expand=transitions.fields';

            String authorization = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Authorization__c : JiraCustomSettings.One_Ticket_Prod_Authorization__c;

            request.setEndpoint(endPoint);
            request.setMethod('POST');
            request.setBody((String)mapBodyByJiraTicket.values()[0]);
            request.setHeader('Authorization', authorization);
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(8000);

            HttpResponse jiraResponse =  http.send(request);           
            //jiraTicket = extractJiraIssueResponse(jiraResponse, jiraTicket);
            readJiraIssueResponse(jiraResponse, jiraTicket);
            
        } catch (Exception ex) {
            manageError(ex, jiraTicket);
        }
    }

    /**
     * Method: sendJiraRequest
     * Origin: case EKI-284 & EKI-286
     * Description: /!\ In Jira Response, we don't have sfdc JiraTicket__c's id available, so we can't bulkify flow
     *                  we have to send record one by one in order to save response to the good one /!\
     */
    @future(callout=true)
    private static void sendJiraRequest(String mapBodyByJiraTicketSerialized){
            Map<String, String> mapBodyByJiraTicket = (Map<String, String>)System.JSON.deserializeStrict(mapBodyByJiraTicketSerialized, Map<String, String>.class);
            JiraTicket__c jiraTicket = [SELECT Id, Jira_Id__c, AccountRef__c, TECH_Credit_App_Form_is_send__c, TECH_Loan_Credit_App_Form_is_send__c, TECH_Certificate_Of_Registration_is_send__c
                                        FROM JiraTicket__c 
                                        WHERE Id IN :mapBodyByJiraTicket.keySet() LIMIT 1];
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Boolean IsSandbox = IsSandbox();
            JIRA_Connect_Settings__c JiraCustomSettings = JIRA_Connect_Settings__c.getInstance();
            //manage sandbox or production endpoint
            String endPoint = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Endpoint__c : JiraCustomSettings.One_Ticket_Prod_Endpoint__c;
            //manage if we are in update or insert context on Jira
            endPoint += jiraTicket.Jira_Id__c != null ? '/'+jiraTicket.Jira_Id__c : '';

            String authorization = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Authorization__c : JiraCustomSettings.One_Ticket_Prod_Authorization__c;

            request.setEndpoint(endPoint);
            request.setMethod('POST');
            request.setBody((String)mapBodyByJiraTicket.values()[0]);
            request.setHeader('Authorization', authorization);
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(8000);

            HttpResponse jiraResponse =  http.send(request);           
            jiraTicket = extractJiraIssueResponse(jiraResponse, jiraTicket);

            //manage Account's attachment
            if(jiraTicket.AccountRef__c != null && jiraTicket.Jira_Id__c != null){
                List<String> listContentDocumentId = new List<String>();                
                //Get all ContentDocument from the Account
                List<ContentDocumentLink> listContentDocumentLink = [SELECT Id, LinkedEntityId, ContentDocumentId 
                                                                        FROM ContentDocumentLink 
                                                                        WHERE LinkedEntityId =:jiraTicket.AccountRef__c];
                for (ContentDocumentLink contentDocLink : listContentDocumentLink) {
                    listContentDocumentId.add(contentDocLink.ContentDocumentId);
                }
                //Get all ContentVersion from the previous ContentDocumentLink and the relevent Type__c of documents
                List<ContentVersion> listContentVersion = [SELECT id, Type__c, VersionData, Title, FileExtension
                                                            FROM ContentVersion 
                                                            WHERE ContentDocumentId IN:listContentDocumentId AND IsLatest = true
                                                            AND Type__c IN ('Credit Application Form', 'Loan Credit Application Form', 'Certificate Of Registration')];

                List<ContentVersion> listContentVersionToSend = new List<ContentVersion>();
                if(!listContentVersion.isEmpty()){
                    //be sure the document was not already sended
                    for (ContentVersion content : listContentVersion) {
                        if(content.Type__c == 'Credit Application Form' && !jiraTicket.TECH_Credit_App_Form_is_send__c){
                            listContentVersionToSend.add(content);
                        }else if(content.Type__c == 'Loan Credit Application Form' && !jiraTicket.TECH_Loan_Credit_App_Form_is_send__c){
                            listContentVersionToSend.add(content);
                        }else if(content.Type__c == 'Certificate Of Registration' && !jiraTicket.TECH_Certificate_Of_Registration_is_send__c){
                            listContentVersionToSend.add(content);
                        }
                    }
                    HTTPResponse jiraResponseAttachment = new HTTPResponse();
                    HTTPResponse jiraContentResponseKO = new HTTPResponse();
                    for (ContentVersion content : listContentVersionToSend) {
                        //Perform sending
                        jiraResponseAttachment = sendJiraAttachment(JiraCustomSettings, content, jiraTicket, IsSandbox);
                        //check the status code to success
                        if(jiraResponseAttachment.getStatusCode() == 200 || jiraResponseAttachment.getStatusCode() == 201){
                            if(content.Type__c == 'Credit Application Form'){
                                jiraTicket.TECH_Credit_App_Form_is_send__c = true;
                            }else if(content.Type__c == 'Loan Credit Application Form'){
                                jiraTicket.TECH_Loan_Credit_App_Form_is_send__c = true;
                            }else if(content.Type__c == 'Certificate Of Registration'){
                                jiraTicket.TECH_Certificate_Of_Registration_is_send__c = true;
                            }
                        }
                    }
                    if(jiraContentResponseKO.getStatusCode() != 0){
                        readJiraIssueResponse(jiraContentResponseKO, jiraTicket);
                    }else {
                        readJiraIssueResponse(jiraResponse, jiraTicket);                        
                    }
                }else {
                    readJiraIssueResponse(jiraResponse, jiraTicket);
                }
            }else {
                readJiraIssueResponse(jiraResponse, jiraTicket);                
            }
        } catch (Exception ex) {
            manageError(ex, jiraTicket);
        }
    }

    //following method is used to send attachment to JIRA
    //Source: http://enreeco.blogspot.com/2013/01/salesforce-apex-post-mutipartform-data.html
    private static HTTPResponse sendJiraAttachment(JIRA_Connect_Settings__c JiraCustomSettings, ContentVersion content, JiraTicket__c jiraTicket, Boolean IsSandbox){
        String endPoint = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Endpoint__c : JiraCustomSettings.One_Ticket_Prod_Endpoint__c;
        String authorization = IsSandbox ? JiraCustomSettings.One_Ticket_Dev_Authorization__c : JiraCustomSettings.One_Ticket_Prod_Authorization__c;

        endPoint += '/'+jiraTicket.Jira_Id__c+'/attachments';
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+content.Title+'.'+content.FileExtension+'"\r\nContent-Type: application/octet-stream'; 
        String footer = '\r\n--'+boundary+'--';              
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('=')){
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(content.VersionData);
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        if(last4Bytes.endsWith('=')){
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = tmp.getBody()+footer;   
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }else{
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setHeader('X-Atlassian-Token', 'no-check');
        req.setMethod('POST');       
        req.setHeader('Authorization', authorization);
        req.setEndpoint(endPoint);
        req.setBodyAsBlob(bodyBlob);
        req.setTimeout(12000);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res;
    }

    /**
     * Method: readJiraIssueResponse use to check if we are in sandbox context or production
     * Origin: case EKI-284 & EKI-286
     */
    private static void readJiraIssueResponse(HttpResponse jiraResponse, JiraTicket__c jiraTicket){
        //Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jiraResponse.getBody());

        jiraTicket.Last_Jira_Synch_Date__c = System.now();//today();

        if(jiraResponse.getStatusCode() == 200 || jiraResponse.getStatusCode() == 201){
            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jiraResponse.getBody());
            jiraTicket.Last_Jira_Synch_Statut__c = true;
            jiraTicket.Jira_Id__c = (String)responseMap.get('id');
            jiraTicket.Jira_Key__c = (String)responseMap.get('key');
            jiraTicket.Last_Jira_Synch_Message__c = 'OK';
        } else if (jiraResponse.getStatusCode() == 204) {
            jiraTicket.Last_Jira_Synch_Statut__c = true;
            jiraTicket.Last_Jira_Synch_Message__c = 'OK';
        } else {
            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jiraResponse.getBody());
            jiraTicket.Last_Jira_Synch_Statut__c = false;
            jiraTicket.Last_Jira_Synch_Message__c = jiraResponse.getStatusCode()+': '+responseMap.get('errors');
        }
        UPDATE jiraTicket;
    }

    private static JiraTicket__c extractJiraIssueResponse(HttpResponse jiraResponse, JiraTicket__c jiraTicket){
        //Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jiraResponse.getBody());

        jiraTicket.Last_Jira_Synch_Date__c = System.now();//today();

        if(jiraResponse.getStatusCode() == 200 || jiraResponse.getStatusCode() == 201){
            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jiraResponse.getBody());
            jiraTicket.Last_Jira_Synch_Statut__c = true;
            jiraTicket.Jira_Id__c = (String)responseMap.get('id');
            jiraTicket.Jira_Key__c = (String)responseMap.get('key');
            jiraTicket.Last_Jira_Synch_Message__c = 'OK';
        } else if (jiraResponse.getStatusCode() == 204) {
            jiraTicket.Last_Jira_Synch_Statut__c = true;
            jiraTicket.Last_Jira_Synch_Message__c = 'OK';
        } else {
            readJiraIssueResponse(jiraResponse, jiraTicket);
        }
        return jiraTicket;
    }

    private static void manageError(Exception ex, JiraTicket__c jiraTicket){
        jiraTicket.Last_Jira_Synch_Date__c = System.now();
        jiraTicket.Last_Jira_Synch_Message__c = 'KO';
        jiraTicket.Last_Jira_Synch_Statut__c = false;
        jiraTicket.Last_Jira_Synch_Message__c = 'Salesforce Error: line: '+ex.getLineNumber()+'→ '+ex.getCause()+': '+ex.getMessage();
        UPDATE jiraTicket;
    }

    /**
     * Method: IsSandbox use to check if we are in sandbox context or production!
     * Origin: case EKI-284 & EKI-286
     */
    private static Boolean IsSandbox(){
        Organization currentOrg = [SELECT Id, IsSandbox FROM Organization];
        return currentOrg.IsSandbox;
    }

    /**
     * Method: avoidNullValue use to check if the input is null value to avoid 'null' in the field
     * Origin: case EKI-284 & EKI-286
     */
    private static String avoidNullValue(String input){
        return String.isEmpty(input) ? ' ' : input;
    }
}