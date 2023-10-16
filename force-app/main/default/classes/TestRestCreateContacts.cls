@isTest 
private class TestRestCreateContacts{
    @isTest
    static void testRestCreateContacts() {    
        // Configura la clase de simulación
        Test.setMock(HttpCalloutMock.class, new MockContactHttpCall());
    
        // Llama al método que realiza la llamada HTTP y captura la respuesta
        HttpResponse response = RestCreateContacts.createContactFromRandomUser();
    
        String contentType = response.getHeader('Content-Type');
    
        // Verifica que se haya creado un contacto simulado
        Contact newContact = [SELECT FirstName, LastName, GenderIdentity, Location__c, Birthdate, Email, Phone, Cell__c, Nat__c FROM Contact LIMIT 1];
        
        // Realiza aserciones en los valores del contacto simulado
        System.assertEquals('John', newContact.FirstName);
        System.assertEquals('Doe', newContact.LastName);
        System.assertEquals('(123) 456-7890', newContact.Phone);
    }
}