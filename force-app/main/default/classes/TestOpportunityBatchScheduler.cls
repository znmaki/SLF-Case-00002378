@isTest
private class TestOpportunityBatchScheduler {
    @isTest
    static void testBatchScheduling() {
        // Crea tu data de prueba, oportunidades, cuentas, productos, etc.
        List<Opportunity> opportunities = new List<Opportunity>();

        Account testAccount = new Account(Name = 'Test Account', Email__c = 'cristhianpoolop@gmail.com');
        insert testAccount;

        Product2 testProduct = new Product2(Name = 'Magazine', IsActive = true);
        insert testProduct;

        for (Integer i = 0; i < 10; i++) {
            opportunities.add(new Opportunity(Name = 'Test Opportunity ' + i, StageName = 'Prospecting', Amount = 20000, AccountId = testAccount.Id, CloseDate = Date.today().addDays(7)));
        }
        insert opportunities;

        // Programa el trabajo de batch
        String jobName = 'Opportunity Batch Job';
        String cronExpression = '0 0 2 * * ?'; // Ejecuta a las 2:00 AM todos los días

        Test.startTest();
        String jobId = System.schedule(jobName, cronExpression, new OpportunityBatchScheduler());
        Test.stopTest();

        
        System.assertNotEquals(null, jobId, 'El batch no se programó correctamente.');
    }
}