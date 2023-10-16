public with sharing class ContentDocumentLinkHandler {
    @future
    public static void processContentDocumentLinks(Set<Id> contentDocumentIds) {
        // Consulta ContentDocumentLink después del período de espera.
        List<ContentDocumentLink> cdLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentIds];
        System.debug('ContentDocumentLink ->' + cdLinks);        

        List<ContentDocumentLink> accountLinks = new List<ContentDocumentLink>();
        List<ContentDocumentLink> contactLink = new List<ContentDocumentLink>();

        for (ContentDocumentLink cdLink : cdLinks) {
            if (cdLink.LinkedEntityId.getSObjectType() == Account.SObjectType) {
                accountLinks.add(cdLink);
            }
        }

        System.debug('Account Links -> ' + accountLinks);

        if (!accountLinks.isEmpty()) {
            List<Contact> contacts = [SELECT Id, Name, AccountId, Email FROM Contact WHERE AccountId = :accountLinks[0].LinkedEntityId];
            System.debug('Contacts for Account'+contacts);

            for (Contact con : contacts) {
                    String subjectUser = 'A new File was created';
                    String emailBodyUser = 'Dear '+ con.Name + ' ,\n' + 'A new file was created by the related account.';
                    EmailManager.sendMail(con.Email, subjectUser, emailBodyUser);
            }        
        }        
    }

    public static void processContentDocumentLinksNoFuture(Set<Id> contentDocumentIdsDelete) {
        System.debug(contentDocumentIdsDelete);

        List<ContentDocumentLink> cdLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentIdsDelete];
        System.debug('ContentDocumentLink ->' + cdLinks);

        List<ContentDocumentLink> accountLinks = new List<ContentDocumentLink>();

        for (ContentDocumentLink cdLink : cdLinks) {
            if (cdLink.LinkedEntityId.getSObjectType() == Account.SObjectType) {
                accountLinks.add(cdLink);
            }
        }

        System.debug('Account Links -> ' + accountLinks);

        if (!accountLinks.isEmpty()) {
            List<Contact> contacts = [SELECT Id, Name, Email, AccountId FROM Contact WHERE AccountId = :accountLinks[0].LinkedEntityId];

            System.debug('Contacts for Account'+contacts);

            for (Contact con : contacts) {
                    String subjectUser = 'A file was deleted';
                    String emailBodyUser = 'Dear '+ con.Name + ' ,\n' + 'The related account deleted a File.';
                    EmailManager.sendMail(con.Email, subjectUser, emailBodyUser);        
            }
        }        
    }
}
