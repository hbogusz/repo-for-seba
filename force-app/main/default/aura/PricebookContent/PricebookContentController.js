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
        helper.loadPricebookItems(component, pricebookId);
    },
    setDiscount: function (component, event, helper) {
        component.set('v.showDiscount', true);
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
