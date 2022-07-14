({
    clonePricebookEntries : function(component,pricebookId) {
        var action = component.get("c.addPricebookEntries");
        console.log("pricebookId", pricebookId);
        action.setParams({
            "pricebookId": pricebookId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state", state);
            console.log("response", response);
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log("result", result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Price Book created successfuly",
                    "type": "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})
