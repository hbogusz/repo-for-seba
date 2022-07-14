import { LightningElement,wire } from 'lwc';

import getComplaints from '@salesforce/apex/InternalService.getComplaints';
import getComplaintId from '@salesforce/apex/InternalService.getComplaintId';


export default class Complaints extends LightningElement {
    wiredComplaintsResult;
    complaints;
    activeComplaint='';
    activeComplaintResult;


    @wire(getComplaints)
    wiredComplaints(result) {
        this.wiredComplaintsResult = result;
        if (result.data) {
            this.complaints = result.data;
            console.log('complaints', this.complaints);

        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }    
    @wire(getComplaintId)
    wiredComplaintId(result) {
        this.activeComplaintResult = result;
        if (result.data) {
            this.activeComplaint = result.data;
            console.log('complaintId', this.activeComplaint);

        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
}