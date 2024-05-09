@isTest
global class BatchSyncMock implements HttpCalloutMock {
	/*global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('Success');
        res.setStatusCode(201);
        return res;
    }*/
    private Integer statusCode;

    public BatchSyncMock(Integer statusCode){
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"key":"1","id":"2"}');
        res.setStatusCode(this.statusCode);
        return res;
    }
}