public with sharing class OpportunityEmailService {
    public static void sendEmail(List<Opportunity> opportunities) {
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        for (Opportunity opp : opportunities) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String ownerId = opp.OwnerId;
            User ownerUser = [SELECT Email FROM User WHERE Id = :ownerId LIMIT 1];
            
            if (ownerUser != null && ownerUser.Email != null) {
                String[] toAddresses = new String[] {ownerUser.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Alerta: Oportunidad en etapa de Negociación');
                mail.setPlainTextBody('La oportunidad ' + opp.Name + ' ha llegado a la etapa de Negociación.');
                emailMessages.add(mail);
            }
        }
        
        if (!emailMessages.isEmpty()) {
            Messaging.sendEmail(emailMessages);
        }
    }
}