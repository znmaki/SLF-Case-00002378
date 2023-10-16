trigger CreateContactNotifyEmail on Contact (after insert) {
    EmailHandler.notifyUserForNewContact(Trigger.new);
}