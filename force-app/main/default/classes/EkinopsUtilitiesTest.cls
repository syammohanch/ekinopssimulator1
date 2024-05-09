@isTest
public class EkinopsUtilitiesTest {
    @isTest static void verifyComposeMailNoRerouting() {
        
        String mailBody    = 'Test Mail Body';
        String mailSubject = 'Test Mail Subject';
        List<String> emailAddressesList    = new List<String>();
        List<String> ccAddressesList       = new List<String>();
        List<String> bccAddressesList      = new List<String>();
        
        emailAddressesList.add('test@ekinops.com');
        ccAddressesList.add('testCC@ekinops.com');
        bccAddressesList.add('testBCC@ekinops.com');
        
        EkinopsUtilitiesTest.setMetaData('SELECT Is_Rerouting_Enabled__c, Rerouting_Email_Address__c FROM Ekinops_Mail_Settings__mdt',
                                         (List<Ekinops_Mail_Settings__mdt>) JSON.deserialize('[{"Is_Rerouting_Enabled__c":false,"Rerouting_Email_Address__c":"test@ekinops.com","Org_Name__c":"[Test]"}]',List<Ekinops_Mail_Settings__mdt>.class));
        Test.StartTest(); 
        EkinopsUtilities.composeMail(emailAddressesList,ccAddressesList, bccAddressesList, mailSubject, mailBody);
        Test.StopTest();
    }
    @isTest static void verifyComposeMailRerouting() {
        
        String mailBody    = 'Test Mail Body';
        String mailSubject = 'Test Mail Subject';
        List<String> emailAddressesList    = new List<String>();
        List<String> ccAddressesList       = new List<String>();
        List<String> bccAddressesList      = new List<String>();
        
        emailAddressesList.add('test@ekinops.com');
        ccAddressesList.add('testCC@ekinops.com');
        bccAddressesList.add('testBCC@ekinops.com');
        
        EkinopsUtilitiesTest.setMetaData('SELECT Is_Rerouting_Enabled__c, Rerouting_Email_Address__c FROM Ekinops_Mail_Settings__mdt',
                                         (List<Ekinops_Mail_Settings__mdt>) JSON.deserialize('[{"Is_Rerouting_Enabled__c":true,"Rerouting_Email_Address__c":"test@ekinops.com"}]',List<Ekinops_Mail_Settings__mdt>.class));
        Test.StartTest(); 
        EkinopsUtilities.composeMail(emailAddressesList,ccAddressesList, bccAddressesList, mailSubject, mailBody);
        Test.StopTest();
    }
    
    public static void setMetaData(String query, List<SObject> records)
    {
        EkinopsUtilities.customMetaDataRecordsMap.put(query,records);
    }
    @isTest static void verifyIsValidEmail() {
        Test.StartTest();
        EkinopsUtilities.isValidEmail('test@test.com');
        EkinopsUtilities.isValidEmail('test@');
        EkinopsUtilities.isValidEmail('');
        Test.StopTest();   
    }
}