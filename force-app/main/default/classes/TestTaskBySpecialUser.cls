@isTest
public with sharing class TestTaskBySpecialUser {
    @isTest
    static void testTaskBySpecialUser() {
        User testUser = new User(
            LastName = 'Test', 
            Alias = 'teste', 
            Email = 'teste@gmail.com.invalid', 
            Username = 'teste@gmail.com.invalid', 
            CommunityNickname = 'User16957549545834176456',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = '00e8a000001H7g0AAC',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'Contact', 
            AccountId = testAccount.Id
        );
        insert testContact;

        Task testTask = new Task(
            Subject = 'Test',
            WhoId = testContact.Id
        );
        insert testTask;

    }
}