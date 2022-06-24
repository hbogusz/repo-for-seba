public with sharing class InternalService {
    public InternalService() {

    }
    @AuraEnabled(Cacheable=true)
    public static List<Wrappers.ProductWrapper> searchProducts(String searchTerm) {
        String queryString = '%' + searchTerm + '%';
         List<Product2> products = new List<Product2>();
         products = [ SELECT Id,Name,Description, Image__c, Family
         FROM Product2
         WHERE Name LIKE :queryString
         WITH SECURITY_ENFORCED];
         List<Wrappers.ProductWrapper> wrappers = new List<Wrappers.ProductWrapper>();
         wrappers = convertProductsToWrappers(products);      
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

}
