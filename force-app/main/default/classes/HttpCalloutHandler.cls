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
        endpointString = request.endPoint;

        if(String.isNotBlank(request.requestBody)){
            hReq.setBody(request.requestBody);
        }
        
        if(request.urlParamMap != null && !request.urlParamMap.keySet().isEmpty()){
            endpointString += '?';
            
            for(String key : request.urlParamMap.keySet()){
                endpointString += key + '=' + request.urlParamMap.get(key) + '&';
            }
        }
        
        endpointString = endpointString.removeEnd('&');
        hReq.setEndPoint(endpointString);
        hRes = h.send(hReq);
        
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