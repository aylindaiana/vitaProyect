public with sharing class ContactosClass {

    /**
     *
     * Este método expone un endpoint REST simple para uso interno u Oauth2.
     * Uso (ejemplo): /services/apexrest/ContactosClass?accountId=001... 
     */
    @RestResource(urlMapping='/ContactosClass/*')
    global with sharing class RestService {
        @HttpGet
        global static void getContact() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;

            String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            // allow query param accountId as well
            if(String.isBlank(accountId) || accountId == 'ContactosClass'){
                accountId = req.params.get('accountId');
            }

            if(String.isBlank(accountId)){
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error":"Missing accountId parameter"}');
                return;
            }

            try{
                List<Contact> contacts = getContactByAccount(Id.valueOf(accountId));
                // Convert to JSON and return
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(JSON.serialize(contacts));
            } catch(Exception e){
                res.statusCode = 500;
                res.responseBody = Blob.valueOf(JSON.serializePretty(new Map<String,String>{'error'=>e.getMessage()}));
            }
        }
    }

    /**
     * Método utilitario que obtiene contactos por Account Id.
     * @param accountId Id de la Account
     * @return Lista de Contact
     */
    public static List<Contact> getContactByAccount(Id accountId){
        if(accountId == null) return new List<Contact>();
        return [SELECT Id, FirstName, LastName, Email, Phone, AccountId FROM Contact WHERE AccountId = :accountId];
    }
}
