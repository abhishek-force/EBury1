/********************************************************************************************
 * Class to handle Http callouts
 * Created:
 * Modified:
 ********************************************************************************************/
public class HttpCalloutHandler {
    
    /****************************************************************************************
     * Method to handle Http callouts. Takes params in the form of wrapper object
     * Created:
     * Modified:
     ****************************************************************************************/
    public static HttpResponse makeCallout(HttpRequestWrapper request){
        String endpointString;
        HttpRequest hReq = new HttpRequest();
        Http h = new Http();
        HttpResponse hRes = new HttpResponse();
        
        hReq.setMethod(request.method);

        if(String.isNotBlank(request.requestBody)){
            hReq.setBody(request.requestBody);
        }
        
        endpointString = request.endPoint + '?';
        
        for(String key : request.urlParamMap.keySet()){
            endpointString += key + '=' + request.urlParamMap.get(key) + '&';
        }
        
        endpointString = endpointString.removeEnd('&');
        hReq.setEndPoint(endpointString);
        
        System.debug(hReq);
        hRes = h.send(hReq);
        
        System.debug('Response Debug' + hRes);
        return hRes;
    }

    /****************************************************************************************
     * Wrapper class to set Http callout parameters
     * Created:
     * Modified:
     ****************************************************************************************/
    public class HttpRequestWrapper{
        public String method;
        public String endPoint;
        public Map<String, String> urlParamMap;
        public String requestBody;
    }
}