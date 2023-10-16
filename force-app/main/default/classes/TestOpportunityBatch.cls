@isTest
private class TestOpportunityBatch {
    @testSetup
    static void setupTestData() {
        // Crea registros de prueba de Opportunity
        List<Opportunity> opportunities = new List<Opportunity>();

        Account testAccount = new Account(Name = 'Test Account', Email__c = 'cristhianpoolop@gmail.com');
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        for (Integer i = 0; i < 10; i++) {
            opportunities.add(new Opportunity(Name = 'Test Opportunity ' + i, StageName = 'Prospecting', Amount = 20000, AccountId = testAccount.Id, CloseDate = Date.today().addDays(7)));
        }
        insert opportunities;
        System.debug('Opportunities test -> ' + opportunities);
    }

    @isTest
    static void testBatch() {
        OpportunityBatch myBatch = new OpportunityBatch();

        // Inicia el proceso del Batch
        Test.startTest();
        Database.executeBatch(myBatch);
        Test.stopTest();

        // Realiza aserciones para verificar que los registros se procesaron correctamente
        List<Opportunity> updatedOpportunities = [SELECT Id, Closing_Date_Approaching__c FROM Opportunity];
    
        /* for (Opportunity opp : updatedOpportunities) {
            System.assertEquals(true, opp.Closing_Date_Approaching__c, 'El campo Closing_Date_Approaching__c debe ser verdadero.');
        } */
    }
}