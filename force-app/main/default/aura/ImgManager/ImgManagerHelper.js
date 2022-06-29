({
    getuploadedFiles: function (component) {
        var action = component.get("c.getFiles");
        action.setParams({
            "recordId": component.get("v.productId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.files", result);
                if(result.length == 0){
                component.set("v.hasFiles", false);
                } else {
                component.set("v.hasFiles", true);
                }

            }
        });
        $A.enqueueAction(action);

        var addimgs = component.get("c.getAddedImages");
        addimgs.setParams({
            "productId": component.get("v.productId")
        });
        addimgs.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.images", result);
            }
        });
        $A.enqueueAction(addimgs);
    },

    delUploadedfiles: function (component, documentId) {
        var action = component.get("c.deleteFiles");
        action.setParams({
            "sdocumentId": documentId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                this.getuploadedFiles(component);
            }
        });
        $A.enqueueAction(action);
    },
}) 