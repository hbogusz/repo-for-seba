({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Product Name', fieldName: 'productName', type: 'text', editable: false, typeAttributes: { required: true }},
            {label: 'Product Code', fieldName: 'productCode', type: 'text', editable: false },
            {label: 'Family', fieldName: 'family', type: 'text', editable: false },
            {label: 'Price', fieldName: 'unitPrice', type: 'currency', typeAttributes: { currencyCode: 'USD'}, editable: true, typeAttributes: { required: true } },
        ]);
    },
    onPricebookSelect : function(component, event, helper) {
        let pricebookId = event.getParam( 'selectedId' );
        helper.loadPricebookItems(component,pricebookId);
    },
    setDiscount: function(component, event, helper) {
        component.set( 'v.showDiscount', true );
    }

})
