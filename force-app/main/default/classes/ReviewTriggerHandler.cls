public with sharing class ReviewTriggerHandler implements ITriggerHandler {
        public static Boolean TriggerDisabled = false;
        public Boolean IsDisabled() {
            return TriggerDisabled;
        }
        public void BeforeInsert(List<SObject> newItems) {
        }
        public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        }
        public void BeforeDelete(Map<Id, SObject> oldItems) {
        }
        public void AfterInsert(Map<Id, SObject> newItems) {
            Decimal amount;
            Decimal average;
            List <Review__c> newReviews = newItems.values();
            String productId = newReviews.get(0).ProductId__c;
            Product2 product = [SELECT Id, Name, Review_Average__c, Review_Count__c FROM Product2 WHERE Id=:productId];
            amount = product.Review_Count__c;
            average = product.Review_Average__c * amount;
            for (Review__c review : newReviews){
                average += review.Rating__c;
                amount++;
            }
            product.Review_Count__c = amount;
            product.Review_Average__c = (average/amount).setScale(1);
            try {
                update product;
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
        public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        }
        public void AfterDelete(Map<Id, SObject> oldItems) {
            Decimal amount;
            Decimal average;
            List <Review__c> oldReviews = oldItems.values();
            String productId = oldReviews.get(0).ProductId__c;
            Product2 product = [SELECT Id, Name, Review_Average__c, Review_Count__c FROM Product2 WHERE Id=:productId];
            amount = product.Review_Count__c;
            average = product.Review_Average__c * amount;
            for (Review__c review : oldReviews){
                average -= review.Rating__c;
                amount--;
            }
            product.Review_Count__c = amount;
            product.Review_Average__c = (average/amount).setScale(1);
            try {
                update product;
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
        public void AfterUndelete(Map<Id, SObject> oldItems) {
        }
}
