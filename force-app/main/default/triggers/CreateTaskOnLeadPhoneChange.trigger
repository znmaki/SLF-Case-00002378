trigger CreateTaskOnLeadPhoneChange on Lead (after insert, after update) {
    List<Task> tasksToInsert = new List<Task>();

    for (Lead lead : Trigger.new) {
        if (!String.isBlank(lead.Phone) && (Trigger.isInsert || lead.Phone != Trigger.oldMap.get(lead.Id).Phone)) {
            System.debug('Lead Name: ' + lead.Name);
            System.debug('Lead Phone: ' + lead.Phone);

            Task newTask = new Task();
            newTask.Subject = 'Call ' + lead.FirstName + ' ' + lead.LastName + ' to his phone ' + lead.Phone;
            newTask.OwnerId = lead.OwnerId;
            newTask.ActivityDate = Date.today();
            newTask.Status = 'Not Started';
            tasksToInsert.add(newTask);
        }
    }

    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
}