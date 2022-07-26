import { LightningElement } from 'lwc';
import slider1 from '@salesforce/resourceUrl/slider1';
import slider2 from '@salesforce/resourceUrl/sl2';
import slider3 from '@salesforce/resourceUrl/slider3';

export default class Slider extends LightningElement {
    get path1(){
        return slider1;
    }
    get path2(){
        return slider2;
    }
    get path3(){
        return slider3;
    }

}