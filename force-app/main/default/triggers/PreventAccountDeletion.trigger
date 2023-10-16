trigger PreventAccountDeletion on Account (before delete) {
    AccountTriggerHandler.handleAccountDeletion(Trigger.old);
}