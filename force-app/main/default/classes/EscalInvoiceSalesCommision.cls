public with sharing class EscalInvoiceSalesCommision {
    public Invoice2__c currentInvoice2 {get; set;}

    public EscalInvoiceSalesCommision(ApexPages.StandardController controller) {
        // Obtener el registro de Invoice2 actual utilizando el controlador estándar
        this.currentInvoice2 = (Invoice2__c)controller.getRecord();
    }

    public Pagereference generateInvoiceSalesCommision(){
        List<Invoice_Sales_Commission__c> iscToInsert = new List<Invoice_Sales_Commission__c>();

        Invoice2__c iv2 = [SELECT Id, Name, Billing_Account__c FROM Invoice2__c WHERE Id = :currentInvoice2.Id];

        Account selectAccount = [SELECT Id, Name, Sales_Person__c, Commission__c FROM Account WHERE Id = :iv2.Billing_Account__c];

        List<Project2__c> selectProject2 = [SELECT Id, Name ,Billing_Account__c, Sales_Person__c, Commission__c FROM Project2__c WHERE Billing_Account__c = :selectAccount.Id];

        
        if (!selectProject2.isEmpty()) {
            System.debug('si hay');
            Invoice_Sales_Commission__c iscAccount = new Invoice_Sales_Commission__c(
                Name = 'ISC ' + selectAccount.Name,
                Invoice__c = iv2.Id,
                Account_sales__c = selectAccount.Id,
                Sales_Person__c = selectAccount.Sales_Person__c,
                Commission__c = selectAccount.Commission__c
            );

            iscToInsert.add(iscAccount);

            Invoice_Sales_Commission__c iscProject2 = new Invoice_Sales_Commission__c(
                Name = 'ISC ' + selectProject2[0].Name,
                Invoice__c = iv2.Id,
                Project_sales__c = selectProject2[0].Id,
                Sales_Person__c = selectProject2[0].Sales_Person__c,
                Commission__c = selectProject2[0].Commission__c
            );

            iscToInsert.add(iscProject2);
        }else {
            System.debug('no hay');
            Invoice_Sales_Commission__c iscAccount = new Invoice_Sales_Commission__c(
                Name = 'ISC ' + selectAccount.Name,
                Invoice__c = iv2.Id,
                Account_sales__c = selectAccount.Id,
                Sales_Person__c = selectAccount.Sales_Person__c,
                Commission__c = selectAccount.Commission__c
            );

            iscToInsert.add(iscAccount);
        }


        if (!iscToInsert.isEmpty()) {
            insert iscToInsert;
        }

        return new PageReference('/' + currentInvoice2.Id);
    }
}