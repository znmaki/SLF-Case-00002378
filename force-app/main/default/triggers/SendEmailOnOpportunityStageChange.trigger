trigger SendEmailOnOpportunityStageChange on Opportunity (after insert, after update) {
    List<Opportunity> opportunitiesToSendEmail = new List<Opportunity>();
    
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Negotiation' && (Trigger.isInsert || opp.StageName != Trigger.oldMap.get(opp.Id).StageName)) {
            opportunitiesToSendEmail.add(opp);
        }
    }

    if (!opportunitiesToSendEmail.isEmpty()) {
        OpportunityEmailService.sendEmail(opportunitiesToSendEmail);
    }
}