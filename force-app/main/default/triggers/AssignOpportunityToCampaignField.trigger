trigger AssignOpportunityToCampaignField on Opportunity (before insert, before update) {
    for (Opportunity opp : Trigger.new) {
        // Realiza la lógica para asignar un valor en función de "Amount"
        if (opp.Revenue_Level__c == 'High') {
            opp.Campaign__c = 'Alpha';
        } else if (opp.Revenue_Level__c == 'Medium') {
            opp.Campaign__c = 'Moderate';
        } else if (opp.Revenue_Level__c == 'Low') {
            opp.Campaign__c = 'Considerable';
        }
    }
}