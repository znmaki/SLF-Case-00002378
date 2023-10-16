@isTest
public with sharing class TestAmountOpportunityHandler {
    @isTest
    static void TestAmountOpportunityHandler() {
        Account testAccount = new Account(
            Name = 'Test Account', 
            Email__c = 'cristhianpoolop@gmail.com.invalid',
            Total_Amount__c = 0
        );
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(10),
            Amount = 20000,
            AccountId = testAccount.Id
        );

        insert testOpportunity;
        Account accountOppInsert = [SELECT Total_Amount__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(accountOppInsert.Total_Amount__c, testOpportunity.Amount, 'Los valores no son iguales al ingresar la Opp');

        testOpportunity.Amount = 25000;
        update testOpportunity;
        Account accountOppUpdate = [SELECT Total_Amount__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(accountOppUpdate.Total_Amount__c, testOpportunity.Amount, 'Los valores no son iguales al editar la Opp');

        delete testOpportunity;
        Account accountOppDelete = [SELECT Total_Amount__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(accountOppDelete.Total_Amount__c, 0, 'Los valores no son iguales al eliminar la Opp');
    }
}