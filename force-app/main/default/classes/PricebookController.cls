public with sharing class PricebookController {
    public PricebookController() {
    }
    @AuraEnabled
    public static List<Pricebook2> getPricebooks(){
        List<Pricebook2> pricebooks = [SELECT Id, Name, IsActive FROM Pricebook2];
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


