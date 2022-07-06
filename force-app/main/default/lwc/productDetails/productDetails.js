import { api, LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getProduct from '@salesforce/apex/InternalService.getProduct';
import getImages from '@salesforce/apex/ImageUploadHandler.getImages';
import getReviews from '@salesforce/apex/InternalService.getReviews';
import saveReview from '@salesforce/apex/InternalService.saveReview';

import {getRecord} from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex } from '@salesforce/apex';

 
export default class ProductDetails extends NavigationMixin(LightningElement) {
    @api
    recordId;
    wiredProductResult;
    product;
    wiredImagesResult;
    mainImage;
    mainImageId;
    isReviewFormShown;
    review = new Array();
    wiredReviewsResult;
    reviews;
    isLoading;

    @track error;
    @track name;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.name = data.fields.Name.value;
        console.log('username', this.username);

        }
    }

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
    @wire(getReviews, { productId: '$recordId' })
    wiredReviews(result) {
        this.wiredReviewsResult = result;
        // this.isLoading = true;
        if (result.data) {
            this.reviews = result.data;
            console.log('reviews: ', result.data);
        } else if (result.error) {
            this.reviews = null;
            console.log('data.error')
            console.log(result.error)
        }
    }

    connectedCallback(){
        console.log('recordId', this.recordId);
    }
    changeImage(event){
        this.mainImageId = event.target.dataset.id;
        this.mainImage = '/sfc/servlet.shepherd/document/download/' + this.mainImageId;
    }
    navigateCategory(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: this.product.family.toLowerCase()
            },
        });
    }

    showReviewForm() {
        // this.isLoading = true;
        this.isReviewFormShown = true;
        // this.isLoading = false;
    }
    closeReviewForm() {
        // this.isLoading = true;
        this.resetReview();
        this.isReviewFormShown = false;
        // this.isLoading = false;
    }
    handleSubmit() {
        this.isLoading = true;
        saveReview({ author: this.name, content: this.review.content, productId: this.recordId, rating: this.review.rating })
            .then((result) => {
                this.result = result;
                this.error = undefined;
                this.isReviewFormShown = false;
                this.dispatchEvent(ShowToastEvent({
                    title: 'Success!',
                    message: 'Review created!',
                    variant: 'success'
                })
                );
                this.resetReview();
                refreshApex(this.wiredReviewsResult);
                refreshApex(this.wiredProductResult);
                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.result = undefined;
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Unexpected error has occured!',
                    variant: 'error'
                });
                this.dispatchEvent(event);
                console.log('error', error);
                this.isLoading = false;
            });
    }

    handleRating(event) {
        this.review.rating = event.detail;
    }
    setAuthor(event) {
        this.review.author = event.target.value;
    }
    setContent(event) {
        this.review.content = event.target.value;
    }
    resetReview(){
        this.review.content = '';
        this.review.rating = '';
    }

}