@isTest
public with sharing class TestOpportunityManagerModifications {
    @isTest
    static void testOpportunityManagerModifications() {
        User testUser = new User(
            LastName = 'Test', 
            Alias = 'teste', 
            Email = 'teste@gmail.com.invalid', 
            Username = 'teste@gmail.com.invalid', 
            CommunityNickname = 'User16957549545834176456',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = '00e8a000001H7g0AAC',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Account testAccount = new Account(
            Name = 'Test Account', 
            Email__c = 'cristhianpoolop@gmail.com.invalid'
        );
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 20000,
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Opportunity_Manager__c testOppManager = new Opportunity_Manager__c(
            Name = 'oppManager Test',
            Master_Detail_Opportunity__c = testOpportunity.Id,
            Manager__c = testUser.Id,
            Manager_Type__c = 'National Sales'
        );
        insert testOppManager;

        testOppManager.Manager_Type__c = 'Operation Sales';
        update testOppManager;

        testOppManager.Manager_Type__c = 'Sales Manager';
        update testOppManager;

        testOppManager.Manager_Type__c = 'National Sales';
        update testOppManager;

        delete testOppManager;
        
    }
}