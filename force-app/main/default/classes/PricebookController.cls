public with sharing class PricebookController {
    public PricebookController() {
    }
    @AuraEnabled
    public static List<Pricebook2> getPricebooks(){
        List<Pricebook2> pricebooks = [SELECT Id, Name, Start_Date__c, Expiration_Date__c, IsActive FROM Pricebook2];
        return pricebooks;
    }
    @AuraEnabled
    public static List<Wrappers.PricebookEntryWrapper> getPricebookItems(String pricebookId){
        List<PricebookEntry> pricebookEntries = [ Select Id, Product2.Id, Product2.Name, 
        Product2.ProductCode, Product2.Family, Product2.Image__c, UnitPrice, IsActive
        FROM PricebookEntry
        WHERE Pricebook2.Id = :pricebookId
        ORDER BY Product2.ProductCode ASC
       ];
       List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
       wrappers = convertPricebookEntryToWrapper(pricebookEntries);
        return wrappers;
    }
    @AuraEnabled
    public static Wrappers.InternalResponse addPricebookEntries(String pricebookId){
        Wrappers.InternalResponse response = new Wrappers.InternalResponse();
        Id standardPricebookId = ProductController.getStandardPricebookId();
        List<PricebookEntry> pricebookEntries = [ Select Product2.Id, Pricebook2.Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2.Id = :standardPricebookId
        ];
        List<PricebookEntry> newPricebookEntries = new List<PricebookEntry>();

        for (PricebookEntry pricebookEntry : pricebookEntries) {
            PricebookEntry newPricebookEntry = new PricebookEntry();
            newPricebookEntry.Product2Id = pricebookEntry.Product2.Id;
            newPricebookEntry.Pricebook2Id = pricebookId;
            newPricebookEntry.UnitPrice = pricebookEntry.UnitPrice;
            newPricebookEntries.add(newPricebookEntry);
        }
        try {
            insert newPricebookEntries;
            response.status = 'success';
        } catch (Exception e) {
            response.status = 'error';
            response.message = e.getMessage();
            }
        return response;
    }
    @AuraEnabled
    public static List<Wrappers.PricebookEntryWrapper> updatePricebookItemsForSelected(String pricebookId, String newItems, Integer discount, String type){
        List<Wrappers.PricebookEntryWrapper> newItemsWrappers = (List<Wrappers.PricebookEntryWrapper>) JSON.deserialize(newItems, List<Wrappers.PricebookEntryWrapper>.class);
        Map<String,Wrappers.PricebookEntryWrapper> newItemsMap = new Map<String,Wrappers.PricebookEntryWrapper>();
        for (Wrappers.PricebookEntryWrapper item : newItemsWrappers) {
            newItemsMap.put(item.productId, item);
        }
        List<PricebookEntry> pricebookEntries = [ Select Id, Product2.Id, Product2.Name, 
        Product2.ProductCode, Product2.Family, Product2.Image__c, UnitPrice, IsActive
        FROM PricebookEntry
        WHERE Pricebook2.Id = :pricebookId
        ORDER BY Product2.ProductCode ASC
       ];
       if (type == 'percent') {
        for (PricebookEntry pricebookEntry : pricebookEntries) {
            if (newItemsMap.containsKey(pricebookEntry.Product2.Id)) {
                pricebookEntry.UnitPrice = (pricebookEntry.UnitPrice*(100-discount)/100).setScale(2);
            }
           }
       } else if (type == 'value') {
        for (PricebookEntry pricebookEntry : pricebookEntries) {
            if (newItemsMap.containsKey(pricebookEntry.Product2.Id)) {
                pricebookEntry.UnitPrice -= discount;
            }
           }
       }
       
       try {
        update pricebookEntries;
    } catch (Exception e) {
        System.debug(e.getMessage());
        }

        List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
        wrappers = convertPricebookEntryToWrapper(pricebookEntries);
        
     return wrappers;
    }
    @AuraEnabled
    public static List<Wrappers.PricebookEntryWrapper> updatePricebookItemsIndividual(String pricebookId, String newItems){
        List<Wrappers.PricebookEntryWrapper> newItemsWrappers = (List<Wrappers.PricebookEntryWrapper>) JSON.deserialize(newItems, List<Wrappers.PricebookEntryWrapper>.class);
        Map<String,Wrappers.PricebookEntryWrapper> newItemsMap = new Map<String,Wrappers.PricebookEntryWrapper>();
        for (Wrappers.PricebookEntryWrapper item : newItemsWrappers) {
            newItemsMap.put(item.productId, item);
        }
        List<PricebookEntry> pricebookEntries = [ Select Id, Product2.Id, Product2.Name, 
        Product2.ProductCode, Product2.Family, Product2.Image__c, UnitPrice, IsActive
        FROM PricebookEntry
        WHERE Pricebook2.Id = :pricebookId
        ORDER BY Product2.ProductCode ASC
       ];
       for (PricebookEntry pricebookEntry : pricebookEntries) {
        if (newItemsMap.containsKey(pricebookEntry.Product2.Id)) {
            pricebookEntry.UnitPrice = newItemsMap.get(pricebookEntry.Product2.Id).unitPrice.setScale(2);
        }
       }
        try {
            update pricebookEntries;
        } catch (Exception e) {
            System.debug(e.getMessage());
            }

        List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
        wrappers = convertPricebookEntryToWrapper(pricebookEntries);
        
     return wrappers;
    }
    @AuraEnabled
    public static Id getStandardPricebookId(){
        return ProductController.getStandardPricebookId();
    }
    @AuraEnabled
    public static List<Pricebook2> handleActive(String pricebookId){
        List<Pricebook2> pricebooks = [SELECT Id, Name, Start_Date__c, Expiration_Date__c, IsActive,isStandard FROM Pricebook2];
        Boolean activeValue = false;
        Integer activeIndex = 0;
        Boolean hasActive = false;
        Set<Id> activeIds = new Set<Id>();
        for (Pricebook2 pricebook : pricebooks) {
            if (pricebook.isActive == true){
                if (pricebook.Id == pricebookId ) {
                activeValue = true;
                activeIndex = pricebooks.indexOf(pricebook);
            }
                activeIds.add(pricebook.Id);
            }
            
        }
        if (activeValue) {
            pricebooks.remove(activeIndex);
            for (Pricebook2  pricebook : pricebooks) {
                pricebook.IsActive = false;
            }
        } else if (activeIds.size() == 0) {
            for (Pricebook2 pricebook : pricebooks) {
                if (pricebook.IsStandard == true) {
                    pricebook.IsActive = true;
                }
            }
        }
        try {
            update pricebooks;
        } catch (Exception e) {
            System.debug(e);
        }

        return pricebooks;
    }

    @AuraEnabled
    public static void deletePricebook(String pricebookId){
        Pricebook2 pricebook = [SELECT Id, Name, Start_Date__c, Expiration_Date__c, IsActive, isStandard FROM Pricebook2 WHERE Id = :pricebookId];
        if (pricebook.IsActive == true) {
            Pricebook2 standardPricebook = [SELECT Id, Name, IsActive, isStandard FROM Pricebook2 WHERE isStandard = true];
            standardPricebook.IsActive = true;
            update standardPricebook;
        }
        List<PricebookEntry> pricebookEntries = [ Select Id
        FROM PricebookEntry
        WHERE Pricebook2.Id = :pricebookId
       ];
        try {
            delete pricebookEntries;
            delete pricebook;
        } catch (Exception e) {
            System.debug(e);
        }
    }


/////////////////////////////////////////////////////////    HELPER METHODS    //////////////////////////////////////////////
    public static List<Wrappers.PricebookEntryWrapper> convertPricebookEntryToWrapper( List<PricebookEntry> pricebookEntries){
        List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
        for (PricebookEntry pricebookentry : pricebookEntries) {
            Wrappers.PricebookEntryWrapper wrapper = new Wrappers.PricebookEntryWrapper();
            wrapper.productId = pricebookEntry.Product2.Id;
            wrapper.productName = pricebookEntry.Product2.Name;
            wrapper.productCode = pricebookEntry.Product2.ProductCode;
            wrapper.family = pricebookEntry.Product2.Family;
            wrapper.unitPrice = pricebookEntry.UnitPrice;
            wrappers.add(wrapper);
        }
    return wrappers;
    }

}