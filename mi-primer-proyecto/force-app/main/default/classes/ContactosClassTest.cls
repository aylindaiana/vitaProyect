@isTest
private class ContactosClassTest {
    @isTest static void testGetContactByAccount(){
        // Crear datos de prueba
        Account a = new Account(Name='Test Account');
        insert a;

        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName='Juan', LastName='Perez', Email='juan.perez@example.com', AccountId = a.Id),
            new Contact(FirstName='Ana', LastName='Gomez', Email='ana.gomez@example.com', AccountId = a.Id)
        };
        insert contacts;

        // Llamar al método utilitario directamente
        List<Contact> result = ContactosClass.getContactByAccount(a.Id);
        System.assertEquals(2, result.size(), 'Debe devolver los 2 contactos');

        // Probar el endpoint REST usando RestContext
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactosClass/' + String.valueOf(a.Id);
        RestContext.request = req;
        RestContext.response = res;

        // Ejecutar la llamada
        Test.startTest();
        ContactosClass.RestService.getContact();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
        String body = RestContext.response.responseBody.toString();
        System.assert(body.contains('juan.perez@example.com'));
        System.assert(body.contains('ana.gomez@example.com'));
    }
}
