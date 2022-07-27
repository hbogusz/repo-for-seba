public with sharing class CaseTriggerHandler implements ITriggerHandler {
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
        List<Case> caseList = new List<Case>();
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        for(Case c : [SELECT Id FROM Case WHERE Id IN: newItems.keySet()]) {
        c.setOptions(dmo);
        caseList.add(c);
        }
        update caseList;
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
       
    }
    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
}

