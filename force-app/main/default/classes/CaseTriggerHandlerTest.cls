@isTest
private class CaseTriggerHandlerTest {
    @isTest static void TestAfterInsert() {
        Case cs = new Case(Subject='Test Case', FitStore__c=true);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(cs, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }
}
