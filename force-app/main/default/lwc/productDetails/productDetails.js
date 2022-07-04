import { api, LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getProduct from '@salesforce/apex/InternalService.getProduct';
import getImages from '@salesforce/apex/ImageUploadHandler.getImages';


export default class ProductDetails extends NavigationMixin(LightningElement) {
    @api
    recordId;
    wiredProductResult;
    product;
    wiredImagesResult;
    mainImage;
    mainImageId;

    @wire(getProduct, {recordId: '$recordId'})
    wiredProduct(result) {
        this.wiredProductResult = result;
        if (result.data) {
            this.product = result.data;
            this.mainImage = this.product.image;
            this.mainImageId = this.mainImage.substring(this.mainImage.length - 19, this.mainImage.length - 1);
            console.log('success', result.data);
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
    @wire(getImages, {recordId: '$recordId'})
    wiredImages(result) {
        this.wiredImagesResult = result;
        if (result.data) {
            this.images = result.data;
            console.log('images', result.data);
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
    connectedCallback(){
        console.log('recordId', this.recordId);
    }
    changeImage(event){
        this.mainImageId = event.target.dataset.id;
        this.mainImage = '/sfc/servlet.shepherd/document/download/' + this.mainImageId;
    }

}