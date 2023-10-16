@isTest
public with sharing class TestOpportunityEmailAccUser {
    static testMethod void testOpportunityEmailAccUser() {
        // Crea un registro de prueba de User con un correo electrónico válido
        /* User testUser = new User(Name = 'Test User', Email = 'cristhianpoolop@gmail.com'); */

        // Crea un registro de prueba de Account con un correo electrónico válido
        Account testAccount = new Account(Name = 'Test Account', Email__c = 'cristhianpoolop@gmail.com');
        insert testAccount;

        // Crea un registro de prueba de producto 'Magazine'
        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(7),
            Amount = 20000,
            AccountId = testAccount.Id
        );
        insert testOpportunity;
    }
}