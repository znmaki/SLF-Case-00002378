public with sharing class OpportunityCrudForAccount {
    public static void OpportunityCreate(List<Opportunity> opportunityTrigger) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Opportunity opp : opportunityTrigger) {
            List<Account> listAccounts = [SELECT Id, Total_Amount__c FROM Account WHERE Id = :opp.AccountId];

            System.debug('antes'+listAccounts);

            for (Account acc : listAccounts) {
                acc.Total_Amount__c += opp.Amount;
                accountsToUpdate.add(acc);
            }

            System.debug('despues'+accountsToUpdate);

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }

    public static void OpportunityUpdate(List<Opportunity> opportunityBefore, List<Opportunity> opportunityAfter) {
        List<Account> accountsToUpdate = new List<Account>();

        System.debug('Antes ->'+ opportunityBefore);
        System.debug('Despues ->'+ opportunityAfter);

        for (Opportunity oppAfter : opportunityAfter) {
            List<Account> listAccounts = [SELECT Id, Total_Amount__c FROM Account WHERE Id = :oppAfter.AccountId];

            for (Account acc : listAccounts) {
                acc.Total_Amount__c += oppAfter.Amount;
                acc.Total_Amount__c -= opportunityBefore[0].Amount;
                accountsToUpdate.add(acc);
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }

    public static void OpportunityDetele(List<Opportunity> opportunityTrigger) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Opportunity opp : opportunityTrigger) {
            List<Account> listAccounts = [SELECT Id, Total_Amount__c FROM Account WHERE Id = :opp.AccountId];

            for (Account acc : listAccounts) {
                acc.Total_Amount__c -= opp.Amount;
                accountsToUpdate.add(acc);
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}