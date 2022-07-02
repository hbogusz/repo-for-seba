({
    getuploadedFiles: function (component) {
        component.set("v.spinner", true);
        var action = component.get("c.getFiles");
        action.setParams({
            "recordId": component.get("v.productId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.files", result);
                if (result.length == 0) {
                    component.set("v.hasFiles", false)
                    var sendNoImagesEvent = $A.get("e.c:ImagesAdded");
                    sendNoImagesEvent.setParams({
                        "imgId": null
                    });
                    sendNoImagesEvent.fire();;
                } else {
                    component.set("v.hasFiles", true);
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    delUploadedfiles: function (component, documentId) {
        component.set("v.spinner", true);
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