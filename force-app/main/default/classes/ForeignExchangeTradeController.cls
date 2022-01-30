/************************************************************************************************
 * Class to handle actions on Foreign Exchange Trade Object
 * Created:
 * Modified:
 ************************************************************************************************/
public with sharing class ForeignExchangeTradeController {
   
    /********************************************************************************************
     * Method to get foreign exchange records based sorted by descending order
     * Created:
     * Modified:
     ********************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<ForeignExchangeTrade__c> getTradeRecords(){
        return [SELECT Id, Name, SellCurrency__c, SellAmount__c, BuyCurrency__c, BuyAmount__c, Rate__c, DateBooked__c, DateBookedFormula__c 
                FROM ForeignExchangeTrade__c 
                ORDER BY CreatedDate DESC];
    }

    /********************************************************************************************
     * Method to return exchange rate between 2 currencies
     * Created:
     * Modified:
     ********************************************************************************************/
    @AuraEnabled
    public static ResponseWrapper getExchangeRate(String sellCurrencyCode, String buyCurrencyCode){
        ResponseWrapper response = new ResponseWrapper();
        HttpResponse hRes = new HttpResponse();
        HttpCalloutHandler.HttpRequestWrapper requestWrapperIntst = new HttpCalloutHandler.HttpRequestWrapper();

        Map<String, String> paramMap = new Map<String, String>();
        paramMap.put('access_key', Label.FixerAPIKey);
        paramMap.put('format', '1');

        requestWrapperIntst.method = 'GET';
        requestWrapperIntst.endPoint = Label.FixerAPIEndPoint;
        requestWrapperIntst.urlParamMap = paramMap;

        try {
            hRes = HttpCalloutHandler.makeCallout(requestWrapperIntst);

            if(hRes.getStatusCode() == 200){
                try {
                    response.exchangeRate = getExchangeRate(hRes, sellCurrencyCode, buyCurrencyCode);
                } catch (Exception e){
                    response.errorString = Label.ExchangeRateResponseHandlingError;
                }
            } else {
                response.errorString = Label.ExchangeRateCalloutError;
            }
        } catch (Exception e){
            response.errorString = Label.ExchangeRateCalloutError;
        }

        return response;
    }

    /********************************************************************************************
     * Method to read Http reponse and get actual conversion rate
     * Created:
     * Modified:
     ********************************************************************************************/
    private static Decimal getExchangeRate(HttpResponse response, String sellCurrencyCode, String buyCurrencyCode){
        Decimal exchangeRate;
        Map<String, Object> jsonReponseObject = (Map<String, Object>)Json.deserializeUntyped(response.getBody());
        Map<String, Object> rates = (Map<String, Object>)jsonReponseObject.get('rates');
        
        exchangeRate = (Decimal)rates.get(buyCurrencyCode)/(Decimal)rates.get(sellCurrencyCode);

        return exchangeRate;
    }

    /********************************************************************************************
     * Wrapper class to set response for LWC
     * Created:
     * Modified:
     ********************************************************************************************/
    public class ResponseWrapper {
        @AuraEnabled
        public Decimal exchangeRate;

        @AuraEnabled
        public String errorString;
    }
}