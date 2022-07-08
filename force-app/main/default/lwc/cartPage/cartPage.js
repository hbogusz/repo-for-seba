import { LightningElement, wire } from 'lwc';

import getItemsFromCart from '@salesforce/apex/CartController.getItemsFromCart';
import emptyCart from '@salesforce/apex/CartController.clearCart';
import { refreshApex } from '@salesforce/apex';


export default class CartPage extends LightningElement {
    wiredItemsResult;
    items;
    noResults;
    isLoading = false;
    totalPrice = 0;

    @wire(getItemsFromCart)
    wiredProducts(result) {
        this.wiredItemsResult = result;
        if (result.data) {
            this.items = JSON.parse(result.data);
            this.totalPrice = 0;
            if (this.items.length == 0) {
                this.noResults = true;
            } else {
                this.noResults = false;
            }
            this.items.forEach(item => {
                this.totalPrice += item.price * item.quantity;
            });
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
    clearCart() {
        this.isLoading = true;
        emptyCart()
            .then(() => {
                refreshApex(this.wiredItemsResult);
                this.isLoading = false;
            })
            .catch((error) => {
                console.error(error);
                this.isLoading = false;
            });
    }
    refreshCart() {
        refreshApex(this.wiredItemsResult);
    }

}