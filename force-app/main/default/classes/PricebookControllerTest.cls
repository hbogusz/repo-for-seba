@isTest
private class PricebookControllerTest {
    @isTest static void TestGetPricebookWithOnePricebook() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        List<Pricebook2> result = PricebookController.getPricebooks();
        System.assertEquals(true, result.size() > 0);
    }
    @isTest static void TestGetPricebookItemsWithFiveItems() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        List<PricebookEntry> items = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        List<Wrappers.PricebookEntryWrapper> result = PricebookController.getPricebookItems(pricebook.Id);
        System.assertEquals(true, result.size() == 5);
    }
    @isTest static void TestUpdatePricebookItemsForSelectedWith10Percent() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        String items = TestDataFactory.createSerializedItems(3);
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        List<Wrappers.PricebookEntryWrapper> result = PricebookController.updatePricebookItemsForSelected(pricebook.Id, items, 10,'percent');
        System.assertEquals(true, result.size()>0);
    }
    @isTest static void TestUpdatePricebookItemsForSelectedWith5Value() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        String items = TestDataFactory.createSerializedItems(3);
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        List<Wrappers.PricebookEntryWrapper> result = PricebookController.updatePricebookItemsForSelected(pricebook.Id, items, 5,'value');
        System.assertEquals(true, result.size()>0);
    }
    @isTest static void TestupdatePricebookItemsIndividual() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        String items = TestDataFactory.createSerializedItems(3);
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        List<Wrappers.PricebookEntryWrapper> result = PricebookController.updatePricebookItemsIndividual(pricebook.Id, items);
        System.assertEquals(true, result.size()>0);
    }
    @isTest static void TestHandleActiveWithTwoActive() {
        Pricebook2 activePricebook = TestDataFactory.createPricebook(true);
        Pricebook2 notActivePricebook = TestDataFactory.createPricebook(true);
        List<Pricebook2> result = PricebookController.handleActive(activePricebook.Id);
        Boolean checkActive= true;
        for (Pricebook2 pricebook : result) {
            if (pricebook.Id == notActivePricebook.Id ) {
                checkActive=pricebook.IsActive;
            }
        }
        System.assertEquals(false, checkActive);
    }
    @isTest static void TestDeletePricebook() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        PricebookController.deletePricebook(pricebook.Id);
        Boolean result = TestDataFactory.findPricebook(pricebook.Id);
        System.assertEquals(true, result);
    }
    @isTest static void TestAddPricebookEntries() {
        Pricebook2 pricebook = TestDataFactory.createPricebook(false);
        Pricebook2 testPricebook = TestDataFactory.createPricebook(false);
        TestDataFactory.createStandardPricebook();
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookItemsAndProductsForPricebook(5, pricebook);
        Wrappers.InternalResponse result = PricebookController.addPricebookEntries(testPricebook.Id);
        System.assertEquals('success', result.status);
    }
}

