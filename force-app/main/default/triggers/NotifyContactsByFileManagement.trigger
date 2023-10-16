trigger NotifyContactsByFileManagement on ContentDocument (after insert,before delete) {

    if (Trigger.isAfter && Trigger.isInsert) {
        System.debug('Creado ->');
        
        Set<Id> contentDocumentIds = new Set<Id>();

        for (ContentDocument cDoc : Trigger.new) {
            contentDocumentIds.add(cDoc.Id);
        }

        ContentDocumentLinkHandler.processContentDocumentLinks(contentDocumentIds);
    }   

    if (Trigger.isBefore && Trigger.isDelete) {
        System.debug('Eliminado ->'+Trigger.old);
        
        Set<Id> contentDocumentIdsDelete = new Set<Id>();

        for (ContentDocument cDoc : Trigger.old) {
            contentDocumentIdsDelete.add(cDoc.Id);
        }
        ContentDocumentLinkHandler.processContentDocumentLinksNoFuture(contentDocumentIdsDelete);
    }
}