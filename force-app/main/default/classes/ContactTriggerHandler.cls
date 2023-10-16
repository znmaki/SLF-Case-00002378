public with sharing class ContactTriggerHandler {
    public static void handleContactDuplicate(List<Contact> duplicateContact) {

        for (Contact con : duplicateContact) {            
            List<Contact> duplicatePhoneEmail = [SELECT Id, Phone, Email FROM Contact WHERE Phone = :con.Phone OR Email = :con.Email];

            if (!duplicatePhoneEmail.isEmpty()) {
                con.addError('Your Contact already exists in system');
            }
        }
    }
}