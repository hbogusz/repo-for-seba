({
    onInit : function(component, event, helper) {
        component.set('v.productId', event.getParam('productId'));
        console.log(event.getParam('productId'));
        // helper.getuploadedFiles(component);
    },
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    }
})
