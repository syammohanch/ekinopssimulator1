@isTest
public class AccessCaseWorkflowStepsProfileTest {
	@isTest static void testGetProfileOptions(){
        Contact t = new contact (lastname='Test Contact');
        insert t;
        Apexpages.StandardController stdController = new Apexpages.StandardController(t);
        AccessCaseWorkflowStepsProfileController obj = new AccessCaseWorkflowStepsProfileController(StdController);
        obj.getProfileOptions();
    }
}