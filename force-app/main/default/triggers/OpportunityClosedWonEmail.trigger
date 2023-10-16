trigger OpportunityClosedWonEmail on Opportunity (before insert, before update) {
    List<Id> accountIdsWithClosedWonOpportunities = new List<Id>();
    List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
    
    for (Opportunity opp : Trigger.new) {
        // Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        
        // Verifica si el campo 'StageName' cambió a 'Closed Won'
        //if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) {
        if (opp.StageName == 'Closed Won') {
            accountIdsWithClosedWonOpportunities.add(opp.AccountId);
            opportunitiesToUpdate.add(opp);
        }
    }
    
    if (!accountIdsWithClosedWonOpportunities.isEmpty()) {
        Map<Id, Account> accountsWithEmail = new Map<Id, Account>([SELECT Id, Email__c FROM Account WHERE Id IN :accountIdsWithClosedWonOpportunities]);
        
        for (Opportunity opp : opportunitiesToUpdate) {
            Account account = accountsWithEmail.get(opp.AccountId);
            
            // Verifica si el Account tiene un correo electrónico registrado
            if (account != null && String.isNotBlank(account.Email__c)) {
                String emailBody = 'Estimado, la Opportunity ' + opp.Name + ' ha sido marcada como "Closed Won".';
                EmailManager.sendMail(account.Email__c, 'Opportunity Closed Won', emailBody);
            }
        }
        
    }
}