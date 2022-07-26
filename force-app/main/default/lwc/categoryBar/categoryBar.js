import { LightningElement,wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Peoduct_OBJECT from '@salesforce/schema/Product2';
import FAMILY_FIELD from '@salesforce/schema/Product2.Family';

export default class CategoryBar extends LightningElement {
    familyPicklist;
    familyPicklistResult;
    @wire(getObjectInfo, { objectApiName: Peoduct_OBJECT })
    productObj;

    @wire(getPicklistValues,{
            recordTypeId: '$productObj.data.defaultRecordTypeId', 
            fieldApiName: FAMILY_FIELD
        })
        wiredProducts(result) {
            this.familyPicklistResult = result;
            if (result.data) {
                this.familyPicklist = result.data;
            } else if (result.error) {
                console.log('data.error');
                console.log(result.error);
            }
        }
    familyPicklist;

}