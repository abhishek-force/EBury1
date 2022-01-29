/********************************************************************************************
 * Class to handle Mock Http callouts for Test Classes
 * Created:
 * Modified:
 ********************************************************************************************/
@isTest
public class HttpMockResponseTest implements HttpCalloutMock {
    
    public Integer statusCode;
    public String status;
    public String body;
    
    /****************************************************************************************
     * Method to set mock callout variables
     * Created:
     * Modified:
     ****************************************************************************************/
    public HttpMockResponseTest(Integer statusCode, String status, String body) {
        this.statusCode = statusCode;
        this.status = status;
        this.body = body;
    }

    /****************************************************************************************
     * Overidden interface method that sets the dummy response instead of actual callout
     * Created:
     * Modified:
     ****************************************************************************************/
    public HttpResponse respond(HttpRequest req) {
        HttpResponse hRes = new HttpResponse();
        hRes.setStatusCode(statusCode);
        hRes.setStatus(status);
        hRes.setBody(body);
        return hRes;
    }
}
