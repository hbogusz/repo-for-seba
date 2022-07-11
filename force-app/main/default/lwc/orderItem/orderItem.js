import { api, LightningElement,wire } from 'lwc';

import getOrderItems from '@salesforce/apex/InternalService.getOrderItemsforOrder';


export default class OrderItem extends LightningElement {
    @api
    orderId
    @api
    order;
    wiredItemsResult;
    items;
    totalPrice=0;

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

    get status(){
        if(this.order.Status == 'Draft'){
            return 'In progress';
        } else {
            return 'Completed';
        }
        
    }

}