trigger AssignTerritoryByCountry on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Lead lead : Trigger.new) {
                LeadSalesCloudManagement.assignTerritory(lead);
            }
        }
    }
}