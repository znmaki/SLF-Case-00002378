public with sharing class EmailHandler {
    public static void notifyUserForNewContact(List<Contact> newContact) {
        List<User> listSystemAdministration = [SELECT Id, Name, ProfileId, Email FROM User WHERE ProfileId = '00e8a000002QBLLAA4'];

        for (Contact con : newContact) {
            for (User us : listSystemAdministration) {
                String subjectUser = 'A new contact was created';
                String emailBodyUser = 'Dear '+ us.Name + ' ,\n' +
                                        'A new contact was created with Name: ' + con.FirstName + ' ' + con.LastName + ' on ' + con.CreatedDate + '. ' +
                                        'Contact your System Administrator if it was not created by you.\n' + 
                                        '\n' +
                                        'Thank You\n' +
                                        'Regards System Administrator.';
                EmailManager.sendMail(us.Email, subjectUser, emailBodyUser);
            }
        }
    }
}