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
                console.log("result", result);
                component.set("v.items", result);
                component.set('v.noResult', result.length == 0 ? true : false);
            }
        });
        $A.enqueueAction(action);
    }
})
