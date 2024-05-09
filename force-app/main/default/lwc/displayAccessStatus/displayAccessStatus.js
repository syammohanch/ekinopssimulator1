import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Case.Status','Case.Priority','Case.CaseNumber__c','Case.SLATypeAuto__c','Case.SLAbreachPick__c','Case.GlobalSLABreachPick__c'];
export default class DisplayAccessStatus extends LightningElement {
    @api recordId;
    case;
    status;
    casePriority;
    slaType;
    slaBreach;
    globalSLABreach;
    caseNumber
    classname;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.case = data;
            this.caseNumber = this.case.fields.CaseNumber__c.value;
            this.casePriority = this.case.fields.Priority.value;
            this.slaType = this.case.fields.SLATypeAuto__c.value;
            this.slaBreach = this.case.fields.SLAbreachPick__c.value;
            this.globalSLABreach = this.case.fields.GlobalSLABreachPick__c.value;
            this.status = this.case.fields.Status.value;
            if(this.status == "Workaround Provided"){
                this.classname = 'status_class_Workaround_Provided';
            }else if(this.status == "Request info"){
                this.classname = 'status_class_Request_info';
            }else if(this.status == "Test assigned"){
                this.classname = 'status_class_Test_assigned';
            }else if(this.status == "Test approved"){
                this.classname = 'status_class_Test_approved';
            }else if(this.status == "RD solved"){
                this.classname = 'status_class_RD_solved';
            }else if(this.status == "RD delivered"){
                this.classname = 'status_class_RD_delivered';
            }else if(this.status == "RD assigned"){
                this.classname = 'status_class_RD_assigned';
            }else if(this.status == "Workaround Accepted"){
                this.classname = 'status_class_Workaround_Accepted';
            }else{
                this.classname = 'status_class_'+this.status;
            }
            this.classname = this.classname+' status_block';
        }
    }
}