@isTest
public with sharing class TestNotifyContactsByFileManagement {
    @isTest
    static void testNotifyContactsByFile() {

        Account testAccount = new Account(Name = 'Test Account', Email__c = 'test@gmail.com.invalid');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'Contact', 
            Email = 'cristhianpoolop@gmail.com.invalid',
            Phone = '(51) 768493865',
            AccountId = testAccount.Id
        );
        insert testContact;

        Test.startTest();
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
        ContentVersion cVersion = new ContentVersion();
        cVersion.Title = 'Important';
        cVersion.PathOnClient = cVersion.title + '.txt';
        cVersion.VersionData = bodyBlob;
        cVersion.origin = 'H';
        insert cVersion;

        Id cVDcoument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cVersion.Id LIMIT 1].contentDocumentId;

        ContentDocumentLink cDocLinkAccount = new ContentDocumentLink();
        cDocLinkAccount.LinkedEntityId = testAccount.Id;
        cDocLinkAccount.ContentDocumentId = cVDcoument;
        cDocLinkAccount.ShareType = 'V';
        cDocLinkAccount.Visibility = 'AllUsers';
        insert cDocLinkAccount;

        ContentDocument cDocSelect = [SELECT id, title FROM ContentDocument WHERE id = :cVDcoument LIMIT 1];
        
        delete cDocSelect;
        Test.stopTest();
    }
}