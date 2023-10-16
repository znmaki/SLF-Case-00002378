public with sharing class AccountTriggerHandler {
    public static void handleAccountDeletion(List<Account> deletedAccounts) {
        Set<Id> accountIdsWithClosedWonOpportunities = new Set<Id>();

        // Buscar Opportunities asociadas a los Accounts que se van a eliminar
        for (Account acc : deletedAccounts) {
            List<Opportunity> closedWonOpportunities = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id AND StageName = 'Closed Won' LIMIT 1];
            if (!closedWonOpportunities.isEmpty()) {
                accountIdsWithClosedWonOpportunities.add(acc.Id);
            }
        }

        if (!accountIdsWithClosedWonOpportunities.isEmpty()) {
            // Si se encuentran Opportunities Closed Won, mostrar un mensaje de error y evitar la eliminación
            for (Account acc : deletedAccounts) {
                if (accountIdsWithClosedWonOpportunities.contains(acc.Id)) {
                    acc.addError('Account cannot be deleted because it has opportunities (Closed Won) associated with it.');
                }
            }
        }
    }
}