trigger PreventContactDuplicate on Contact (before insert) {
    ContactTriggerHandler.handleContactDuplicate(Trigger.new);
}