public with sharing class LeadSalesCloudManagement {
    public static void assignTerritory(Lead newLead) {
        System.debug('assignTerritory'+newLead);
        // Lista de estados/provincias para asignar "Territory__c" a "Eastern"
        Set<String> easternStates = new Set<String>{
            'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Indiana', 'Kentucky',
            'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'New Hampshire',
            'New Jersey', 'New York', 'North Carolina', 'Ohio', 'Pennsylvania',
            'Rhode Island', 'South Carolina', 'Tennessee', 'Vermont', 'Virginia', 'West Virginia'
        };

        // Lista de estados/provincias para asignar "Territory__c" a "Central"
        Set<String> centralStates = new Set<String>{
            'Alabama', 'Arkansas', 'Florida', 'Illinois', 'Indiana', 'Iowa', 'Kansas',
            'Kentucky', 'Louisiana', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
            'Nebraska', 'North Dakota', 'South Dakota', 'Oklahoma', 'Tennessee', 'Texas', 'Wisconsin'
        };

        // Lista de estados/provincias para asignar "Territory__c" a "Mountain"
        Set<String> mountainStates = new Set<String>{
            'Colorado', 'Montana', 'New Mexico', 'Utah', 'Wyoming'
        };

        // Lista de estados/provincias para asignar "Territory__c" a "Pacific"
        Set<String> pacificStates = new Set<String>{
            'California', 'Oregon', 'Washington', 'Nevada'
        };

        if (newLead.Country == 'Canada') {
            newLead.Territory__c = '';
        }
        if (easternStates.contains(newLead.State)) {
            newLead.Territory__c = 'Eastern';
        }else if (centralStates.contains(newLead.State)) {
            newLead.Territory__c = 'Central';
        }else if (mountainStates.contains(newLead.State)) {
            newLead.Territory__c = 'Mountain';
        }else if (pacificStates.contains(newLead.State)) {
            newLead.Territory__c = 'Pacific';
        }

        assingOwner(newLead);
    }

    public static void assingOwner(Lead newLead){
        User userCristhian = [SELECT Id, Name FROM User WHERE Name = 'Cristhian Ortiz'];
        User userAgustin = [SELECT Id, Name FROM User WHERE Name = 'Agustin Visciglia' LIMIT 1];
        User userJavier = [SELECT Id, Name FROM User WHERE Name = 'Javier Ramirez'];
        User userFacundo = [SELECT Id, Name FROM User WHERE Name = 'Facundo Salinas'];

        if (newLead.Territory__c == 'Eastern') {
            newLead.OwnerId = userFacundo.Id;
        }else if (newLead.Territory__c == 'Central') {
            newLead.OwnerId = userJavier.Id;
        }else if (newLead.Territory__c == 'Mountain') {
            newLead.OwnerId = userAgustin.Id;
        }else if (newLead.Territory__c == 'Pacific') {
            newLead.OwnerId = userCristhian.Id;
        }

        sendEmailOwner(newLead);
    }

    public static void sendEmailOwner(Lead newLead){
        User us = [SELECT Id, Name, Email FROM User WHERE Id = :newLead.OwnerId];

        String subjectUser = 'A new Lead was assigned';
        String emailBodyUser = 'Dear '+ us.Name + ' ,\n' +
                                'A new Lead was assigned with Name: ' + newLead.FirstName + ' ' + newLead.LastName + '\n' +
                                'Thank You\n' +
                                'Regards System Administrator.';
        EmailManager.sendMail(us.Email, subjectUser, emailBodyUser);
    }
}