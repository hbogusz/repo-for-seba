({
    addPricebookEntry: function (component) {
        var action = component.get("c.addPricebookEntry");
        action.setParams({
            "productId": component.get("v.recordId"),
            "unitPrice": component.get("v.price")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Product created!",
                    "message": "Record ID: " + component.get("v.recordId"),
                    "type": "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})