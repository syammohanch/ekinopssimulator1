/**
 * @description ApprovalProcessManager class handles the approval or rejection of multiple requests simultaneously.
 */
global without sharing class ApprovalProcessManager {

    /**
     * @description Invocable method to approve or reject multiple requests.
     * @param inputList List of Inputs containing request information.
     * @return List of result strings indicating success or failure of each request.
     */
    @InvocableMethod
    public static List<String> approveOrRejectAll(List<Inputs> inputList) {
        Map<Id, List<Id>> mapProcessInstanceWorkitem = new Map<Id, List<Id>>();
        List<String> listResultString = new List<String>();

        Map<String, Inputs> mapInputs = new Map<String, Inputs>();
        Set<Id> reqIds = new Set<Id>();

        for (Inputs input : inputList) {
            mapInputs.put(input.requestId, input);
            reqIds.add(input.requestId);
        }

        Map<Id, ProcessInstance> mapProcessInstance = getProcessInstances(reqIds);
        mapProcessInstanceWorkitem = getProcessInstanceWorkitems(mapProcessInstance.values());//keySet());

        for (String id : reqIds) {
            processApprovalRequests(id, mapInputs, mapProcessInstance, mapProcessInstanceWorkitem, listResultString);
        }
        return listResultString;
    }

    private static Map<Id, ProcessInstance> getProcessInstances(Set<Id> reqIds) {
        Map<Id, ProcessInstance> mapProcessInstance = new Map<Id, ProcessInstance>();
        for (ProcessInstance pi : [SELECT TargetObjectId, Id FROM ProcessInstance WHERE Status = 'Pending' AND TargetObjectId IN :reqIds WITH USER_MODE]) {
            mapProcessInstance.put(pi.TargetObjectId, pi);
        }
        return mapProcessInstance;
    }

    private static Map<Id, List<Id>> getProcessInstanceWorkitems(List<ProcessInstance> targetObjectIds) {
        Map<Id, List<Id>> mapProcessInstanceWorkitem = new Map<Id, List<Id>>();
        for (ProcessInstanceWorkitem piw : [SELECT ProcessInstanceId, Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId IN :targetObjectIds WITH USER_MODE]) {
            if (mapProcessInstanceWorkitem.containsKey(piw.ProcessInstanceId)) {
                mapProcessInstanceWorkitem.get(piw.ProcessInstanceId).add(piw.Id);
            } else {
                mapProcessInstanceWorkitem.put(piw.ProcessInstanceId, new List<Id>{piw.Id});
            }
        }
        return mapProcessInstanceWorkitem;
    }

    private static void processApprovalRequests(String requestId, Map<String, Inputs> mapInputs, Map<Id, ProcessInstance> mapProcessInstance, Map<Id, List<Id>> mapProcessInstanceWorkitem, List<String> listResultString) {
        Inputs currentInputs = mapInputs.get(requestId);
        String choice = currentInputs.choice;
        String comment = currentInputs.comment;
        ProcessInstance pInstance = mapProcessInstance.get(currentInputs.requestId);

        List<Id> listWorkItemIds = mapProcessInstanceWorkitem.get(pInstance.Id);
        Approval.ProcessResult processResult;

        do {
            for (Id workItemId : listWorkItemIds) {
                processResult = processApprovalRequest(choice, comment, workItemId);
                if (!processResult.isSuccess()) {
                    for (Database.Error err : processResult.getErrors()) {
                        listResultString.add(err.getMessage());
                    }
                }
            }
            listWorkItemIds = processResult != null ? processResult.getNewWorkitemIds() : new List<Id>();
        } while (processResult != null && processResult.getInstanceStatus() == 'Pending' && processResult.isSuccess() && !listWorkItemIds.isEmpty());
    }

    private static Approval.ProcessResult processApprovalRequest(String choice, String comment, Id workItemId) {
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comment);
        req2.setAction(choice); // to approve use 'Approve'
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req2.setWorkitemId(workItemId);
        return Approval.process(req2);
    }

    /**
     * @description Inner class to hold inputs for the approval process.
     */
    global class Inputs {
        @InvocableVariable(label='Request record id' required=true)
        global String requestId;

        @InvocableVariable(label='Approve or Reject' required=true)
        global String choice;

        @InvocableVariable(label='Comment' required=true)
        global String comment;
    }
}