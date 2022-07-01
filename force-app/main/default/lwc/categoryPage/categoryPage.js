import { LightningElement,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import searchProductsByCategory from '@salesforce/apex/InternalService.searchProductsByCategory';

export default class CategoryPage extends LightningElement {
    category;
    currentPageReference = null; 
    urlStateParameters;
    products;
    wiredProductsResult;
    productAmount;


    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.currentPageReference = currentPageReference;
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.actorId = this.currentPageReference.state.c__recordId;
       }
    }

    @wire(searchProductsByCategory, {category: '$category'})
    wiredProducts(result) {
        this.wiredProductsResult = result;
        if (result.data) {
            this.products = result.data;
            this.productAmount = this.products.length;
            console.log(this.resultsSize);
            console.log('success', result.data);
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }

    connectedCallback(){
        var name = '';
        name = this.currentPageReference.attributes.name;
        this.category = name.slice(0,name.length-3);
        if(this.category == "PreWorkout"){
            this.category = "Pre-Workout";
        }
    }



}