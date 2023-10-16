public with sharing class BatchOpportunityManagerAssignManager implements Database.Batchable<sObject>, Database.Stateful{
    public Integer recordsProcessed = 0;
    public Opportunity oppSelect = new Opportunity();

    public Database.QueryLocator start(Database.BatchableContext context) {
        System.debug('INGRESO -> ');

        String query = 'SELECT id, name, Manager_Type__c, Master_Detail_Opportunity__c, Manager__c FROM Opportunity_Manager__c ';
        System.debug('oppMBatch -> ' + query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Opportunity_Manager__c> scope) {
                
        System.debug('Lista de oppM -> ' + scope);        
        System.debug('Cantidad en el scope -> ' + scope.size());

        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity_Manager__c oppM : scope) {
            opportunityIds.add(oppM.Master_Detail_Opportunity__c);
        }
        Map<Id, Opportunity> oppMapToUpdate = new Map<Id, Opportunity>([SELECT Id, Name, National_Sales_Manager__c, Operation_Sales_Manager__c, Sales_Manager__c FROM Opportunity WHERE Id IN :opportunityIds]);

        for (Opportunity_Manager__c oppM : scope) {
            System.debug('Opp encontradas (no duplicadas) -> ' + oppMapToUpdate);
            Opportunity relatedOpp = oppMapToUpdate.get(oppM.Master_Detail_Opportunity__c);

            if (relatedOpp != null) {
                if (oppM.Manager_Type__c == 'National Sales') {
                    relatedOpp.National_Sales_Manager__c = oppM.Manager__c;
                    System.debug('National Sales -> ' + relatedOpp);
                }else if (oppM.Manager_Type__c == 'Operation Sales') {
                    relatedOpp.Operation_Sales_Manager__c = oppM.Manager__c;
                    System.debug('Operation Sales -> ' + relatedOpp);
                } else if (oppM.Manager_Type__c == 'Sales Manager') {
                    relatedOpp.Sales_Manager__c = oppM.Manager__c;
                    System.debug('Sales Manager ->' + relatedOpp);
                }
            }

            recordsProcessed = recordsProcessed + 1;
        }
        System.debug('Opp Actualizadas -> ' + oppMapToUpdate);
        update oppMapToUpdate.values();
    }

    public void finish(Database.BatchableContext context) {
        // Tarea de finalización
        System.debug(recordsProcessed + ' records processed.');
    }
}