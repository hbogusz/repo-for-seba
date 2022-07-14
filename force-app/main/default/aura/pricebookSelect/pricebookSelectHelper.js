({
    loadPricebooks : function(component) {
        var action = component.get("c.getPricebooks");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.pricebooks", result);
            }
        });
        $A.enqueueAction(action);
    }
})
