public with sharing class CalloutToVendAPI {
    public static void makeCallout() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Vendhq_Credentials/products');
        request.setMethod('GET');

        System.debug(request);
        
        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            System.debug('Respuesta -> '+responseBody);
        } else {
            System.debug('Error en la solicitud: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }
}