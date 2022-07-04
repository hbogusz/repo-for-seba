import { api,LightningElement,wire } from 'lwc';

import searchProducts from '@salesforce/apex/InternalService.searchProducts';

export default class SearchResults extends LightningElement {
    @api
    term;
    searchedProducts;
    wiredSearchResult;
    noResults=false;
    resultsSize=0;

    @wire(searchProducts, {searchTerm: '$term'})
    wiredProducts(result) {
        this.wiredSearchResult = result;
        if (result.data) {
            this.searchedProducts = result.data;
            this.resultsSize = this.searchedProducts.length;
            if(this.resultsSize == 0){
                this.noResults = true;
            } else {
                this.noResults = false;
            }
        } else if (result.error) {
            console.log('data.error');
            console.log(result.error);
        }
    }
}