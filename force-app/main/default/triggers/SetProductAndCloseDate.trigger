trigger SetProductAndCloseDate on Opportunity (before insert) {
    Product2 pMagazine = [SELECT Id FROM Product2 WHERE Name = 'Magazine' LIMIT 1];

    if (pMagazine != null) {
        for (Opportunity opp : Trigger.new) {
            // Establecer el Producto (Product) en 'Magazine' por su ID
            opp.Product__c = pMagazine.Id;

            // Obtener la fecha actual
            Date currentDate = Date.today();

            // Establecer el Close Date en 60 días después de la creación
            opp.CloseDate = currentDate.addDays(60);
        }
    }
}