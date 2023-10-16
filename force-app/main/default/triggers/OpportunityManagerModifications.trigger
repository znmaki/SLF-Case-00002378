trigger OpportunityManagerModifications on Opportunity_Manager__c (after delete, after update) {
    List<Opportunity> oppToUpdate = new List<Opportunity>();

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            for (Opportunity_Manager__c oppMU : Trigger.new) {
                Opportunity oppSelect = [SELECT Id FROM Opportunity WHERE Id = :oppMU.Master_Detail_Opportunity__c];
                Opportunity_Manager__c oldOppMU = Trigger.oldMap.get(oppMU.Id);

                if (oppMU.Manager_Type__c != oldOppMU.Manager_Type__c) {
                    if (oppMU.Manager_Type__c == 'National Sales') {
                        oppSelect.National_Sales_Manager__c = oppMU.Manager__c;
                        oppToUpdate.add(oppSelect);
                    }else if (oppMU.Manager_Type__c == 'Operation Sales') {
                        oppSelect.Operation_Sales_Manager__c = oppMU.Manager__c;
                        oppToUpdate.add(oppSelect);
                    } else if (oppMU.Manager_Type__c == 'Sales Manager') {
                        oppSelect.Sales_Manager__c = oppMU.Manager__c;
                        oppToUpdate.add(oppSelect);
                    }
                }
            }
        } else if (Trigger.isDelete) {
            for (Opportunity_Manager__c oppMD : Trigger.old) {
                Opportunity oppSelect = [SELECT Id FROM Opportunity WHERE Id = :oppMD.Master_Detail_Opportunity__c];

                // Limpia el valor del campo relacionado en la oportunidad
                if (oppMD.Manager_Type__c == 'National Sales') {
                    oppSelect.National_Sales_Manager__c = null;
                    oppToUpdate.add(oppSelect);
                } else if (oppMD.Manager_Type__c == 'Operation Sales') {
                    oppSelect.Operation_Sales_Manager__c = null;
                    oppToUpdate.add(oppSelect);
                } else if (oppMD.Manager_Type__c == 'Sales Manager') {
                    oppSelect.Sales_Manager__c = null;
                    oppToUpdate.add(oppSelect);
                }
            }
        }
    }

    if (!oppToUpdate.isEmpty()) {
        update oppToUpdate;
    }
}