public with sharing class ChatGPTIntegration {
    @AuraEnabled
    public static String generateChatResponse(String userMessage) {
        System.debug(userMessage);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ChatGPT_API_Credentials/'+'v1/chat/completions');
        req.setMethod('POST');
        req.setTimeout(30000);

        // Define el cuerpo de la solicitud según la estructura proporcionada
        String requestBody = '{' +
            '"model": "gpt-3.5-turbo",' +
            '"messages": [' +
                '{' +
                    '"role": "user",' +
                    '"content": "' + userMessage + '"' +
                '}' +
            '],' +
            '"temperature": 0.7' +
        '}';
        
        req.setBody(requestBody);

        System.debug(requestBody);

        // Establece el encabezado 'Content-Type'
        req.setHeader('Content-Type', 'application/json');

        // Realiza la solicitud a la API de OpenAI
        HttpResponse res = http.send(req);

        // Verifica si la respuesta es exitosa
        if (res.getStatusCode() == 200) {
            // Analiza la respuesta JSON
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> choices = (List<Object>) jsonResponse.get('choices');
            Map<String, Object> message = (Map<String, Object>) choices[0];
            Map<String, Object> contentMap = (Map<String, Object>) message.get('message');
            String content = (String) contentMap.get('content');
            System.debug('Respuesta de ChatGPT: ' + content);
            return content;
        } else {
            System.debug('Error en la solicitud a la API de OpenAI. Código de estado: ' + res.getStatusCode());
            System.debug('Cuerpo de la respuesta: ' + res.getBody());
            return '';
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<ChatGPT_Prompt__mdt> getPrompts(){
        return ChatGPT_Prompt__mdt.getAll().values();
    }

    @AuraEnabled(cacheable=true)
    public static List<ChatGPT_Prompt__mdt> getPromptsByObj() {
        List<ChatGPT_Prompt__mdt> prompts = new List<ChatGPT_Prompt__mdt>();

        // Consulta los registros de ChatGPT_Prompt__mdt y recopila los valores del campo Object__c
        for (ChatGPT_Prompt__mdt prompt : [SELECT Prompt__c, Object__c FROM ChatGPT_Prompt__mdt]) {
            prompts.add(prompt);
        }

        return prompts;
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> getSummaryLead(String id) {
        List<Lead> summaryLead = new List<Lead>();

        for (Lead lead : [SELECT Name, Status, Company FROM Lead WHERE Id = :id]) {
            summaryLead.add(lead);
        }

        return summaryLead;
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getSummaryOpp(String id) {
        List<Opportunity> summaryOpp = new List<Opportunity>();

        for (Opportunity opp : [SELECT Name, Amount, StageName, CloseDate FROM Opportunity WHERE Id = :id]) {
            summaryOpp.add(opp);
        }

        System.debug(summaryOpp);
        return summaryOpp;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getSummaryCon(String id) {
        List<Contact> summaryCon = new List<Contact>();

        for (Contact con : [SELECT FirstName, LastName, Email, Phone FROM Contact WHERE Id = :id]) {
            summaryCon.add(con);
        }

        System.debug(summaryCon);
        return summaryCon;
    }
}