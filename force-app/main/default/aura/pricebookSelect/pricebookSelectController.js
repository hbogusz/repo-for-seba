({
    onInit: function (component, event, helper) {
        var action = component.get("c.getStandardPricebookId");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.standardId", result);
            }
        });
        $A.enqueueAction(action);
        component.set('v.spinner', false);
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
            { label: 'Expiration Date', fieldName: 'Expiration_Date__c', type: 'date' },
            { label: 'Active', fieldName: 'IsActive', type: 'boolean' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.loadPricebooks(component);

    },
    onRowAction: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("id");
        var pricebookName = event.currentTarget.getAttribute("data-name");
        component.find('rowTable').forEach(function(row) {
            $A.util.removeClass(row.getElement(), 'active');
        });
        event.currentTarget.className += " active";
        var event = $A.get("e.c:PricebookSelected");
        event.setParams({
            "selectedId": recordId,
            "name": pricebookName
        });
        event.fire();
        
    },
    openModalNew: function (component, event, helper) {
        var modalBody;
        $A.createComponent("c:createPricebook", {},
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    var modalPromise = component.find('overlayNew').showCustomModal({
                        header: "Create Price Book",
                        body: modalBody,
                        showCloseButton: true
                    });
                    component.set("v.modalPromise", modalPromise);
                }
            });
    },
    edit: function (component, event, helper) {
        var modalBody;
        var recordId = event.currentTarget.getAttribute("id");
        var isNotStandard = recordId != component.get("v.standardId") ? true : false;
        $A.createComponent("c:createPricebook", 
        {
            "recordId": recordId,
            "isNotStandard": isNotStandard
        },
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    var modalPromise = component.find('overlayNew').showCustomModal({
                        header: "Edit Price Book",
                        body: modalBody,
                        showCloseButton: true
                    });
                    component.set("v.modalPromise", modalPromise);
                }
            });
    },
    delete: function (component, event, helper) {
        var recordId = event.currentTarget.getAttribute("id");
        helper.handleDelete(component, recordId);
    },
    onEdited: function (component, event, helper) {
        helper.loadPricebooks(component);
        component.get('v.modalPromise').then(function (modal) {
            modal.close();
        });
    },
})