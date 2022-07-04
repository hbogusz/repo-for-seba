public with sharing class InternalService {
    public InternalService() {

    }
    @AuraEnabled(Cacheable=true)
    public static List<Wrappers.PricebookEntryWrapper> searchProducts(String searchTerm) {
        String queryString = '%' + searchTerm + '%';
        
        List<PricebookEntry> products = [ Select Product2.Id, Product2.Name, Product2.ProductCode, Product2.Family, Product2.Image__c, Product2.Review_Count__c, Product2.Review_Average__c, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsActive = TRUE AND Product2.Name LIKE :queryString
        WITH SECURITY_ENFORCED];

         List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
         wrappers = convertPricebookEntriesToWrappers(products);      
         return wrappers;
     }
     @AuraEnabled(Cacheable=true)
     public static List<Wrappers.PricebookEntryWrapper> searchProductsByCategory(String category) {
         List<PricebookEntry> products = [ Select Product2.Id, Product2.Name, Product2.ProductCode, Product2.Family, Product2.Image__c, Product2.Review_Count__c, Product2.Review_Average__c, UnitPrice
         FROM PricebookEntry
         WHERE Pricebook2.IsActive = TRUE AND Product2.Family = :category
         WITH SECURITY_ENFORCED];
 
          List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
          wrappers = convertPricebookEntriesToWrappers(products);      
          return wrappers;
      }

     public static List<Wrappers.ProductWrapper> convertProductsToWrappers(List<Product2> products){
        List<Wrappers.ProductWrapper> wrappers = new List<Wrappers.ProductWrapper>();
        for(Product2 product : products){
            Wrappers.ProductWrapper wrapper = new Wrappers.ProductWrapper();
            wrapper.id = product.Id;
            wrapper.name = product.Name;
            wrapper.description = product.Description;
            wrapper.image = product.Image__c;
            wrapper.family = product.Family;
            wrappers.add(wrapper);
        }
        return wrappers;
    }

    public static List<Wrappers.PricebookEntryWrapper> convertPricebookEntriesToWrappers(List<PricebookEntry> pricebookEntries){
        List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
        for(PricebookEntry pricebookEntry : pricebookEntries){
            Wrappers.PricebookEntryWrapper wrapper = new Wrappers.PricebookEntryWrapper();
            wrapper.productId = pricebookEntry.Product2.Id;
            wrapper.productName = pricebookEntry.Product2.Name;
            wrapper.image = pricebookEntry.Product2.Image__c;
            wrapper.family = pricebookEntry.Product2.Family;
            wrapper.reviewCount = pricebookEntry.Product2.Review_Count__c;
            wrapper.reviewAverage = pricebookEntry.Product2.Review_Average__c;
            wrapper.unitPrice = pricebookEntry.UnitPrice;
            wrappers.add(wrapper);
        }
        return wrappers;
    }

}
