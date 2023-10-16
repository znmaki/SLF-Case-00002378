trigger RevenueLevelOnAmountOfOpportunities on Opportunity (before insert, before update) {
    for (Opportunity opp : Trigger.new) {        
        // Realiza la lógica para asignar un valor en función de "Amount"
        if (opp.Amount >= 6000) {
            opp.Revenue_Level__c = 'High';
        } else if (opp.Amount >= 2000) {
            opp.Revenue_Level__c = 'Medium';
        } else {
            opp.Revenue_Level__c = 'LOW';
        }
    }
}