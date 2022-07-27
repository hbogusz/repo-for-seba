import { api, LightningElement, track, wire } from 'lwc';

import getOrderItems from '@salesforce/apex/InternalService.getOrderItemsforOrder';
import saveCase from '@salesforce/apex/InternalService.saveCase';
import saveComplaintId from '@salesforce/apex/InternalService.saveComplaintId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

export default class OrderItem extends NavigationMixin(LightningElement) {
    @api
    orderId
    @api
    order;
    wiredItemsResult;
    items;
    totalPrice = 0;
    complaint = {subject: "", reason: "", description: ""};
    @track
    isModalOpen;
    itemId;
    itemName;
    isLoading;


    @wire(getOrderItems, { orderId: '$orderId' })
    wiredItems(result) {
        this.wiredItemsResult = result;
        if (result.data) {
            this.totalPrice = 0;
            this.items = result.data;
            this.items.forEach(item => {
                this.totalPrice += item.quantity * item.unitPrice;
            });
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }

    submitComplaint() {
        if (this.complaint.subject == undefined || this.complaint.subject == '' || this.complaint.reason == undefined || 
        this.complaint.reason == '' || this.complaint.description == undefined || this.complaint.description == '') {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Fill out all fields!',
                variant: 'error'
            });
            this.dispatchEvent(event);
        } else {
                this.isLoading = true;
                saveCase({ subject: this.complaint.subject, reason: this.complaint.reason, description: this.complaint.description, productId: this.itemId})
                    .then((result) => {
                        this.dispatchEvent(ShowToastEvent({
                            title: 'Success!',
                            message: 'Complaint sent!',
                            variant: 'success'
                        })
                        );
                        refreshApex(this.wiredItemsResult);
                        this.closeModal();
                        this.resetComplaint();
                        this.isLoading = false;
                    })
                    .catch((error) => {
                        const event = new ShowToastEvent({
                            title: 'Error!',
                            message: 'Unexpected error has occured!',
                            variant: 'error'
                        });
                        this.dispatchEvent(event);
                        console.log('error', error);
                        this.isLoading = false;
                    });
        }
    }

    get status() {
        if (this.order.Status == 'Draft') {
            return 'In progress';
        } else {
            return 'Completed';
        }

    }
    setSubject(event) {
        this.complaint.subject = event.target.value;
    }
    setReason(event) {
        this.complaint.reason = event.target.value;
    }
    setDescription(event) {
        this.complaint.description = event.target.value;
    }
    resetComplaint() {
        this.complaint.subject = '';
        this.complaint.reason = '';
        this.complaint.description = '';
    }
    openModal(event) {
        this.itemId = event.target.dataset.recordId;
        this.itemName = event.target.dataset.productName;
        this.isModalOpen = true;
        this.isLoading = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }
    navigateToComplaints(event) {
        this.itemId = event.target.dataset.recordId;
        saveComplaintId({ complaintId: this.itemId})
        .then((result) => {
           this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'complaints'
            },
        });
        })
        .catch((error) => {
            console.log('error', error);
        });
    }
    disableSpinner() {
        this.isLoading = false;
    }
    

}