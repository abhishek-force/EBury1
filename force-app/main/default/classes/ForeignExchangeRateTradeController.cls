/************************************************************************************************
 * Class to handle actions on Foreign Exchange Trade Object
 * Created:
 * Modified:
 ************************************************************************************************/
public with sharing class ForeignExchangeRateTradeController {
   
    /********************************************************************************************
     * Method to get foreign exchange records based sorted by descending order
     * Created:
     * Modified:
     ********************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<ForeignExchangeTrade__c> getTradeRecords(){
        return [SELECT Id, Name, SellCurrency__c, SellAmount__c, BuyCurrency__c, BuyAmount__c, Rate__c, DateBooked__c FROM ForeignExchangeTrade__c ORDER BY DateBooked__c DESC];
    }

    /********************************************************************************************
     * Method to return exchange rate between 2 currencies
     * Created:
     * Modified:
     ********************************************************************************************/
    @AuraEnabled
    public static Decimal getExchangeRate(String sellCurrencyCode, String buyCurrencyCode){
        /*HttpResponse hRes = new HttpResponse();
        HttpCalloutHandler.HttpRequestWrapper requestWrapperIntst = new HttpCalloutHandler.HttpRequestWrapper();

        Map<String, String> paramMap = new Map<String, String>();
        paramMap.put('access_key', '8932fca849fb1029c055bc6635746db7');
        paramMap.put('format', '1');

        requestWrapperIntst.method = 'GET';
        requestWrapperIntst.endPoint = 'http://data.fixer.io/api/latest';//save in Label
        requestWrapperIntst.urlParamMap = paramMap;

        hRes = HttpCalloutHandler.makeCallout(requestWrapperIntst);
        Decimal exchangeRate = getExchangeRate(hRes, sellCurrencyCode, buyCurrencyCode);

        return exchangeRate;*/
        return 2;
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
        //                              84.42/1.13 = 74.42 (USD to INR sell-buy)
        //                              1.13/1     = 1.13  (EUR to USD sell-buy)

        return exchangeRate;
    }
}