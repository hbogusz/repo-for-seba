@isTest
public class TestDataFactory {
    public static Pricebook2 createPricebook(Boolean isActive) {
        Pricebook2 pricebook = new Pricebook2(Name='test pricebook', IsActive=isActive);
        insert pricebook;
        return pricebook;
    }
    public static List<PricebookEntry> createPricebookItemsAndProductsForPricebook(Integer count, Pricebook2 pricebook) {
        List<Product2> products = new List<Product2>();
        List<Id> productIds = new List<Id>();
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        List<PricebookEntry> standardPrices = new List<PricebookEntry>();
        for(Integer i=0;i<count;i++) {
            Product2 product = new Product2(Name='Product' + i);
            products.add(product);
        }
        insert products;
        for(Product2 product : products) { 
            productIds.add(product.Id);
        }
        Id standardId = Test.getStandardPricebookId();
        for(Integer i=0;i<count;i++) {
            PricebookEntry p = new PricebookEntry();
            p.Pricebook2Id = standardId;
            p.Product2Id = productIds.get(i);
            p.UnitPrice = 10;
            standardPrices.add(p);
        }
        for(Integer i=0;i<count;i++) {
            PricebookEntry p = new PricebookEntry();
            p.Pricebook2Id = pricebook.Id;
            p.Product2Id = productIds.get(i);
            p.UnitPrice = 20;
            pbEntries.add(p);
        }
        insert standardPrices;
        insert pbEntries;
        return pbEntries;
    }
    public static String createSerializedItems(Integer count) {
        List<Wrappers.PricebookEntryWrapper> items = new List<Wrappers.PricebookEntryWrapper>();
        for(Integer i=0;i<count;i++) {
            Wrappers.PricebookEntryWrapper wrapper = new Wrappers.PricebookEntryWrapper();
            wrapper.productId = '12345678901234567' + i;
            wrapper.unitPrice = 20;
            items.add(wrapper);
        }
        return JSON.serialize(items);
    }
    public static Boolean findPricebook(String id) {
        List <Pricebook2> pricebooks = new List <Pricebook2>();
        pricebooks = [SELECT Id, isActive FROM Pricebook2 WHERE Id = :id];
        return pricebooks.size() == 0? true : false;
    }
    public static void createStandardPricebook() {
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
            );
        update standardPricebook;
    }
    public static Product2 creatSingleProduct() {
        Product2 product = new Product2(Name='Test');
        insert product;
        return product;
    }
    public static List<PricebookEntry> getPricebookEntriesForProduct(String productId) {
        return [
            SELECT Id, UnitPrice, Product2Id, Pricebook2Id 
            FROM PricebookEntry 
            WHERE Product2Id = :productId ];
    }
}