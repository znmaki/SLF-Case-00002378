@isTest
public with sharing class TestAccountRelatedContactsOnOutOfOffice {
    @isTest
    static void testAccountRelatedContactsOnOutOfOffice() {
        // Crea una cuenta de prueba
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Crea un contacto de prueba relacionado con la cuenta
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        testAccount.Out_of_Office__c = true;
        update testAccount;
    }
}