@isTest
public with sharing class TestUpdateStageOnRelatedRecords {
    static testMethod void testTrigger() {
        // Crea una cuenta de prueba
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Crea un contacto de prueba relacionado con la cuenta
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        // Crea una oportunidad de prueba relacionada con la cuenta y el contacto
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Qualification', CloseDate = Date.today(), AccountId = testAccount.Id);
        insert testOpportunity;

        // Asocia el contacto a la oportunidad mediante OpportunityContactRole
        OpportunityContactRole testOppContactRole = new OpportunityContactRole(ContactId = testContact.Id, OpportunityId = testOpportunity.Id);
        insert testOppContactRole;

        // Cambia el StageName de la oportunidad
        testOpportunity.StageName = 'Needs Analysis';
        update testOpportunity;

        // Recarga los registros actualizados
        testAccount = [SELECT Stage_Opportunity__c FROM Account WHERE Id = :testAccount.Id];
        testContact = [SELECT Stage_Opportunity__c FROM Contact WHERE Id = :testContact.Id];

        // Verifica que los campos Stage_Opportunity__c se hayan actualizado correctamente
        System.assertEquals('Needs Analysis', testAccount.Stage_Opportunity__c);
        System.assertEquals('Needs Analysis', testContact.Stage_Opportunity__c);
    }
}