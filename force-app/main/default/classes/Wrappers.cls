public with sharing class Wrappers {
    public Wrappers() {

    }
    public class ProductWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String productCode;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String family;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String image;
    }
}
