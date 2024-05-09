import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import userAccountField from '@salesforce/schema/User.AccountId';
import Id from '@salesforce/user/Id';

export default class ExperienceAccountWelcomeMessage extends LightningElement {
    @api isForcedTheme;
    accountId;
    error;
    @wire(getRecord, { recordId: Id, fields: [userAccountField]})
    currentUserInfo({error, data}) {
        if (data) {
            this.accountId = data.fields.AccountId.value;
        } else if (error) {
            this.error = error ;
        }
    }

    get fieldClass() {
        return this.isForcedTheme ? 'force-theme' : '';
    }
}