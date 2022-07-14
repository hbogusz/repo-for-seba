({
    onInit: function (component, event, helper) {
        component.set('v.spinner', false);
        helper.loadPricebooks(component);
    },
    onRowAction: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("id");
        console.log(recordId);
        var event = $A.get("e.c:PricebookSelected");
        event.setParams({
            "selectedId": recordId
        });
        event.fire();
    }
})
