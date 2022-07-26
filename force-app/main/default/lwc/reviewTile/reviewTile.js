import { api, LightningElement } from 'lwc';

import emptyAvatar from '@salesforce/resourceUrl/dzikAvatar';

export default class ReviewTile extends LightningElement {
    @api
    review;

    get rating(){
        return parseInt(this.review.rating);
    }
     get avatarPath() {
             return emptyAvatar;  
     }
}