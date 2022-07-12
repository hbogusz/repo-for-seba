import { LightningElement,wire } from 'lwc';

import getComplaints from '@salesforce/apex/InternalService.getComplaints';


export default class Complaints extends LightningElement {
    wiredComplaintsResult;
    complaints;

    @wire(getComplaints)
    wiredComplaints(result) {
        this.wiredComplaintsResult = result;
        if (result.data) {
            this.complaints = result.data;
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
}