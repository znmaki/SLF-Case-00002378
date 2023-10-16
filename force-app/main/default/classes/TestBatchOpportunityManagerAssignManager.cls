@isTest
private class TestBatchOpportunityManagerAssignManager {
    @testSetup
    static void setup() {
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

        Opportunity_Manager__c testOppManager2 = new Opportunity_Manager__c(
            Name = 'oppManager2 Test',
            Master_Detail_Opportunity__c = testOpportunity.Id,
            Manager__c = testUser.Id,
            Manager_Type__c = 'Operation Sales'
        );
        insert testOppManager2;

        Opportunity_Manager__c testOppManager3 = new Opportunity_Manager__c(
            Name = 'oppManager3 Test',
            Master_Detail_Opportunity__c = testOpportunity.Id,
            Manager__c = testUser.Id,
            Manager_Type__c = 'Sales Manager'
        );
        insert testOppManager3;
    }
    @isTest static void test(){
        BatchOpportunityManagerAssignManager batch = new BatchOpportunityManagerAssignManager();

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
        
    }
}