public with sharing class AccountFilterController {
    public List<Account> accountList { get; set; }
    public String selectedCountry { get; set; }
    public List<SelectOption> countryOptions { get; set; }

    public AccountFilterController() {
        
        countryOptions = new List<SelectOption>();

        countryOptions.add(new SelectOption('All', 'All'));

        for (CS_Country_List__c cs : CS_Country_List__c.getAll().values()) {
            countryOptions.add(new SelectOption(cs.Name, cs.List_Countries__c));
        }

        accountList = [SELECT Name, Phone, BillingCountry, ShippingStreet FROM Account];
    }

    public void filterAccounts() {
        if (selectedCountry == 'All') {
            // Si se selecciona "All", consulta todas las cuentas sin filtro
            accountList = [SELECT Name, Phone, BillingCountry, ShippingStreet FROM Account];
        } else {
            // Filtra las cuentas basadas en el país seleccionado
            accountList = [SELECT Name, Phone, BillingCountry, ShippingStreet 
                           FROM Account 
                           WHERE BillingCountry = :selectedCountry];
        }
    }
}