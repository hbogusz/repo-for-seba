import { api, LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getProduct from '@salesforce/apex/InternalService.getProduct';
import getImages from '@salesforce/apex/ImageUploadHandler.getImages';
import getReviews from '@salesforce/apex/InternalService.getReviews';
import saveReview from '@salesforce/apex/InternalService.saveReview';
import addToCart from '@salesforce/apex/CartController.addProductToCart';

import { getRecord } from 'lightning/uiRecordApi';
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
    images;
    review = new Array();
    item = {productId: "", quantity: 1, flavour: "", price: 0.0};
    wiredReviewsResult;
    reviews;
    isLoading;
    showFlavour;
    @track
    isAddReviewDisabled;
    wiredUserResult

    @track error;
    @track name;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) 
    wireuser(result) {
        this.wiredUserResult = result;
        if (result.error) {
            this.error = result.error;
        } else if (result.data) {
            this.name = result.data.fields.Name.value;
            refreshApex(this.wiredReviewsResult);
        }
    }

    @wire(getProduct, { recordId: '$recordId' })
    wiredProduct(result) {
        this.wiredProductResult = result;
        if (result.data) {
            this.product = result.data;
            this.mainImage = this.product.image;
            this.mainImageId = this.mainImage.substring(this.mainImage.length - 19, this.mainImage.length - 1);
            if(this.product.family == "Vitamins" || this.product.family == "Equipment"){
                this.showFlavour = false;
                this.item.flavour = "-";
            } else {
                this.showFlavour = true;
            }
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
    @wire(getImages, { recordId: '$recordId' })
    wiredImages(result) {
        this.wiredImagesResult = result;
        if (result.data) {
            this.images = result.data;
        } else if (result.error) {
            console.log('data.error', result.error);
        }
    }
    @wire(getReviews, { productId: '$recordId' })
    wiredReviews(result) {
        this.wiredReviewsResult = result;
        if (result.data) {
            this.reviews = result.data;
            this.isAddReviewDisabled = false;
                this.reviews.forEach(review => {
                if(review.author == this.name){
                    this.isAddReviewDisabled = true;
                }
            });
            
        } else if (result.error) {
            this.reviews = null;
            console.log('data.error', result.error);
        }
    }

    connectedCallback() {
        this.item.quantity = 1;
    }
    changeImage(event) {
        this.mainImageId = event.target.dataset.id;
        this.mainImage = '/sfc/servlet.shepherd/document/download/' + this.mainImageId;
    }
    navigateCategory() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: this.product.family.toLowerCase()
            },
        });
    }

    showReviewForm() {
        this.isReviewFormShown = true;
    }
    closeReviewForm() {
        this.resetReview();
        this.isReviewFormShown = false;
    }
    handleSubmit() {
        if (this.review.rating == undefined) {
            const event = new ShowToastEvent({
                title: 'Error!',
                message: 'Select rating before saving!',
                variant: 'error'
            });
            this.dispatchEvent(event);
        } else {
            if (this.review.content == undefined || this.review.content == '') {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Content can\'t be empty!',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            } else {
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
        }
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
    resetReview() {
        this.review.content = '';
        this.review.rating = '';
    }
    setFlavour(event) {
        this.item.flavour = event.target.value;
    }
    setQuantity(event) {
        event.target.value = Math.round(event.target.value);
        this.item.quantity = event.target.value;
    }

    addToCart() {
        this.isLoading = true;
        this.item.productId = this.recordId;
        this.item.price = this.product.unitPrice;
        addToCart({price: this.item.price, productId: this.recordId, flavour: this.item.flavour, quantity: this.item.quantity })
            .then(() => {
                this.dispatchEvent(ShowToastEvent({
                    title: 'Success!',
                    message: 'Product added to cart!',
                    variant: 'success'
                })
                );
                this.isLoading = false;
            })
            .catch((error) => {
                console.error(error);
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Unexpected error has occured: ' + error.message,
                    variant: 'error'
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            });
    }
    scrollToReviews() {
        const reviewsCard = this.template.querySelector('[data-id="reviewsCard"]');
        reviewsCard.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
    }
}