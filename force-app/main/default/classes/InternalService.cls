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
        ];
 
          List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
          wrappers = convertPricebookEntriesToWrappers(products);      
          return wrappers;
      }

     @AuraEnabled(Cacheable=true)
     public static Wrappers.PricebookEntryWrapper getProduct(String recordId) {        
        PricebookEntry product = [ Select Product2.Id, Product2.Name, Product2.ProductCode, Product2.Family, Product2.Description, Product2.Image__c, Product2.Review_Count__c, Product2.Review_Average__c, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsActive = TRUE AND Product2.Id = :recordId
        ];

         Wrappers.PricebookEntryWrapper wrapper = new Wrappers.PricebookEntryWrapper();
         wrapper = convertPricebookEntryToWrapper(product);      
         return wrapper;
     }
     @AuraEnabled(Cacheable=false)
     public static Wrappers.InternalResponse saveReview(String author, String content, String productId, String rating ) {
        Wrappers.InternalResponse response = new Wrappers.InternalResponse();
        Review__c review = new Review__c();
        review.Content__c = content;
        review.ProductId__c = productId;
        review.Author__c = author;
        review.Rating__c = Integer.valueOf(rating);
        review.Created_at__c = Date.today();
        try {
            insert review;
            response.status = 'success';
        } catch (Exception e) {
            response.status = 'error';
            response.message = e.getMessage();
        }
        return response;
    }
     @AuraEnabled(Cacheable=true)
     public static List<Wrappers.ReviewWrapper> getReviews(String productId) {
        List <Review__c> reviews = new List<Review__c>();
        reviews = [ SELECT Name,Author__c, Content__c, Created_at__c, ProductId__c,Rating__c
        FROM Review__c
        WHERE ProductId__c = :productId
        WITH SECURITY_ENFORCED];
        List<Wrappers.ReviewWrapper> reviewWrappers = new List<Wrappers.ReviewWrapper>();
        if(reviewWrappers != null){
            reviewWrappers = convertReviewToWrapper(reviews);
        }
        return reviewWrappers;
    }


//////////////////////////////              HELPER                    //////////////////////////////////////////////
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

    public static Wrappers.PricebookEntryWrapper convertPricebookEntryToWrapper(PricebookEntry pricebookEntry){
            Wrappers.PricebookEntryWrapper wrapper = new Wrappers.PricebookEntryWrapper();
            wrapper.productId = pricebookEntry.Product2.Id;
            wrapper.productName = pricebookEntry.Product2.Name;
            wrapper.image = pricebookEntry.Product2.Image__c;
            wrapper.family = pricebookEntry.Product2.Family;
            wrapper.description = pricebookEntry.Product2.Description;
            wrapper.reviewCount = pricebookEntry.Product2.Review_Count__c;
            wrapper.reviewAverage = pricebookEntry.Product2.Review_Average__c;
            wrapper.unitPrice = pricebookEntry.UnitPrice;
        return wrapper;
    }

    public static List<Wrappers.ReviewWrapper> convertReviewToWrapper(List<Review__c> reviews){
        List<Wrappers.ReviewWrapper> reviewWrappers = new List<Wrappers.ReviewWrapper>();
        for(Review__c review : reviews){
            Wrappers.ReviewWrapper wrapper = new Wrappers.ReviewWrapper();
            wrapper.content = review.Content__c;
            wrapper.author = review.Author__c;
            wrapper.created_at = String.valueOf(review.Created_at__c);
            wrapper.rating = String.valueOf(review.Rating__c);
            reviewWrappers.add(wrapper);
        }
        return reviewWrappers;
    }
}
