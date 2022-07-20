public with sharing class InternalService {
    public InternalService() {

    }
    @AuraEnabled(Cacheable=true)
    public static List<Wrappers.PricebookEntryWrapper> searchProducts(String searchTerm) {
        String queryString = '%' + searchTerm + '%';
        
        List<PricebookEntry> products = [ Select Product2.Id, Product2.Name, Product2.ProductCode, Product2.Family, Product2.Image__c, Product2.Review_Count__c, Product2.Review_Average__c,Product2.Description, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsActive = TRUE AND Product2.Name LIKE :queryString
        WITH SECURITY_ENFORCED];
        
        List<PricebookEntry> standardPrices = [ Select Product2.Id, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsStandard = TRUE AND Product2.Name LIKE :queryString
        WITH SECURITY_ENFORCED];

        List<PricebookEntry> standardPrices = [ Select Product2.Id, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsStandard = TRUE AND Product2.Name LIKE :queryString
        WITH SECURITY_ENFORCED];

         List<Wrappers.PricebookEntryWrapper> wrappers = new List<Wrappers.PricebookEntryWrapper>();
         wrappers = convertPricebookEntriesToWrappers(products);      
         return wrappers;
     }
     @AuraEnabled(Cacheable=true)
     public static List<Wrappers.PricebookEntryWrapper> searchProductsByCategory(String category) {
         List<PricebookEntry> products = [ Select Product2.Id, Product2.Name, Product2.ProductCode, Product2.Family, Product2.Image__c, Product2.Review_Count__c, Product2.Review_Average__c,Product2.Description, UnitPrice
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

    @AuraEnabled(Cacheable=true)
    public static List<Order> getOrders() {
        String userId = UserInfo.getUserId();
        List<Order> orders = [Select Id, Pricebook2Id, OwnerId, Status, EffectiveDate, OrderNUmber
        FROM Order
        WHERE OwnerId = :userId
        ORDER BY OrderNumber DESC];
         return orders;
     }
     @AuraEnabled(Cacheable=true)
     public static List<Wrappers.OrderItemWrapper> getOrderItemsforOrder(String orderId) {
         String userId = UserInfo.getUserId();
         List<OrderItem> orderitems = [Select Id, OrderId, Order.Id, Order.Pricebook2Id, Order.Status, Order.EffectiveDate, Quantity, UnitPrice, Product2.Family,Product2.Name,Product2.Flavour__c
         FROM OrderItem
         WHERE OrderId = :orderId
         WITH SECURITY_ENFORCED];
         List<Wrappers.OrderItemWrapper> itemWrappers = convertOrderItemToWrapper(orderitems);
          return itemWrappers;
      }
      @AuraEnabled(Cacheable=false)
     public static Wrappers.InternalResponse saveCase(String subject, String reason, String description, String productId) {
        Wrappers.InternalResponse response = new Wrappers.InternalResponse();
        Case complaint = new Case();
        complaint.Subject = subject;
        complaint.Reason = reason;
        complaint.Description = description;
        complaint.Status = 'New';
        complaint.Origin = 'Web';
        complaint.Product__c = productId;
        complaint.FitStore__c = true;

        try {
            insert complaint;
            response.status = 'success';
        } catch (Exception e) {
            response.status = 'error';
            response.message = e.getMessage();
        }
        return response;
      }

      @AuraEnabled(Cacheable=true)
      public static List<Case> getComplaints() {
          List<Case> cases = [Select Id, Product__r.Name, Status, Subject, 
          Description, Reason, CaseNumber, CreatedDate
          FROM Case
          WHERE FitStore__c = true
          ORDER BY CreatedDate DESC];
            return cases;
       }

       @AuraEnabled(Cacheable=true)
       public static void saveComplaintId(String complaintId){
           Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');            
           sessionPart.put('complaintId', complaintId);
       }
       @AuraEnabled(Cacheable=true)
       public static String getComplaintId(){
           Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');            
           return (String)sessionPart.get('complaintId');
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
            wrapper.description = pricebookEntry.Product2.Description;
            wrappers.add(wrapper);
        }
        wrappers = getStandardPrices(wrappers);
        return wrappers;
    }

    public static Wrappers.PricebookEntryWrapper convertPricebookEntryToWrapper(PricebookEntry pricebookEntry){
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        pricebookEntries.add(pricebookEntry);
        List<Wrappers.PricebookEntryWrapper> wrappers = convertPricebookEntriesToWrappers(pricebookEntries);
        return wrappers.get(0);
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
    public static List<Wrappers.OrderItemWrapper> convertOrderItemToWrapper(List<OrderItem> items){
        List<Wrappers.OrderItemWrapper> itemsWrappers = new List<Wrappers.OrderItemWrapper>();
        for(OrderItem item : items){
            Wrappers.OrderItemWrapper wrapper = new Wrappers.OrderItemWrapper();
            wrapper.id = item.Id;
            wrapper.orderId = item.Order.Id;
            wrapper.quantity = item.Quantity;
            wrapper.unitPrice = item.UnitPrice;
            wrapper.family = item.Product2.Family;
            wrapper.flavour = item.Product2.Flavour__c;
            wrapper.productName = item.Product2.Name;
            wrapper.productId = item.Product2.Id;
            itemsWrappers.add(wrapper);
        }
        return itemsWrappers;
    }
    public static List<Wrappers.PricebookEntryWrapper> getStandardPrices(List<Wrappers.PricebookEntryWrapper> wrappers){
        List<PricebookEntry> standardPrices = [ Select Product2.Id, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2.IsStandard = TRUE
        WITH SECURITY_ENFORCED];
        Map<String,PricebookEntry> standardPricesMap = new Map<String,PricebookEntry>();
        for (PricebookEntry standardPrice : standardPrices) {
            standardPricesMap.put(standardPrice.Product2.Id, standardPrice);
        }
        for (Wrappers.PricebookEntryWrapper wrapper : wrappers) {
            wrapper.standardPrice = standardPricesMap.get(wrapper.productId).UnitPrice;
            if (wrapper.standardPrice != wrapper.unitPrice) {
                wrapper.hasDiscount = true;
            }
        }
        return wrappers;
    }
}

