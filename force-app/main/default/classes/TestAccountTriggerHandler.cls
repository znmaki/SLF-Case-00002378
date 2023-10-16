@isTest
public with sharing class TestAccountTriggerHandler {
    @isTest
    static void testAccountHandler() {
        Account testAccount = new Account(
            Name = 'Test Account', 
            Email__c = 'cristhianpoolop@gmail.com.invalid'
        );
        insert testAccount;

        Account testAccount2 = new Account(
            Name = 'Test Account 2', 
            Email__c = 'cristhianpoolop@gmail.com.invalid'
        );
        insert testAccount2;

        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(10),
            Amount = 20000,
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        delete testAccount;
        delete testAccount2;

        System.assert(!testAccount.IsDeleted, 'Verificar que la cuenta 1 no se ha eliminado');
        System.assert(testAccount2.IsDeleted, 'Verificar que la cuenta 2 se ha marcado como eliminada');
    }
}