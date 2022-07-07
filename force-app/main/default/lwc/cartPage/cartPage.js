import { LightningElement,wire } from 'lwc';

import getItemsFromCart from '@salesforce/apex/CartController.getItemsFromCart';


export default class CartPage extends LightningElement {
    wiredItemsResult;
    items;
    noResults;

    @wire(getItemsFromCart)
    wiredProducts(result) {
        this.wiredItemsResult = result;
        if (result.data) {
            this.items = JSON.parse(result.data);
            if(this.items.length == 0){
                this.noResults = true;
            } else {
                this.noResults = false;
            }
            console.log('success',JSON.parse(result.data));
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
    connectedCallback(){
        var text = sessionStorage.getItem('items');
        var obj = JSON.parse(text);
        console.log('items', obj);
    }
}