import { api, LightningElement,track,wire } from 'lwc';

import getProduct from '@salesforce/apex/InternalService.getProduct';
import deleteItemFromCart from '@salesforce/apex/CartController.deleteItemFromCart';
import changeQuantity from '@salesforce/apex/CartController.changeQuantity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CartItem extends LightningElement {
    @api
    itemId;
    @api
    item;
    wiredProductResult;
    product;
    @track
    subtotal;

    @wire(getProduct, { recordId: '$itemId' })
    wiredProduct(result) {
        this.wiredProductResult = result;
        if (result.data) {
            this.product = result.data;
            this.subtotal = this.product.unitPrice * this.item.quantity;
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
    setQuantity(event){
        changeQuantity({productId: this.itemId, quantity: event.target.value })
            .then(() => {
                const refreshCart = new CustomEvent('refreshcart');
                this.dispatchEvent(refreshCart);
            })
            .catch((error) => {
                console.error(error);
            });
    }
    deleteFromCart() {
        deleteItemFromCart({productId: this.itemId })
            .then(() => {
                this.dispatchEvent(ShowToastEvent({
                    title: 'Success!',
                    message: 'Product removed from cart!',
                    variant: 'success'
                })
                );
                const refreshCart = new CustomEvent('refreshcart');
                this.dispatchEvent(refreshCart);
            })
            .catch((error) => {
                console.error(error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Unexpected error has occured: ' + error,
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });
            
    }
    
        
    
}