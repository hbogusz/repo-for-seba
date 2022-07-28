({
    loadPricebooks: function (component) {
        var action = component.get("c.getPricebooks");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.pricebooks", result);
            }
        });
        $A.enqueueAction(action);
    },
    openModalEdit: function (component,recordId) {
        var modalBody;
        $A.createComponent("c:createPricebook", 
        {
            "recordId": recordId
        },
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    var modalPromise = component.find('overlayNew').showCustomModal({
                        header: "Edit Price Book",
                        body: modalBody,
                        showCloseButton: true
                    });
                    component.set("v.modalPromise", modalPromise);
                }
            });
        
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
                this.loadPricebooks(component);
                $A.get("e.c:PricebookDeleted").fire();
                $A.get("e.c:SpinnerOff").fire();
            }
        });
        $A.enqueueAction(action);
    },
})
