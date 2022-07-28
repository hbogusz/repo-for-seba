@isTest
private class PricebookControllerTest {
    @isTest static void TestGetPricebookWithOnePricebook() {
        Pricebook2 pricebook = new Pricebook2(Name='test pricebook');
        insert pricebook;
        List<Pricebook2> result = PricebookController.getPricebooks();
        System.assertEquals(true, result.size() > 0);
    }
}

