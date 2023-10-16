@isTest(seeAllData=false)
public with sharing class TestOpportunityClosedWonEmail {
    @isTest
    static void testOpportunityClosedWonEmail() {
        // Crea un registro de prueba de Account con un correo electrónico válido
        Account testAccount = new Account(Name = 'Test Account', Email__c = 'cristhianpoolop@gmail.com');
        insert testAccount;

        // Crea un registro de prueba de producto 'Magazine'
        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        // Crea un registro de prueba de Opportunity relacionado con la cuenta
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',  // Asegúrate de que el StageName inicial no sea "Closed Won"
            CloseDate = Date.today().addDays(30),
            Amount = 20000,
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        // Cambia el StageName de la Opportunity a "Closed Won" (esto debe activar el trigger)
        testOpportunity.StageName = 'Closed Won';
        update testOpportunity;

        // Realiza una consulta para verificar si se envió un correo electrónico al Account
        EmailMessage[] sentEmails = [SELECT Id, Subject FROM EmailMessage WHERE RelatedToId = :testAccount.Id];

        // Verifica si se envió un correo electrónico
        //System.assertEquals(1, sentEmails.size(), 'Se esperaba que se enviara un correo electrónico.');

        // Verifica el asunto del correo electrónico enviado
        //System.assertEquals('Opportunity Closed Won', sentEmails[0].Subject, 'Asunto del correo electrónico incorrecto.');
    }
}