@isTest
public class MockContactHttpCall implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Crea una respuesta HTTP simulada
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results": [{"gender": "male","name": {"title": "Mr","first": "John","last": "Doe"},"location": {"street": {"number": 123,"name": "Main St"},"city": "Anytown","state": "CA","country": "USA"},"email": "john.doe@example.com","dob": {"date": "1980-01-15T12:00:00Z"},"phone": "(123) 456-7890","cell": "(987) 654-3210","nat": "US"}],"info": {"seed": "abcd1234","results": 1,"page": 1,"version": "1.4"}}');
        res.setStatusCode(200);
        return res;
    }
}