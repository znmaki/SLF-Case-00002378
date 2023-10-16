public with sharing class OpportunitySchedule implements Schedulable  {
    public void execute(SchedulableContext context) {
        // Ejecutar el proceso por lotes para actualizar el campo "closing date approaching?"
        OpportunityBatch batch = new OpportunityBatch();
        Database.executeBatch(batch);
    }
}