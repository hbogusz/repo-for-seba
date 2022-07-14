public with sharing class Wrappers {
    public Wrappers() {

    }
    public class ProductWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String productCode;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String family;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String image;
    }
    public class PricebookEntryWrapper{
        @AuraEnabled
        public String productId;
        @AuraEnabled
        public String productName;
        @AuraEnabled        
        public String productCode;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String family;
        @AuraEnabled
        public String image;
        @AuraEnabled
        public Decimal reviewCount;
        @AuraEnabled
        public Decimal reviewAverage;
        @AuraEnabled
        public Decimal unitPrice;
    }
    public class ImageWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String url;
    }
    public class InternalResponse{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String message;
    }
    public class ReviewWrapper{
        @AuraEnabled
        public String author;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String created_at;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String rating;
    }
    public class CartItemWrapper{
        @AuraEnabled
        public String flavour;
        @AuraEnabled
        public Decimal price;
        @AuraEnabled
        public String productId;
        @AuraEnabled
        public Integer quantity;
    }
    public class OrderItemWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String orderId;
        @AuraEnabled
        public Decimal quantity;
        @AuraEnabled
        public Decimal unitPrice;
        @AuraEnabled
        public String family;
        @AuraEnabled
        public String flavour;
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String productId;
        @AuraEnabled
        public Boolean hasComplaint;
    }
    public class OrderWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public List<OrderItemWrapper> orderitems;
        @AuraEnabled
        public Decimal pricebook2Id;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Date effectiveDate;
        @AuraEnabled
        public Integer orderNumber;
    }
    
    
}
