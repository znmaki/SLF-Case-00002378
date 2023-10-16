trigger AccountRelatedContactsOnOutOfOffice on Account (after update, after insert) {
    List<Contact> contactsToUpdate = new List<Contact>();

    for (Account acc : Trigger.new) {
        List<Contact> lisContact = [SELECT Id, is_Account_Out_of_Office__c FROM Contact WHERE AccountId = :acc.Id];

        System.debug('Lista de Contactos-> '+lisContact);

        for (Contact con : lisContact) {
            con.is_Account_Out_of_Office__c = acc.Out_of_Office__c;

            contactsToUpdate.add(con);
        }
    }    

    if (!contactsToUpdate.isEmpty()) {
        update contactsToUpdate;
    }
}