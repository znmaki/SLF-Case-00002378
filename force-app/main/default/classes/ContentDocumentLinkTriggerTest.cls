@isTest
public class ContentDocumentLinkTriggerTest {
    @isTest
    static void testTrigger() {
        // Crea datos de prueba, como cuentas y contactos
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
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

        Test.stopTest();
    }
}
