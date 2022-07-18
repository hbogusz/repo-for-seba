({
    onPricebookSelect: function (component, event, helper) {
        let pricebookId = event.getParam('selectedId')
        component.set("v.recordId", pricebookId);
        component.set("v.isNotStandard", pricebookId != component.get("v.standardId") ? true : false);
    },
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
        cmp.find('field').forEach(function (f) {
            f.reset();
        });
    },
    doInit: function (component, event, helper) {
        var action = component.get("c.getStandardPricebookId");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.standardId", result);
            }
        });
        $A.enqueueAction(action);
    },
    handleDelete: function (component, event, helper) {
        let recordId = component.get("v.recordId");
        helper.handleDelete(component, recordId);
    },

})
