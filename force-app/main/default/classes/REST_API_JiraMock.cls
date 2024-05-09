@isTest
public with sharing class REST_API_JiraMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success", "id":"177408","key":"FRT-2576"}');
        res.setStatusCode(201);
        return res;
    }
}