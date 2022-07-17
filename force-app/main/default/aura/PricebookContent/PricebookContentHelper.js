({
    loadPricebookItems : function(component,pricebookId) {
        var action = component.get("c.getPricebookItems");
        action.setParams({
            "pricebookId": pricebookId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.items", result);
                component.set('v.noResult', result.length == 0 ? true : false);
            }
        });
        $A.enqueueAction(action);
    },
    updatePricebookEntries: function (component, pricebookId, lines, discount ) {
        var action = component.get("c.updatePricebookItemsForSelected");
        action.setParams({
            "pricebookId": pricebookId,
            "newItems": JSON.stringify(lines),
            "discount": discount
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.items", result);
                component.set("v.selectedRows", []);
                component.set('v.showDiscount', false);
                component.set('v.noResult', result.length == 0 ? true : false);
            }
        });
        $A.enqueueAction(action);
    },
    saveEdition: function (component,pricebookId, draftValues) {
        var action = component.get("c.updatePricebookItemsIndividual");
        action.setParams({
            "pricebookId": pricebookId,
            "newItems": JSON.stringify(draftValues),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                this.fireSuccessToast(component);
                this.loadPricebookItems(component,pricebookId);
                component.set("v.draftValues", []);
            } else if (state === "ERROR") {
                var errors = response.error;
                console.error(errors);
                this.fireFailureToast(component);
            }
        });
        $A.enqueueAction(action);
    },
    fireSuccessToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Success', 
            'message' : 'Pricebook updated sucessfully.' ,
            'type':'success'
        }); 
        toastEvent.fire(); 
    },
    
    fireFailureToast : function(component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            'title' : 'Failed', 
            'message' : 'An error occurred. Please contact your administrator.',
            'type':'error'
        }); 
        toastEvent.fire(); 
    },
    
})
