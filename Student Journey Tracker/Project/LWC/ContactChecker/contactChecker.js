// contactChecker.js
import { LightningElement, track } from 'lwc';

import isContactPresent from '@salesforce/apex/GetAllUsersController.isContactPresent';

export default class ContactChecker extends LightningElement {
    @track name = '';
    @track email = '';
    @track result = '';
    @track error;

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    checkContact() {
        isContactPresent({ name: this.name, email: this.email })
            .then(response => {
                this.result = response 
                    ? '✅ Contact found!' 
                    : '❌ Contact not found.';
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.result = '⚠️ Error occurred.';
            });
    }
}