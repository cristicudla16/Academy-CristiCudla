@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    private String body;
    private Integer code;

    public MockHttpResponseGenerator(String body, Integer code) {
        this.body = body;
        this.code = code;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.body);
        res.setStatusCode(this.code);
        return res;
    }
}