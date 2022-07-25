import { LightningElement, track, wire } from 'lwc';

import getItemsFromCart from '@salesforce/apex/CartController.getItemsFromCart';
import emptyCart from '@salesforce/apex/CartController.clearCart';
import createOrder from '@salesforce/apex/CartController.createOrder';
import checkDiscountCode from '@salesforce/apex/CartController.checkDiscountCode';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class CartPage extends LightningElement {
    wiredItemsResult;
    items;
    noResults;
    isLoading = false;
    totalPrice = 0;
    totalPriceWithDiscount = 0;
    discountCode;
    noDiscount = true;
    discount = 0;
    @track
    codes = [];
    codesMap = new Map();

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
        refreshApex(this.wiredItemsResult).then(() => {
            if (this.discount > 0) {
                this.getTotalPriceWithDiscount();
            }
        });

    }
    makeOrder() {
        this.isLoading = true;
        createOrder({ discount: this.discount })
            .then(() => {
                this.dispatchEvent(ShowToastEvent({
                    title: 'Success!',
                    message: 'Order placed succesfully!',
                    variant: 'success'
                })
                );
                emptyCart()
                    .then(() => {
                        this.isLoading = false;
                        location.href = '/Community/s/orders';
                    })
                    .catch((error) => {
                        console.error(error);
                        this.isLoading = false;
                    });

            })
            .catch((error) => {
                console.error(error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Unexpected error has occured: ' + error,
                    variant: 'error'
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            });
    }
    setDiscount(event) {
        this.discountCode = event.target.value;
    }
    useDiscountCode() {
        this.isLoading = true;
        if (this.codesMap.has(this.discountCode)) {
            this.dispatchEvent(ShowToastEvent({
                title: 'Error!',
                message: 'This code is already in use!',
                variant: 'error'
            })
            );
            this.isLoading = false;
        } else {
            checkDiscountCode({ discountCode: this.discountCode })
                .then((result) => {
                    if (result > 0) {
                        this.dispatchEvent(ShowToastEvent({
                            title: 'Success!',
                            message: 'Discount code is correct!',
                            variant: 'success'
                        })
                        );
                        this.noDiscount = false;
                        this.discount = result;
                        this.items.forEach(item => {
                            this.totalPriceWithDiscount += ((100 - this.discount) / 100 * item.price).toFixed(2) * item.quantity;
                        });
                        this.codesMap.set(this.discountCode, this.discount);
                        this.codes.push({ value: this.discount, key: this.discountCode });
                    } else {
                        const event = new ShowToastEvent({
                            title: 'Error!',
                            message: 'Provided discount code is incorrect. Check spelling',
                            variant: 'error'
                        });
                        this.dispatchEvent(event);
                        this.noDiscount = true;
                    }
                    this.isLoading = false;
                })
                .catch((error) => {
                    console.error(error);
                    const event = new ShowToastEvent({
                        title: 'Error!',
                        message: 'Unexpected error: ' + error,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                    this.isLoading = false;
                });
        }
    }
    getTotalPriceWithDiscount() {
        this.totalPriceWithDiscount = 0;
        this.items.forEach(item => {
            this.totalPriceWithDiscount += ((100 - this.discount) / 100 * item.price).toFixed(2) * item.quantity;
        });
    }
}