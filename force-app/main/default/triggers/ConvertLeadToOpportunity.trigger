trigger ConvertLeadToOpportunity on Lead (after insert, after update) {
    List<Lead> leadList = Trigger.new;
    List<Lead> leadListConvert = new List<Lead>();
    for (Lead lead : leadList) {
        if (lead.LeadSource == 'In-Person Application' && lead.IsConverted == false) {
            leadListConvert.add(lead);
        }

        if (leadListConvert.size() > 0) {
            ConvertLeads.LeadAssign(leadListConvert);
        }
    }
}