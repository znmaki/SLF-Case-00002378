import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_F_FIELD from '@salesforce/schema/Contact.FirstName';
import NAME_L_FIELD from '@salesforce/schema/Contact.LastName';
import COMPANY_FIELD from '@salesforce/schema/Contact.Company_Name__c';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import DESCRIPTION_FIELD from '@salesforce/schema/Contact.Description';

export default class FormContactCreate extends LightningElement {
    /* fields = [NAME_F_FIELD, NAME_L_FIELD, COMPANY_FIELD, PHONE_FIELD, EMAIL_FIELD, DESCRIPTION_FIELD];

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Account created",
            message: "Record Account ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    } */
    objectApiName = CONTACT_OBJECT
    firstName = NAME_F_FIELD;
    lastName = NAME_L_FIELD;
    companyName = COMPANY_FIELD;
    phone = PHONE_FIELD;
    email = EMAIL_FIELD;
    description = DESCRIPTION_FIELD;

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Account created",
            message: "Record Account ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}