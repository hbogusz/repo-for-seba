import { api, LightningElement } from 'lwc';
export default class ProductTile extends LightningElement {
    @api
    product;
        
    navigate(){
        this.recordIdPageUrl = '/Community/s/product/' + this.product.productName + '/' + this.product.productId;
        location.href = this.recordIdPageUrl;
    }
    
}