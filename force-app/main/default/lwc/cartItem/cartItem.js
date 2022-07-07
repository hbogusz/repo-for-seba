import { api, LightningElement,wire } from 'lwc';

import getProduct from '@salesforce/apex/InternalService.getProduct';


export default class CartItem extends LightningElement {
    @api
    itemId;
    @api
    item;
    wiredProductResult;
    product;
    subtotal;

    @wire(getProduct, { recordId: '$itemId' })
    wiredProduct(result) {
        this.wiredProductResult = result;
        if (result.data) {
            this.product = result.data;
            this.subtotal = this.product.unitPrice * this.item.quantity;
            console.log('product', result.data);
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
    setQuantity(event){
        this.item.quantity = event.target.value;
        this.subtotal  = this.product.unitPrice * this.item.quantity;
    }

    
        
    
}