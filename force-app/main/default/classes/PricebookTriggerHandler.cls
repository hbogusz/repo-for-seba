public with sharing class PricebookTriggerHandler implements ITriggerHandler  {
    public static Boolean TriggerDisabled = false;
    public Boolean IsDisabled() {
        return TriggerDisabled;
    }
    public void BeforeInsert(List<SObject> newItems) {
        // PricebookControllerForTrigger.disableActive(newItems,new List<Pricebook2>());
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // PricebookControllerForTrigger.disableActive(newItems.values(),oldItems.values());
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterInsert(Map<Id, SObject> newItems) {
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // PricebookControllerForTrigger.setStandardActiveWhenNoActive(newItems);
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
}
