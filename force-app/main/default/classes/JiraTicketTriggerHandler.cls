public with sharing class JiraTicketTriggerHandler {

    /**
     * Method afterInsertHandlerMethod
     * Origin: case EKI-284, EKI-286, EKI-287
     */
    public static void afterInsertHandlerMethod(List<JiraTicket__c> listNewJiraTicket) {

        list<JiraTicket__c> listJiraTicketsToSendToJira = new list<JiraTicket__c>();
        Map<id, JiraTicket__c> mapJiraTicketRelationshipsDatas = getJiraTicketRelationShipsData(listNewJiraTicket);

        for (JiraTicket__c jiraTicket : listNewJiraTicket) {
            
            if (!jiraTicket.Last_Jira_Synch_Statut__c) {
                if(jiraTicket.TypePick__c == 'PRT' || (jiraTicket.TypePick__c == 'FRT' && jiraTicket.Jira_Key__c == null)){ //case EKI-284
                    listJiraTicketsToSendToJira.add(mapJiraTicketRelationshipsDatas.get(jiraTicket.Id));
                }else if(jiraTicket.TypePick__c == 'SAP' && jiraTicket.AccountRef__c != null){ //case EKI-287 
                    listJiraTicketsToSendToJira.add(mapJiraTicketRelationshipsDatas.get(jiraTicket.Id));
                }else if(jiraTicket.TypePick__c == 'SAP' && jiraTicket.ProjectRef__c != null){ //case EKI-286
                    listJiraTicketsToSendToJira.add(mapJiraTicketRelationshipsDatas.get(jiraTicket.Id));
                }
            }
        }

        if(!listJiraTicketsToSendToJira.isEmpty()){
            REST_API_Jira.createToJiraFromJiraTicket(listJiraTicketsToSendToJira);
        }
    }

    public static void afterUpdateHandlerMethod(Map<Id, JiraTicket__c> mapOldJiraTicket, List<JiraTicket__c> listNewJiraTicket) {

        list<JiraTicket__c> listJiraTicketsToSendToJira = new list<JiraTicket__c>();
        Map<id, JiraTicket__c> mapJiraTicketRelationshipsDatas = getJiraTicketRelationShipsData(listNewJiraTicket);

        for (JiraTicket__c jiraTicket : listNewJiraTicket) {
            if(jiraTicket.TypePick__c == 'FRT'//(jiraTicket.TypePick__c == 'PRT' || jiraTicket.TypePick__c == 'FRT')
            && (mapOldJiraTicket.get(jiraTicket.Id).StatusPick__c != null)
            && (mapOldJiraTicket.get(jiraTicket.Id).StatusPick__c != jiraTicket.StatusPick__c)
            && (jiraTicket.StatusPick__c == 'Go for Quote' 
                || jiraTicket.StatusPick__c == 'Go for dev approved' 
                || jiraTicket.StatusPick__c == 'Go for Quote Declined'
                || jiraTicket.StatusPick__c == 'Go for Dev Declined')){
                listJiraTicketsToSendToJira.add(mapJiraTicketRelationshipsDatas.get(jiraTicket.Id));
            }
        }

        if(!listJiraTicketsToSendToJira.isEmpty()){
            REST_API_Jira.updateToJiraFromJiraTicket(listJiraTicketsToSendToJira);
        }
    }

    /**
     * Method getJiraTicketRelationShipsData
     * Origin: case EKI-284, EKI-286, EKI-287
     */
    private static Map<Id, JiraTicket__c> getJiraTicketRelationShipsData(List<JiraTicket__c> listNewJiraTicket){
        return new Map<Id, JiraTicket__c>([SELECT id, TypePick__c, SubtypePick__c, FRTDescription__c, StatusPick__c,
                                        AccountRef__c, AccountRef__r.AccountEKIId__c, AccountRef__r.Name, AccountRef__r.Region__c, AccountRef__r.Owner.name, AccountRef__r.Owner.email,AccountRef__r.Description, AccountRef__r.Classification_type__c, AccountRef__r.BillingCountry, AccountRef__r.CurrencyPick__c, AccountRef__r.CurrencyIsoCode, AccountRef__r.BillingCity, AccountRef__r.BillingStreet, AccountRef__r.BillingPostalCode, AccountRef__r.Phone, AccountRef__r.Fax, AccountRef__r.VATTaxNumber__c, AccountRef__r.TimeZone__c, AccountRef__r.LanguagePick__c, AccountRef__r.IncotermsPick__c, AccountRef__r.PaymentTerms__c, AccountRef__r.RegionalManagerRef__r.Name, AccountRef__r.SalesDirectorRef__r.Name, /*AccountRef__r.SoldTo__r.Name, AccountRef__r.SoldTo__r.AccountSAPByDesignID__c, AccountRef__r.SoldTo__r.AccountSAPECCID__c,*/
                                        CaseRef__c, CaseRef__r.Subject, CaseRef__r.Type, CaseRef__r.Owner.email, CaseRef__r.Owner.name,CaseRef__r.Description, CaseRef__r.Priority, CaseRef__r.AccountId, CaseRef__r.Account.Name,CaseRef__r.Status, CaseRef__r.Product.Name, Owner.Email,
                                        OpportunityRef__c, OpportunityRef__r.Description, Summary__c, OpportunityRef__r.Summary__c, OpportunityRef__r.Opportunity_ID__c, AccountRef__r.Line_of_business__c
                                        FROM JiraTicket__c 
                                        WHERE id IN :listNewJiraTicket ]);
    }
}