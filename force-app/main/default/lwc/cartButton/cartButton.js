import { LightningElement,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CartButton extends NavigationMixin(LightningElement) {
    navigateToCart() {
        console.log('navigate');
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: "cart"
            }
        });
    }
}