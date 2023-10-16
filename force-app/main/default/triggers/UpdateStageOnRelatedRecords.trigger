trigger UpdateStageOnRelatedRecords on Opportunity (after update) {
    List<Account> accountToUpdate = new List<Account>();
    Map<Id, Contact> contactsToUpdateMap = new Map<Id, Contact>();
    List<OpportunityContactRole> prueba = new List<OpportunityContactRole>();

    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        if (opp.StageName != oldOpp.StageName) {
            //extraigo datos que necesito y edito el Stage_Opportunity__c
            accountToUpdate.add(new Account(Id = opp.AccountId, Stage_Opportunity__c = opp.StageName));

            prueba = [SELECT Contact.Id, OpportunityId, Contact.Stage_Opportunity__c FROM OpportunityContactRole WHERE OpportunityId = :opp.Id];

            for (OpportunityContactRole oppc : prueba) {
                if (contactsToUpdateMap.containsKey(oppc.ContactId)) {
                    // Si el contacto ya está en el mapa, actualiza su campo "Stage_Opportunity__c"
                    Contact con = contactsToUpdateMap.get(oppc.ContactId);
                    con.Stage_Opportunity__c = opp.StageName;
                } else {
                    // Si el contacto no está en el mapa, crea un nuevo contacto con el campo actualizado
                    Contact con = new Contact(Id = oppc.ContactId, Stage_Opportunity__c = opp.StageName);
                    contactsToUpdateMap.put(oppc.ContactId, con);
                }
            }
        }
    }

    if (!accountToUpdate.isEmpty()) {
        update accountToUpdate;
    }

    if (!contactsToUpdateMap.isEmpty()) {
        update contactsToUpdateMap.values();
    }
}