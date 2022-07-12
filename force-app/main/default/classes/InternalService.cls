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

    @AuraEnabled(Cacheable=true)
    public static List<Order> getOrders() {
        String userId = UserInfo.getUserId();
        List<Order> orders = [Select Id, Pricebook2Id, OwnerId, Status, EffectiveDate, OrderNUmber
        FROM Order
        WHERE OwnerId = :userId
        ORDER BY EffectiveDate DESC];
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
    // public static List<Wrappers.OrderWrapper> convertOrdersToWrapper(List<OrderItem> items){
    //     List<Wrappers.OrderWrapper> orderWrappers = new List<Wrappers.OrderWrapper>();
    //     Set<id> ids = new Set<Id>();
    //     for(OrderItem item : items){
    //         if (ids.contains(item.OrderId)) {
    //             Wrappers.OrderWrapper currentWrapper = orderWrappers.get(arg0);
    //         } else {
    //             Wrappers.OrderWrapper wrapper = new Wrappers.OrderWrapper();
    //             wrapper.id = item.Order.Id;
    //             wrapper.pricebook2Id = item.Order.Pricebook2Id;
    //             wrapper.status = item.Order.Status;
    //             wrapper.effectiveDate = item.Order.EffectiveDate;
    //             ids.add(item.OrderId);

    //             wrapper.itemWrappers = new List<Wrappers.OrderItemWrapper>();
    //             Wrappers.OrderItemWrapper itemWrapper = new Wrappers.OrderItemWrapper();
    //             itemWrapper.id = item.Id;
    //             itemWrapper.orderId = item.OrderId;
    //             itemWrapper.quantity = item.Quantity;
    //             itemWrapper.unitPrice = item.UnitPrice;
    //             wrapper.orderitems = item.Order.EffectiveDate;
    //             wrapper.itemWrappers.add(itemWrapper);
    //             orderWrappers.add(wrapper);
    //         }
            

    //         Wrappers.OrderItemWrapper itemWrapper = new Wrappers.OrderItemWrapper();
    //         itemWrapper.id = item.Id;
    //         itemWrapper.orderId = item.OrderId;
    //         itemWrapper.quantity = item.Quantity;
    //         itemWrapper.unitPrice = item.UnitPrice;
    //         wrapper.orderitems = item.Order.EffectiveDate;
    //         orderWrappers.add(itemWrapper);
    //     }
    //     return reviewWrappers;
    // }
}
