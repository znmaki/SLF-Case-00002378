public with sharing class OpportunityBatch implements Database.Batchable<sObject> {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Consulta las Opportunities con Close Date cercano
        System.debug('ENTRO -> ');
        //Dia actual
        Date today = Date.today();
        String day = String.valueOf(today.day()).leftPad(2, '0');
        String month = String.valueOf(today.month()).leftPad(2, '0');
        String year = String.valueOf(today.year());
        String formattedDate = year + '-' + month + '-' + day;
        //Dia actual + 7 dias
        Date sevenDaysAhead = Date.today().addDays(7);
        String daySeven = String.valueOf(sevenDaysAhead.day()).leftPad(2, '0');
        String monthSeven = String.valueOf(sevenDaysAhead.month()).leftPad(2, '0');
        String yearSeven = String.valueOf(sevenDaysAhead.year());
        String formattedDateSeven = yearSeven + '-' + monthSeven + '-' + daySeven;

        String query = 'SELECT Id, CloseDate FROM Opportunity WHERE CloseDate >= '+ formattedDate + ' AND CloseDate <= ' + formattedDateSeven;
        System.debug('OpportunitiesBatch test -> ' + query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        // Actualiza el campo "closing date approaching?" en las Opportunities
        System.debug(scope);
        for (Opportunity opp : scope) {
            opp.Closing_Date_Approaching__c = true;
            recordsProcessed = 1;
        }
        update scope;
    }

    public void finish(Database.BatchableContext context) {
        // Tarea de finalización
        System.debug(recordsProcessed + ' records processed.');
    }
}