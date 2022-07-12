public class ImageUploadHandler {
    @AuraEnabled
    public static List<ContentDocument> getFiles(string recordId){ 
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];  
    } 
    @AuraEnabled(Cacheable=true)
    public static List<Wrappers.ImageWrapper> getImages(string recordId){ 
        List<ContentDocument> docs = getFiles(recordId);
        List<Wrappers.ImageWrapper> imagesUrls = new List<Wrappers.ImageWrapper> ();
        for (ContentDocument doc : docs) {
            Wrappers.ImageWrapper wrapper = new Wrappers.ImageWrapper();
            wrapper.id = doc.Id;
            wrapper.url = '/sfc/servlet.shepherd/document/download/' + doc.Id;
            imagesUrls.add(wrapper);
        }
        return imagesUrls;
    } 
    
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  
}
