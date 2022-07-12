import { api, LightningElement, track, wire } from 'lwc';

import getOrderItems from '@salesforce/apex/InternalService.getOrderItemsforOrder';
import saveCase from '@salesforce/apex/InternalService.saveCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class OrderItem extends LightningElement {
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
                        console.log('result', result);
                        this.dispatchEvent(ShowToastEvent({
                            title: 'Success!',
                            message: 'Complaint sent!',
                            variant: 'success'
                        })
                        );
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
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }

}