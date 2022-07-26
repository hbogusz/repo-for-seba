import { LightningElement,wire } from 'lwc';

import getOrders from '@salesforce/apex/InternalService.getOrders';

export default class Orders extends LightningElement {
    wiredOrdersResult;
    orders;

    @wire(getOrders)
    wiredOrders(result) {
        this.wiredOrdersResult = result;
        if (result.data) {
            this.orders = result.data;
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
}