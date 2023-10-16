trigger OpportunityManagerAssignManager on Opportunity_Manager__c (after insert) {
    List<Opportunity> oppToUpdate = new List<Opportunity>();    

    for (Opportunity_Manager__c oppM : Trigger.new) {
        Opportunity oppSelect = [SELECT Id FROM Opportunity WHERE Id = :oppM.Master_Detail_Opportunity__c];

        System.debug('Opportunity -> ' + oppSelect);

        User userSelect = [SELECT Id FROM User WHERE Id = :oppM.Manager__c];

        System.debug('User -> ' + userSelect);

        if (oppM.Manager_Type__c == 'National Sales') {
            oppSelect.National_Sales_Manager__c = oppM.Manager__c;
            oppToUpdate.add(oppSelect);
        }else if (oppM.Manager_Type__c == 'Operation Sales') {
            oppSelect.Operation_Sales_Manager__c = oppM.Manager__c;
            oppToUpdate.add(oppSelect);
        } else if (oppM.Manager_Type__c == 'Sales Manager') {
            oppSelect.Sales_Manager__c = oppM.Manager__c;
            oppToUpdate.add(oppSelect);
        }
    }

    if (!oppToUpdate.isEmpty()) {
        update oppToUpdate;
    }
}