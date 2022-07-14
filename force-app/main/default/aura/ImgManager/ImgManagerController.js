({
    onInit: function (component, event, helper) {
        component.set('v.hasFiles', false);
        component.set('v.isSaveDisabled', false);
        component.set('v.spinner', false);
        var productId = event.getParam('productId');
        component.set('v.productId', productId);
        helper.getuploadedFiles(component);
    },

    UploadFinished: function (component, event, helper) {
        component.set("v.spinner", true);
        helper.getuploadedFiles(component);

    },

    delFiles: function (component, event, helper) {
        component.set("v.spinner", true);
        var documentId = event.currentTarget.id;
        helper.delUploadedfiles(component, documentId);

    },

    selectImg: function (component, event, helper) {
        var documentId = event.currentTarget.id;
        var Elements = component.find('imgItem');

        for (var i = 0; i < Elements.length; i++) {
            var itemId = Elements[i].getElement().getAttribute('data-id');
            if (itemId != documentId) {
                $A.util.removeClass(Elements[i], "selected");
            } else {
                $A.util.addClass(Elements[i], "selected");
                component.set('v.selectedImg', documentId);
            }
        }

    },
    handleSaving: function (component, event, helper) {
        var Elements = component.find('imgItem');
        var hasClass = false;
        for (var i = 0; i < Elements.length; i++) {
            var itemId = Elements[i].getElement().getAttribute('data-id');
            if ($A.util.hasClass(Elements[i], "selected")) {
                hasClass = true;
            }
        }

        if (hasClass) {
            var sendIdEvent = $A.get("e.c:ImagesAdded");
            sendIdEvent.setParams({
                "imgId": component.get('v.selectedImg')
            });
            sendIdEvent.fire();
        }
        else {
            if (Elements.length >= 2) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You must select main image before saving!",
                    "type": "error"
                });
                toastEvent.fire();
            } else {
                var sendIdEvent = $A.get("e.c:ImagesAdded");
                sendIdEvent.setParams({
                    "imgId": Elements.getElement().getAttribute('data-id')
                });
                sendIdEvent.fire();
            }
        }
    },

})
