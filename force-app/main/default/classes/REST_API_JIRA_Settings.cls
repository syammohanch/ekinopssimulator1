public with sharing class REST_API_JIRA_Settings {
    
    public class reporterName{
        public String name = '';
    }

    /*START Create FRT Body START*/
    public class FRT_Body{
        public FRT_fields fields = new FRT_fields();
    }    
    public class FRT_fields{
        public String summary = '';
        public String description = '';
        public String customfield_11625;// = 'Salesforce Case Identifier';
        public String customfield_11702 = 'Other';
        public String customfield_11605 = '';
        public String customfield_11703 = '';
        public String customfield_17702 = '';
        public FRT_project project = new FRT_project();
        public FRT_issuetype issuetype = new FRT_issuetype();
        public reporterName reporter = new reporterName();
    }
    public class FRT_project{
        public String key ='FRT';
    }
    public class FRT_issuetype{
        public String name ='Feature Request';
    }
    /*END Create FRT Body END*/
    
    /*START Create FRT Update Body START*/
    public class FRT_Update_Body{
        public FRT_Update_transition transition = new FRT_Update_transition();
        public FRT_Update_updateComment updateVar = new FRT_Update_updateComment();
    }  
    public class FRT_Update_transition{
        public String id;
    }
    public class FRT_Update_updateComment{
        public List<FRT_Update_commment> comment = new List<FRT_Update_commment>();
    }
    public class FRT_Update_commment{
    	public FRT_Update_commmentAdd add = new FRT_Update_commmentAdd();
    }
    public class FRT_Update_commmentAdd{
    	public String body;
    }
    /*END Create FRT Update Body END*/

    /*START Create PRT Body START*/
    public class PRT_Body{
        public PRT_fields fields = new PRT_fields();
    }    
    public class PRT_fields{
        public String summary;
        public PRT_reporter reporter = new PRT_reporter();
        public String customfield_13517;// = 'Salesforce Case Identifier';
        public String customfield_13508;
        public List<String> customfield_13562;
        public String customfield_15201;
        public String customfield_13529;
        public PRT_project project = new PRT_project();
        public PRT_issuetype issuetype = new PRT_issuetype();
        public List<PRT_components> components =  new List<PRT_components>();
        public PRT_priority priority = new PRT_priority();
    }
    public class PRT_project{
        public String key ='PRT';
    }
    public class PRT_reporter{
        public String name; //User name who is triggering the customer creation
    }
    public class PRT_issuetype{
        public String name ='Bug';
    }
    public class PRT_components{
        public String name;// ='PRT Feature Request';
    }
    public class PRT_priority{
        public String name;
    }
    /*END Create PRT Body END*/

    /*START Create SAP Body START*/
    /*START common SAP tag*/
    public class SAP_project{
        public String key ='SAP';
    }
    public class SAP_reporter{
        public String name; //User name who is triggering the customer creation
    }
    public class SAP_components{
        public String name = 'Creation Request';
    }
    public class SAP_priority{
        public String name = 'Routine';//"Very Urgent","Urgent","Routine","Not Urgent","On Hold","Not Assigned" -> Default value is “Routine”.
    }
    /*END common fixed SAP tag*/
    /*START Create SAP Account To Sold Body START*/
    public class SAP_Account_Sold_To_Body{
        public SAP_Account_Sold_To_fields fields = new SAP_Account_Sold_To_fields();
    }
    public class SAP_Account_Sold_To_fields{
        public SAP_project project = new SAP_project();
        public String summary;// = Concatenation: "Sold To Customer Creation Request: " + <Customer Name>;
        public SAP_reporter reporter = new SAP_reporter();
        public SAP_Account_Sold_To_issueType issuetype = new SAP_Account_Sold_To_issueType();
        public List<SAP_components> components =  new List<SAP_components>{new SAP_components()};
        public SAP_priority priority = new SAP_priority();
        public String customfield_13901;//Salesforce Id for Sold-To Customer
        public String customfield_16006;//Value is "Yes" If the Credit Application Form is uploaded, else "No"
        public String customfield_16008;//Value is "Yes" If the Customer Certificate of Registration is uploaded, else "No"
        public String customfield_16007;//Value is "Yes" If the Loan Credit Application Form Uploaded, else "No"
        public String description; //Account's fields concatenation

    }
    public class SAP_Account_Sold_To_issueType{
        public String name = 'Create: Sold-To Customer';
    }
    /*START Create SAP Account To Sold Body END*/  
    /*START Create SAP Other Account Body START*/
    public class SAP_Other_Account_Body{
        public SAP_Other_Account_fields fields = new SAP_Other_Account_fields();
    }
    public class SAP_Other_Account_fields{
        public SAP_project project = new SAP_project();
        public String summary;
        public SAP_reporter reporter = new SAP_reporter();//User name who is triggering the customer creation
        public SAP_Other_Account_issueType issuetype = new SAP_Other_Account_issueType();
        public List<SAP_components> components =  new List<SAP_components>{new SAP_components()};
        public SAP_priority priority = new SAP_priority();
        public String customfield_13901;//Salesforce Internal Id of the Customer
        public String description; //Account's fields concatenation
    }
    public class SAP_Other_Account_issueType{
        // Depends on the type: 
        //Final Customer => “Create: Final Customer” 
        //Bill To Customer => “Create: Bill-To Customer”
        //Shipped To Customer => “Create: Ship-To Customer”
        public String name; 

    }
    /*START Create SAP Other Account Body END*/

    /*START Create SAP Project Body START*/
    public class SAP_Project_Body{
        public SAP_Project_fields fields = new SAP_Project_fields();
    }
    public class SAP_Project_fields{
        public SAP_project project = new SAP_project();
        public String summary; //Concatenation: "Project Creation Request: " + <Opportunity Name>
        public SAP_reporter reporter = new SAP_reporter();
        public List<SAP_components> components =  new List<SAP_components>();
        public SAP_priority priority = new SAP_priority();
        public String customfield_13901;//Salesforce Id of opportunity
        public String description; //Opportunity's fields concatenation
    }
    public class SAP_Project_issueType{
        public String name = 'Create: Project'; 

    }
    /*START Create SAP Project Body END*/
    /*START Create SAP Body END*/
}