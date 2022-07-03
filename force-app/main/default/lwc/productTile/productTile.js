import { api, LightningElement } from 'lwc';
export default class ProductTile extends LightningElement {
    @api
    product;
        
    navigate(){
    //   this[NavigationMixin.Navigate]({
    //     type: 'standard__recordPage',
    //     attributes: {
    //         recordId: this.product.productId,
    //         objectApiName: Product2,
    //         actionName: 'view'
    //     },
    // });
        this.recordIdPageUrl = '/Community/s/product/' + this.product.productName + '/' + this.product.productId;
        location.href = this.recordIdPageUrl;
    }
    
}