public with sharing class ProductController {
    public ProductController() {

    }
    @AuraEnabled
    public static void updateCreatedProduct(Product2 product, decimal unitPrice){
        try {
            update product;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        addPricebookEntry(product.Id, unitPrice);
    }
    @AuraEnabled
    public static void addPricebookEntry(String productId, decimal unitPrice){

        List<Pricebook2> pricebooks = [SELECT Id FROM Pricebook2];
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(
            Product2Id = productId,
            Pricebook2Id = getStandardPricebookId(),
            UnitPrice = unitPrice
        );

        try {
            insert standardPrice;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        for( Pricebook2 pricebook : pricebooks){
            if(pricebook.Id != getStandardPricebookId()){
                PricebookEntry pricebookEntry = new PricebookEntry();
                pricebookEntry.Product2Id = productId;
                pricebookEntry.Pricebook2Id = pricebook.Id;
                pricebookEntry.UnitPrice = unitPrice;
                pricebookEntries.add(pricebookEntry);
            }
        }
        
        try {
            insert pricebookEntries;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Id getStandardPricebookId(){
        Pricebook2 pricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1]; 
        return pricebook.Id;
    }
}