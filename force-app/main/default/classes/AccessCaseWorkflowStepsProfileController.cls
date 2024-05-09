public class AccessCaseWorkflowStepsProfileController {
    public AccessCaseWorkflowStepsProfileController(ApexPages.StandardController controller)
    {
        
    }
   	public List<SelectOption> getProfileOptions() {
        List<SelectOption> profileOptions = new List<SelectOption>();
        for (Profile profile : [SELECT Id, Name FROM Profile]) {
            profileOptions.add(new SelectOption(profile.Id, profile.Name));
        }
        System.debug('profileOptions : '+profileOptions);
        return profileOptions;
    }
}