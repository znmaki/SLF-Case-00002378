trigger TaskBySpecialUser on Task (after insert) {

    for (Task task : Trigger.new) {
        User userSelect = [SELECT Id, Title FROM User WHERE Id = :task.CreatedById];

        System.debug('userSelect -> ' + userSelect);

        if (userSelect.Title == 'Counselor') {
            System.debug('Si hay');
            if (String.isNotBlank(task.WhoId)) {
                Contact contactSelect = [SELECT Id FROM Contact WHERE Id = :task.WhoId];
                System.debug('Antes -> ' + contactSelect);
                Datetime dateTimeValue = task.CreatedDate;
                Date dateValue = dateTimeValue.date();
                contactSelect.Date_of_recent_task__c = dateValue;
                System.debug('Despues -> ' + contactSelect);
                update contactSelect;
            }
        }else {
            task.Subject.addError('You do not have permission to create this task. You must have the title "Counselor" in your user profile.');
        }
    }
}