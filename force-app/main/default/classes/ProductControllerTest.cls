@isTest
private class ProductControllerTest {
    @isTest static void TestAddPricebookEntryForStandard() {
        TestDataFactory.createStandardPricebook();
        Product2 product = TestDataFactory.creatSingleProduct();
        ProductController.addPricebookEntry(product.Id, 10);
        List<PricebookEntry> entries = TestDataFactory.getPricebookEntriesForProduct(product.Id);
        System.assertEquals(true, entries.size() > 0 );
    }
    @isTest static void TestAddPricebookEntryForNotStandard() {
        TestDataFactory.createStandardPricebook();
        Pricebook2 pricebook = TestDataFactory.createPricebook(true);
        Product2 product = TestDataFactory.creatSingleProduct();
        ProductController.addPricebookEntry(product.Id, 10);
        List<PricebookEntry> entries = TestDataFactory.getPricebookEntriesForProduct(product.Id);
        System.assertEquals(true, entries.size() > 0 );
    }
    @isTest static void TestUpdateCreatedProduct() {
        TestDataFactory.createStandardPricebook();
        Pricebook2 pricebook = TestDataFactory.createPricebook(true);
        Product2 product = TestDataFactory.creatSingleProduct();
        ProductController.updateCreatedProduct(product, 10);
        List<PricebookEntry> entries = TestDataFactory.getPricebookEntriesForProduct(product.Id);
        System.assertEquals(true, entries.size() > 0 );
    }
}
