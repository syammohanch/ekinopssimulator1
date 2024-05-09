import { LightningElement,api,track,wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import Objects_Type from "@salesforce/apex/CustomCommentFeederController.getAllowedAccessCaseStatus";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import createFeedItemRecJS from '@salesforce/apex/CustomCommentFeederController.createFeedItemRec';

//Case Update
import CASE_OBJECT from "@salesforce/schema/Case";
import ID_FIELD from "@salesforce/schema/Case.Id";
import STATUS_FIELD from "@salesforce/schema/Case.Status";
// Case Record Section
const FIELDS = ['Case.Status', 'Case.Subject','Case.OwnerId','Case.Owner.Name'];
// User Profile Section
import Id from '@salesforce/user/Id';
import Name from '@salesforce/schema/User.Name';
import RoleName from '@salesforce/schema/User.UserRole.Name';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import ManagerName from '@salesforce/schema/User.Manager.Name';


export default class CallChangeStatusFlow extends LightningElement {
    @api recordId;
    @track status;
    @track comments;
    @track returnOptionStatus = [];
    @track optionsapexdata;
    @track optionsapexerror;
    
    userId = Id;
    userName;
    userRoleName;
    userProfileName;
    userManagerName;
    // Case Record Section
    case;
    currentStatus;
    currentSubject;
    currentOwnerId;
    currentOwnerName;
    disabled = false;

    closeAction() {
        this.isModalOpen = false;
        this.dispatchEvent(new CloseActionScreenEvent({ bubbles: true,composed: true })); 
    }

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
                    title: 'Error loading Case',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.case = data;
            this.currentStatus = this.case.fields.Status.value;
            this.currentSubject = this.case.fields.Subject.value;
            this.currentOwnerId = this.case.fields.OwnerId.value;
            this.currentOwnerName = this.case.fields.Owner.displayValue;
        }
    }

    /* Status Picklist Options */
    @track l_All_Types;
    @track TypeOptions;
    @wire(Objects_Type, {profileId:'00e7Q000002E3FwQAK',currentStatus:"$currentStatus"})
    WiredObjects_Type({ error, data }) {
        console.log('INside Close 10');
        if (data) {
            try {
                this.l_All_Types = data; 
                let options = [];
                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: key, value: key  });
                    // Here Name and Id are fields from sObject list.
                }
                this.TypeOptions = options;
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
    }
    /* Status Picklist Options */


    @wire(getRecord, { recordId: Id, fields: [Name, RoleName, ProfileName, ManagerName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Name.value != null) {
                this.userName = data.fields.Name.value;
            }
            if (data.fields.UserRole.value != null) {
                this.userRoleName = data.fields.UserRole.value.fields.Name.value;
            }
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
            }
            if (data.fields.Manager.value != null) {
                this.userManagerName = data.fields.Manager.value.fields.Name.value;
            }
        }
    }
    
    get options() {
        if(this.currentStatus == "New"){
            return [
                { label: 'Assigned', value: 'Assigned' },
                { label: 'Resolved', value: 'Resolved' },
                { label: 'Delivered', value: 'Delivered' },
                { label: 'Closed', value: 'Closed' },
            ];
        }else if(this.currentStatus == "Assigned"){
            return [
                { label: 'Waiting customer feedback', value: 'Waiting customer feedback' },
                { label: 'Confirmed', value: 'Confirmed' },
                { label: 'Delivered', value: 'Delivered' },
                { label: 'Closed', value: 'Closed' },
                { label: 'Resolved', value: 'Resolved' },
            ];
        }
    }

    handleStatusChange(event){
        this.status = event.target.value;
    }
    handleCommentChange(event){
        this.comments = event.target.value;
    }

    handleSaveFeed(event){
        console.log('Inside Handle Save Feed');
        //console.log('Parent Id : '+this.recordId);
        //console.log('Comments : '+this.comments);
        //const fields = {};
        //mapFeedItem.put(this.recordId);
        //fields[FEEDITEMPARENTID_FIELD.fieldApiName] = this.recordId;
        //fields[FEEDITEMBODY_FIELD.fieldApiName] = this.comments;
        //createFeedItemRecJS({parentId:this.recordId,comments:this.comments});
    }

    isInputValid(){
        console.log('Inside isInputValid');
        let isValid = true;
        let caseInputField = this.template.querySelector(".validatestatus");
        console.log('Status 1 is : '+this.status)
        console.log('Status 2 is : '+caseInputField.value);
        if(caseInputField.value === ""){
            isValid = false;
            caseInputField.setCustomValidity('Please choose Status!');
        }else{
            caseInputField.setCustomValidity('');
        }
        caseInputField.reportValidity();
        let commentsInputField = this.template.querySelector(".validatecomments");
        
        console.log('Comments is : '+commentsInputField.value);
        if(caseInputField.value == "Waiting customer feedback" && (commentsInputField.value == "" || commentsInputField.value == undefined) ){
            console.log('Inside If');
            isValid = false;
            this.template.querySelector('.elementHoldingHTMLContent').innerHTML = 'Please enter comments';
            caseInputField.setCustomValidity('Please choose Status!');
        }else{
            console.log('Inside Else');
            this.template.querySelector('.elementHoldingHTMLContent').innerHTML = '';
        }

        if(this.currentOwnerName == 'Access Case' && (this.status == 'Assigned' || this.status == 'Delivered' || this.status == 'Resolved' || this.status == 'Closed') && this.currentStatus == 'New'){
            isValid = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error",
                    message: "Please assign the case to a CSO before changing the case status to Assigned.",
                    variant: "error",
                    mode: "sticky"
                })
            );
        }
        
        return isValid;
    }

    handleSave(event){
        console.log('Inside Save 123');
        if(this.isInputValid()){
            this.disabled = true;
            console.log('Inside Valid');
            
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[STATUS_FIELD.fieldApiName] = this.status;
            let successMsgType = 'Success!!';
            let successMsgMessage = 'Case Updated successfully!.';
            let successMsgVariant = 'success';
            let successMsgMode = 'dismissable'; 
            if(this.status == 'Resolved' || this.status == 'Delivered'){
                successMsgMessage = successMsgMessage+'You have just Resolved or Delivered this case. Please check the Fix Software Version and update it if required';
            }
            const recordInput = { fields };
            console.log(recordInput);
            updateRecord(recordInput)
                .then(() => {
                       
                    //this.showToast('Success!!', 'Case updated successfully!!', 'success', 'dismissable');
                    this.showToast(successMsgType, successMsgMessage, successMsgVariant, successMsgMode);
                    // Display fresh data in the form
                    this.showLoading = false;
                    this.disabled = false;
                    this.closeAction(event);
                    createFeedItemRecJS({parentId:this.recordId,comments:this.comments});
                    return refreshApex(this.case);
                })
                .catch(error => {
                    this.showLoading = false;
                    this.showToast('Error!!', error.body.message, 'error', 'dismissable');
                });
                
        }else{
            console.log('Inside Not Valid');
        }
    }

    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    /*handleSave(event){
        console.log('Inside handleSave');
        
        
        if(this.isInputValid()){
            console.log('Inside handleSave True');
            this.disabled = true;
            let successMessageForResolvedOrDelivered = ''; 
            //createFeedItemRecJS({parentId:this.recordId,comments:this.comments});
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[STATUS_FIELD.fieldApiName] = this.status;
            console.log('Inside handleSave True : '+fields);
            if(this.status == 'Resolved' || this.status == 'Delivered'){
                this.successMessageForResolvedOrDelivered = 'You have just Resolved or Delivered this case. Please check the Fix Software Version and update it if required';
            }else{
                this.successMessageForResolvedOrDelivered = '';
            }
            console.log('Inside handleSave True : '+JSON.stringify(fields));
            const recordInput = { fields: fields };
            System.debug('recordInput : '+JSON.stringify(recordInput));
            updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                new ShowToastEvent({
                    title: "Success",
                    message: "Case updated."+this.successMessageForResolvedOrDelivered,
                    variant: "success",
                }),
                );
                this.disabled = false;
                this.closeAction(event);
                return refreshApex(this.case);
                // Display fresh data in the form
                
            })
            .catch((error) => {
                this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error updtaing Case record",
                    message: error.body.message+' : '+JSON.stringify(error),
                    variant: "error",
                }),
                );
            });
        }
    }*/
}