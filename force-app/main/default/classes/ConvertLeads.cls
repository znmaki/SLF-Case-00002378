public with sharing class ConvertLeads {
    public static void LeadAssign(List<Lead> leadsToConvert)
    {
       LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
       // Crea una lista de objetos Database.LeadConvert
       List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

       for (Lead leadToConvert : leadsToConvert) {
           Database.LeadConvert lc = new Database.LeadConvert();
           lc.setLeadId(leadToConvert.Id);           
           lc.setConvertedStatus(convertStatus.MasterLabel);
           lc.setOpportunityAmount(1);
           leadConverts.add(lc);
       }

       // Realiza la conversión
       if (!leadConverts.isEmpty()) {
           List<Database.LeadConvertResult> convertResults = Database.convertLead(leadConverts);
       }
    }
}