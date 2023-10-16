public with sharing class ScheduleOpportunityManagerAssignManager implements Schedulable {
    public void execute(SchedulableContext context) {
        BatchOpportunityManagerAssignManager batch = new BatchOpportunityManagerAssignManager();
        Database.executeBatch(batch);
    }
}