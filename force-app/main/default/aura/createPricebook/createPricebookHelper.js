({
    clonePricebookEntries: function (component, pricebookId) {
        var action = component.get("c.addPricebookEntries");
        action.setParams({
            "pricebookId": pricebookId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Price Book created successfuly",
                    "type": "success"
                });
                toastEvent.fire();
                $A.get("e.c:PricebookEdited").fire();
                $A.get("e.c:SpinnerOff").fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleUpdate: function (component, pricebookId) {
        var action = component.get("c.handleActive");
        action.setParams({
            "pricebookId": pricebookId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Price Book edited successfuly",
                    "type": "success"
                });
                toastEvent.fire();
                $A.get("e.c:PricebookEdited").fire();
                $A.get("e.c:SpinnerOff").fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleDelete: function (component, pricebookId) {
        $A.get("e.c:SpinnerOn").fire();
        var action = component.get("c.deletePricebook");
        action.setParams({
            "pricebookId": pricebookId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Price Book deleted successfuly",
                    "type": "success"
                });
                toastEvent.fire();
                component.set("v.recordId", null);
                $A.get("e.c:PricebookEdited").fire();
                $A.get("e.c:PricebookDeleted").fire();
                $A.get("e.c:SpinnerOff").fire();
            }
        });
        $A.enqueueAction(action);
    },
})