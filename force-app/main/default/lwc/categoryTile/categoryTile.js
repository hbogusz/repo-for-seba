import { api, LightningElement } from 'lwc';
import protein from '@salesforce/resourceUrl/protein';
import preWorkout from '@salesforce/resourceUrl/preWorkout';
import vitamins from '@salesforce/resourceUrl/vitamins';
import creatine from '@salesforce/resourceUrl/creatine';
import equipment from '@salesforce/resourceUrl/equipment';
import { NavigationMixin } from 'lightning/navigation';


export default class CategoryTile extends NavigationMixin(LightningElement) {
    @api
    category;

    get imagePath() {
        const catArray = [['Protein', protein ], ['Pre-Workout', preWorkout],
         ['Vitamins', vitamins ], ['Creatine', creatine], ['Equipment', equipment]]
         const catMap = new Map(catArray)
         console.log('category', this.category);
         console.log('category', catMap.has(this.category));
        return catMap.get(this.category);
    }
    
    navigateToPage() {
        console.log('navigate');
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: this.category.toLowerCase()
            },
        });
    }
}