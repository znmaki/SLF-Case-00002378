public with sharing class RestCreateContacts {
    public static HttpResponse createContactFromRandomUser() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://randomuser.me/api/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            String jsonResponse = response.getBody();
            createContactFromJSON(jsonResponse);
        }

        return response;
    }

    public static void createContactFromJSON(String jsonResponse) {
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        List<Object> results = (List<Object>) jsonMap.get('results');

        if (results != null && !results.isEmpty()) {
            Map<String, Object> contactData = (Map<String, Object>) results[0];

            String firstName = (String) ((Map<String, Object>) contactData.get('name')).get('first');
            String lastName = (String) ((Map<String, Object>) contactData.get('name')).get('last');
            String gender = (String) contactData.get('gender');
            String location = (String) ((Map<String, Object>) ((Map<String, Object>) contactData.get('location')).get('street')).get('name');
            String dobString = (String) ((Map<String, Object>) contactData.get('dob')).get('date');
            Date dobDate = Date.valueOf(dobString);
            String email = (String) contactData.get('email');
            String phone = (String) contactData.get('phone');
            String cell = (String) contactData.get('cell');
            String nat = (String) (contactData.get('nat'));

            Contact newContact = new Contact();
            newContact.FirstName = firstName;
            newContact.LastName = lastName;
            newContact.GenderIdentity = gender;
            newContact.Location__c = location;
            newContact.Birthdate = dobDate;
            newContact.Email = email;
            newContact.Phone = phone;
            newContact.Cell__c = cell;
            newContact.Nat__c = nat;

            System.debug(newContact);

            insert newContact;
        }
    }
}