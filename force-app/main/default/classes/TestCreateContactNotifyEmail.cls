@isTest
public with sharing class TestCreateContactNotifyEmail {
    @isTest
    static void testCreateContactNotifyEmail() {

        User testUser = new User(
            LastName = 'Test', 
            Alias = 'teste', 
            Email = 'teste@gmail.com.invalid', 
            Username = 'teste@gmail.com.invalid', 
            CommunityNickname = 'User16957549545834176456',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = '00e8a000002QBLLAA4',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'Contact', 
            Email = 'test@gmail.com.invalid',
            Phone = '(51) 768493865'
        );

        Test.startTest();
        insert testContact;
        Test.stopTest();
        
        // Verificar que el correo electrónico tenga los valores correctos
        List<EmailMessage> sentEmails = [SELECT Id, Subject, ToAddress FROM EmailMessage];
        EmailMessage sentEmail = sentEmails[sentEmails.size() - 1];

        //Ver cuantos usuarios con el rol 'System Administrator' se deberan enviar
        Integer countSystemAdministrator = [SELECT COUNT() FROM User WHERE ProfileId = '00e8a000002QBLLAA4'];

        System.assertEquals(sentEmails.size(), countSystemAdministrator, 'La cantidad de mensajes enviados no son iguales a los usuarios con el rol System Administrator');
        System.assertEquals('A new contact was created', sentEmail.Subject, 'El asunto del correo electrónico es incorrecto.');
        System.assertEquals('teste@gmail.com.invalid', sentEmail.ToAddress, 'La dirección de correo electrónico del destinatario es incorrecta.');

    }
}