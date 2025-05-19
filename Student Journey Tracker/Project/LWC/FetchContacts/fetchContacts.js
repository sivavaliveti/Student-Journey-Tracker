import { LightningElement, wire } from 'lwc';
import runBatchJob from '@salesforce/apex/BatchFetchContacts.runBatchJob';
import getContacts from '@salesforce/apex/BatchFetchContacts.getContacts';
import { refreshApex } from '@salesforce/apex';

export default class BatchContactDisplay extends LightningElement {
    contacts;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Account Name', fieldName: 'Account.Name' }
    ];

    @wire(getContacts)
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
    }

    handleRunBatch() {
        runBatchJob()
            .then(() => refreshApex(this.wiredContacts))
            .catch(error => console.error('Error running batch:', error));
    }
}