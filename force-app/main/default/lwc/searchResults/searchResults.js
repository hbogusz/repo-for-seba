import { api,LightningElement,wire } from 'lwc';

import searchProducts from '@salesforce/apex/InternalService.searchProducts';

export default class SearchResults extends LightningElement {
    @api
    term;
    searchedProducts;
    wiredSearchResult;
    noResults=false;
    resultsSize=0;

    connectedCallback() {
        console.log('initial');
        console.log('term:', this.term);
    }

    @wire(searchProducts, {searchTerm: '$term'})
    wiredProducts(result) {
        this.wiredSearchResult = result;
        if (result.data) {
            this.searchedProducts = result.data;
            this.resultsSize = this.searchedProducts.length;
            console.log(this.resultsSize);
            if(this.resultsSize == 0){
                this.noResults = true;
            } else {
                this.noResults = false;
            }
            console.log('success', result.data);
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
}