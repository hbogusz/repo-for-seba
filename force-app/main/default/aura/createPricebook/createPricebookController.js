({
    handleNew: function (component, event, helper) {
        component.set("v.recordId", null);
    },
    handleError: function (component, event, helper) {
        var errorMessage = event.getParam("message");
        toastEvent.setParams({
            "title": "Error!",
            "message": errorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
    handleSuccess: function (component, event, helper) {
        $A.get("e.c:SpinnerOn").fire();
        let pricebook = event.getParams().response;
        let recordId = component.get("v.recordId");
        if (recordId == undefined || recordId == null) {
            helper.clonePricebookEntries(component, pricebook.id);
        } else {
            helper.handleUpdate(component, pricebook.id);
        }


    },
    handleReset: function (cmp, event, helper) {
        $A.get("e.c:PricebookEdited").fire();
    },
    handleDelete: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.handleDelete(component, recordId);
    },

})
