@isTest
private class ReviewTriggerHandlerTest{
    @isTest static void TestAfterUpdateWithOneReview() {
        Product2 product = new Product2(Name='Test Product');
        insert product;
        Review__c review = new Review__c();
        review.Status__c = 'New';
        review.ProductId__c = product.Id;
        review.Rating__c = 5;
        insert review;
        review.Status__c = 'Approved';

        Test.startTest();
        Database.SaveResult result = Database.update(review, false);
        Product2 productResult = [
                SELECT Id, Name, Review_Count__c FROM Product2
                WHERE Id= :product.Id];
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assertEquals(1, productResult.Review_Count__c);
    }
}
