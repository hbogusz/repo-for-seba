({
    doInit: function (cmp) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        cmp.set("v.imgId", "/resource/1656320785000/addImage");
    },
    handleSuccess: function (component, event, helper) {
        var isImgAdded = component.get('v.imgField') ? true : false;
        var payload = event.getParams().response;
        component.set('v.recordId', payload.id);
        var sendIdEvent = $A.get("e.c:ProductCreated");
        sendIdEvent.setParams({
            "productId": payload.id
        });
        sendIdEvent.fire();
    },
    handleCancel: function (component, event, helper) {
        $A.get("e.c:ProductCreated").fire();
    },
    handleError: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": event.getParam("message"),
            "type": "error"
        });
        toastEvent.fire();
    },
    manageImg: function (component, event, helper) {
        var modalBody;
        $A.createComponent("c:ImgManager", {},
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    var modalPromise = component.find('overlayImg').showCustomModal({
                        header: "Image Manager",
                        body: modalBody,
                        showCloseButton: true
                    });
                    component.set("v.modalPromise", modalPromise);
                }
            });
    },
    closeModal: function (component, event, helper) {
        component.get('v.modalPromise').then(function (modal) {
            modal.close();
        });
        var mainImg = event.getParam('imgId');
        component.set('v.imgId', '/sfc/servlet.shepherd/document/download/' + mainImg);
        component.set('v.imgField', '/sfc/servlet.shepherd/document/download/' + mainImg);
    },
    handleSaving: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        if (recordId != undefined) {
            if (component.get('v.price') == undefined) {
                var noPriceEvent = $A.get("e.force:showToast");
                noPriceEvent.setParams({
                    "title": "Error!",
                    "message": 'You should add price to be able to save product',
                    "type": "error"
                });
                noPriceEvent.fire();
            } else {
                helper.addPricebookEntry(component);
                var navigation = component.find('navigation');
                setTimeout(() => {
                    navigation.navigate({
                        'type': 'standard__recordPage',
                        'attributes': {
                            'objectApiName': 'Product2',
                            'recordId': component.get('v.recordId'),
                            'actionName': 'view'
                        }
                    });
                }, "1000")
            }
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'You should add some image to be able to save product',
                "type": "error"
            });
            toastEvent.fire();
        }

    },
    handleSavingNew: function (component, event, helper) {
        helper.addPricebookEntry(component);
        setTimeout(() => {
            $A.get('e.force:refreshView').fire();
        }, "1000")
    },


})