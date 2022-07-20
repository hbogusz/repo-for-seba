public with sharing class PricebookControllerForTrigger {
    public PricebookControllerForTrigger() {

    }
    public static void disableActive(List <Pricebook2> pricebooks,List <Pricebook2> oldPricebooks) {
        Boolean hasActive = false;
        Boolean oldHasActive = false;
        for (Pricebook2 pricebook : pricebooks) {
            if (pricebook.IsActive == true) {
                hasActive = true;
                break;  
            }
        }
        // for (Pricebook2 oldPricebook : oldPricebooks) {
        //     if (oldPricebook.IsActive == true) {
        //         oldHasActive = true;
        //         break;  
        //     }
        // }
        // List <Pricebook2> activePricebooks = new List <Pricebook2>();
        //     activePricebooks = [
        //         SELECT Id, Name, Start_Date__c, Expiration_Date__c,isActive
        //         FROM Pricebook2
        //         WHERE isActive = true
        //     ];
        
        // Map <String,Pricebook2> activePricebooksMap = new Map <String,Pricebook2>();
        // for (Pricebook2 activePricebook : activePricebooks) {
        //     activePricebooksMap.put(activePricebook.Id, activePricebook);
        // }

        // System.debug('LENGTH' + activePricebooks.size() );
        if (hasActive) {
            // for (Pricebook2 pricebook : activePricebooks) {
            // pricebook.IsActive = false;
            // }
            Pricebook2 activePricebook = [
                SELECT Id, Name, Start_Date__c, Expiration_Date__c,isActive
                FROM Pricebook2
                WHERE isActive = true
            ];
            activePricebook.IsActive = false;
            try {
                update activePricebook;
                // update activePricebook;
            }
            catch(Exception e){
                System.debug(e);
            }  
        } 
        // else {
        //     for (Pricebook2 pricebook : pricebooks) {
        //         if (activePricebooksMap.containsKey(pricebook.Id)) {
        //             activePricebooksMap.remove(pricebook.Id);
        //         }
        //     }
        //     activePricebooks = activePricebooksMap.values();
        //     if(activePricebooks.size() == 0){
        //         Pricebook2 standardPricebook = [
        //             SELECT Id, Name,isActive
        //             FROM Pricebook2
        //             WHERE isStandard = true
        //             LIMIT 1
        //         ];
        //         standardPricebook.IsActive = true;
        //         try {
        //             update standardPricebook;
        //         } catch(Exception e){
        //             System.debug(e);
        //         }  
        //     }
        // }

    // public static boolean checkDate(Pricebook2 newPb, Pricebook2 oldPb) {
    //     return (newPb.Start_Date__c > oldPb.Expiration_Date__c) ||
    //             (newPb.Start_Date__c < oldPb.Start_Date__c && newPb.Expiration_Date__c < oldPb.Start_Date__c);
    // }
    // public static boolean isActive(Pricebook2 pb) {
    //     return pb.Start_Date__c <= Date.today() && pb.Expiration_Date__c >= Date.today();
    // }
    }
    public static void setStandardActiveWhenNoActive(Map<Id, SObject> newItems) {
        List <Pricebook2> activePricebooks = new List <Pricebook2>();
        activePricebooks = [
            SELECT Id, Name, Start_Date__c, Expiration_Date__c,isActive
            FROM Pricebook2
            WHERE isActive = true
        ];
        // if(activePricebooks.size() > 0){
        //     Integer itemNumber;
        //     for (Pricebook2 activePricebook : activePricebooks) {
        //         if (newItems.containsKey(activePricebook.Id)) {
        //             itemNumber = activePricebooks.indexOf(activePricebook);
        //         }
        //     }
        //     activePricebooks.remove(itemNumber);
        // }
        
        if(activePricebooks.size() == 0){
            Pricebook2 standardPricebook = [
                SELECT Id, Name,isActive
                FROM Pricebook2
                WHERE isStandard = true
                LIMIT 1
            ];
            standardPricebook.IsActive = true;
            try {
                update standardPricebook;
            } catch(Exception e){
                System.debug(e);
            }  
        }
    }     
    public static void blockOnlyStandardActive(List <Pricebook2> oldPricebooks , List <Pricebook2> newPricebooks) {
        Map <String,Pricebook2> oldPricebooksMap = new Map<String,Pricebook2>();
        for (Pricebook2 oldPricebook : oldPricebooks) {
            oldPricebooksMap.put(oldPricebook.Id, oldPricebook);
        }
        for (Pricebook2 newPricebook : newPricebooks) {
            if (newPricebook.IsStandard == true && newPricebook.IsActive == false && oldPricebooksMap.get(newPricebook.Id).IsActive == true) {
                newPricebook.AddError('Activate another pricebook to deactivate standard pricebook.');
            }
        }
    }
    
}
