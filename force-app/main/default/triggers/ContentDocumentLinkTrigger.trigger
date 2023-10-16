trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    List<ContentDocumentLink> cDocument = new List<ContentDocumentLink>();

    for (ContentDocumentLink cdl : Trigger.new) {        

        if (cdl.ShareType == 'V') {            
            ContentDocument cDocumentTitle = [SELECT title, Id FROM ContentDocument WHERE Id = :cdl.ContentDocumentId];

            System.debug('cDocument '+cDocumentTitle);

            if (cDocumentTitle.title.toLowerCase().contains('important')) {
                System.debug('ID DEL ACCOUNT ->'+cdl.LinkedEntityId);

                Account prueba = [SELECT Id, Name from Account WHERE Id = :cdl.LinkedEntityId];
                System.debug('INFO DE LA CUENTA ->'+prueba);            

                List<Contact> relatedContacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :prueba.Id];
                
                for (Contact pruebaC : relatedContacts) {
                    System.debug('Ingreso al file ->');
                    ContentVersion cVersion= new ContentVersion(
                        Title = cDocumentTitle.title,
                        PathOnClient = 'Important/' + cDocumentTitle.title,
                        VersionData = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId LIMIT 1].VersionData,
                        OwnerId = UserInfo.getUserId()
                    );
                    insert cVersion;
                    System.debug(cVersion);

                    Id contentDocumentId = [
                        SELECT ContentDocumentId
                        FROM ContentVersion
                        WHERE Id = :cVersion.Id
                    ].ContentDocumentId;

                    System.debug('contentDocumentId-->' + contentDocumentId);

                    ContentDocumentLink newLink = new ContentDocumentLink(
                        LinkedEntityId = pruebaC.Id,
                        ContentDocumentId = contentDocumentId,
                        ShareType = 'I',
                        Visibility = 'AllUsers'
                    );
                    insert newLink;
                    System.debug('cDLink -> '+newLink+pruebaC.Id);
                }
            }            
        } 
    }
}