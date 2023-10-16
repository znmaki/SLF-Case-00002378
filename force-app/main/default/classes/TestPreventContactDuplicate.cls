@isTest
public with sharing class TestPreventContactDuplicate {
    @isTest
    static void testPreventAccountDeletion() {
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'Contact', 
            Email = 'test@gmail.com.invalid',
            Phone = '(51) 768493865'
        );
        insert testContact;

        Contact testContact2 = new Contact(
            FirstName = 'Test 2', 
            LastName = 'Contact',
            Email = 'test@gmail.com.invalid'
        );
        try {
            insert testContact2;
        } catch (DmlException e) {
            // Verificar que se lanzó una excepción debido al contacto duplicado
            System.assert(e.getDmlMessage(0).contains('Your Contact already exists in system'), 'verificando si se agrego');
        }

        Contact testContact3 = new Contact(
            FirstName = 'Test 3', 
            LastName = 'Contact',
            Phone = '(51) 768493865'
        );
        try {
            insert testContact2;
        } catch (DmlException e) {
            // Verificar que se lanzó una excepción debido al contacto duplicado
            System.assert(e.getDmlMessage(0).contains('Your Contact already exists in system'), 'verificando si se agrego');
        }

        Contact testContact4 = new Contact(
            FirstName = 'Test 4', 
            LastName = 'Contact',
            Email = 'test@gmail.com.invalid',
            Phone = '(51) 768493865'
        );
        try {
            insert testContact2;
        } catch (DmlException e) {
            // Verificar que se lanzó una excepción debido al contacto duplicado
            System.assert(e.getDmlMessage(0).contains('Your Contact already exists in system'), 'verificando si se agrego');
        }


    }
}