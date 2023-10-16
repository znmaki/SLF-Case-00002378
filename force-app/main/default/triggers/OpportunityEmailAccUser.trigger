trigger OpportunityEmailAccUser on Opportunity (after insert) {

    for (Opportunity opp : Trigger.new) {
        User oppUser = [SELECT Id, Name, Email FROM User WHERE Id = :opp.OwnerId];
        System.debug('User relacionado -> ' + oppUser);

        Account oppAccount = [SELECT Id, Name, Email__c FROM Account WHERE Id = :opp.AccountId];
        System.debug('Account relaciona -> ' + oppAccount);

        if (String.isNotBlank(oppUser.Email)) {
            String emailBodyUser = 'Estimado, la Opportunity ' + opp.Name + ' ha sido creado.';
            EmailManager.sendMail(oppUser.Email, 'Opportunity Create', emailBodyUser);
        }
        if (String.isNotBlank(oppAccount.Email__c)) {
            String emailBodyAccount = 'Estimado, la Opportunity ' + opp.Name + ' ha sido creado.';
            EmailManager.sendMail(oppAccount.Email__c, 'Opportunity Create', emailBodyAccount);
        }
    }
}