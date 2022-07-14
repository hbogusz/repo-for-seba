({
    onPricebookSelect : function(component, event, helper) {
        component.set("v.recordId", event.getParam( 'selectedId' ));
    },
    handleNew : function(component, event, helper) {
        component.set("v.recordId", null);
    },
    handleSaving: function(component, event, helper) {
    },
    handleSuccess: function(component, event, helper) {
        let pricebook = event.getParams().response;
        console.log("pricebook Id", pricebook.id);
        let recordId = component.get("v.recordId");
        if(recordId == undefined || recordId == null){
            helper.clonePricebookEntries(component,pricebook.id);
        }
        
    },
})
