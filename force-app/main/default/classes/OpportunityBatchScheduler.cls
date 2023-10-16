public with sharing class OpportunityBatchScheduler implements Schedulable{
    public void execute(SchedulableContext ctx) {
        OpportunityBatch myBatch = new OpportunityBatch();
        Database.executeBatch(myBatch);
    }
}