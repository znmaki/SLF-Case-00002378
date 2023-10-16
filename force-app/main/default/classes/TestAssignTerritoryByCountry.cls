@isTest
public with sharing class TestAssignTerritoryByCountry {
    @isTest
    static void  triggerTestAssignTerritoryByCountry() {
        Lead leadTest = new Lead (
            FirstName = 'Test',
            LastName = 'Case 00002365',
            Company = '7Up',
            Country = 'United States',
            State = 'California'
        );
        insert leadTest;

        Lead leadTestNull = new Lead (
            FirstName = 'Test 02',
            LastName = 'Case 00002365 02',
            Company = '7Up',
            Country = 'Canada',
            State = 'Manitoba'
        );
        insert leadTestNull;

        Lead assertLead = [SELECT Territory__c FROM Lead WHERE FirstName = 'Test' AND LastName = 'Case 00002365'];
        Lead assertLeadNull = [SELECT Territory__c FROM Lead WHERE FirstName = 'Test 02' AND LastName = 'Case 00002365 02'];

        System.debug('Prueba 1'+assertLead);
        System.debug('Prueba 2'+assertLead.Territory__c);

        System.assertEquals(assertLead.Territory__c, 'Pacific', 'El territorio no coincide');
        System.assertEquals(assertLeadNull.Territory__c, null, 'El territorio no coincide');
    }
}