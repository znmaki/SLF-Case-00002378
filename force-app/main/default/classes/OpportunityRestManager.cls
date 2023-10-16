//CASE 00002351
/* @RestResource(urlMapping='/Project3/*')
global with sharing class OpportunityRestManager {
    @HttpPost
    global static ID createProject(String name, String status, String priority, String description){
        Project3__c thisProject3 = new Project3__c(
            Name = name,
            Status__c = status,
            Priority__c = priority,
            Description__c = description
        );

        insert thisProject3;
        return thisProject3.Id;
    }
} */


@RestResource(urlMapping='/Opportunity/*')
global with sharing class OpportunityRestManager {
    @HttpGet
    global static void getProject3() {
        Integer currentYear = System.now().year();
        List<Opportunity> oppSelect = [SELECT Name, Amount , CloseDate, Account.Name FROM Opportunity WHERE StageName = 'Closed Won' AND CALENDAR_YEAR(CloseDate) = :currentYear ORDER BY CloseDate DESC];
        String csvData = 'Name,Amount,Close Date,Account Name\n';
        for (Opportunity opp : oppSelect) {
            csvData += opp.Name + ',' + opp.Amount + ',' + opp.CloseDate + ',' + opp.Account.Name + '\n';
        }

        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'text/csv');
        response.responseBody = Blob.valueOf(csvData);
    }
}