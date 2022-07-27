({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            { label: 'Product Name', fieldName: 'productName', type: 'text', editable: false, typeAttributes: { required: true } },
            { label: 'Product Code', fieldName: 'productCode', type: 'text', editable: false, cellAttributes: { alignment: 'center' }, initialWidth: 130  },
            { label: 'Family', fieldName: 'family', type: 'text', editable: false, cellAttributes: { alignment: 'center' } },
            { label: 'Price', fieldName: 'unitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD' }, editable: true, typeAttributes: { required: true }, cellAttributes: { alignment: 'center' } }
        ]);
    },
    onPricebookSelect: function (component, event, helper) {
        let pricebookId = event.getParam('selectedId');
        component.set("v.pricebookId", pricebookId);
        component.set("v.pricebookName", event.getParam('name'));
        helper.loadPricebookItems(component, pricebookId);
    },
    showDiscountModal: function (component, event, helper) {
        var modalBody;
        $A.createComponent("c:DiscountModal", 
        {
            "pricebookId": component.get("v.pricebookId"),
            "pricebookName": component.get("v.pricebookName")
        },
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   var modalPromise = component.find('overlayLib').showCustomModal({
                       header: "Discount Manager",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "slds-modal_medium"
                   })
               }
               component.set("v.modalPromise", modalPromise);
           });
    },
    closeModal : function(component, event, helper) {
        helper.loadPricebookItems(component, component.get("v.pricebookId"));
        component.get('v.modalPromise').then(function (modal) {
            modal.close();
        });
    },
    updatePricebookEntriesForSelected: function (component, event, helper) {
        let pricebookId = component.get("v.pricebookId");
        let lines = [];
        lines = component.find('linesTable').getSelectedRows();
        let discount = component.get("v.discount");
        helper.updatePricebookEntries(component, pricebookId, lines, discount);
    },
    handleSaveEdition: function (component, event, helper) {
        let pricebookId = component.get("v.pricebookId");
        let draftValues = event.getParam('draftValues');
        helper.saveEdition(component,pricebookId, draftValues);
    },
    onPricebookDelete: function (component, event, helper) {
        component.set("v.noResult", true);
    },
})