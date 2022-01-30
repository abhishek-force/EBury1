/********************************************************************************************
 * Test Class for class ForeignExchangeTradeController
 * Created:
 * Modified:
 ********************************************************************************************/
@isTest
private class ForeignExchangeTradeControllerTest {
    
    /****************************************************************************************
     * Setup method to create test data for test class
     ****************************************************************************************/
    @TestSetup
    static void makeData(){
        List<ForeignExchangeTrade__c> tradeRecordList = new List<ForeignExchangeTrade__c>();
        tradeRecordList.add(TestFactory.createForeignExchangeTrade());
        tradeRecordList.add(TestFactory.createForeignExchangeTrade());
        insert tradeRecordList;
    }
    
    /****************************************************************************************
     * Testmethod to test foreign exchange trade query
     ****************************************************************************************/
    @isTest
    private static void testQueryResult(){
        List<ForeignExchangeTrade__c> tradeRecords;
        
        Test.startTest();
        tradeRecords = ForeignExchangeTradeController.getTradeRecords();
        Test.stopTest();

        System.assertEquals(2, tradeRecords.size());
    }
    
    /****************************************************************************************
     * Testmethod to test exchange rate
     ****************************************************************************************/
    @isTest
    private static void testExchangeRate(){
        String jsonReponseString = '{"success":true,"timestamp":1642862643,"base":"EUR","date":"2022-01-22","rates":{"AED":4.166974,"XPF":119.630801,"YER":283.90278}}';
        
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseTest(200, 'OK', jsonReponseString));

        Test.startTest();
        ForeignExchangeTradeController.ResponseWrapper exchangeRateResponse = ForeignExchangeTradeController.getExchangeRate('AED', 'YER');
        Test.stopTest();
        
        System.assertEquals(68.1316418, exchangeRateResponse.exchangeRate.setScale(7));
    }

    /****************************************************************************************
     * Testmethod to test exchange rate callout error
     ****************************************************************************************/
    @isTest
    private static void testExchangeRateCalloutError(){
        String jsonReponseString = '{"success":true,"timestamp":1642862643,"base":"EUR","date":"2022-01-22","rates":{"AED":4.166974,"XPF":119.630801,"YER":283.90278}}';
        
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseTest(404, 'Not Found', jsonReponseString));

        Test.startTest();
        ForeignExchangeTradeController.ResponseWrapper exchangeRateResponse = ForeignExchangeTradeController.getExchangeRate('AED', 'YER');
        Test.stopTest();
        
        System.assertEquals(Label.ExchangeRateCalloutError, exchangeRateResponse.errorString);
    }

    /****************************************************************************************
     * Testmethod to test missing currency rate in JSON response
     ****************************************************************************************/
    @isTest
    private static void testMissingCurrencyRate(){
        String jsonReponseString = '{"success":true,"timestamp":1642862643,"base":"EUR","date":"2022-01-22","rates":{"XPF":119.630801,"YER":283.90278}}';
        
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseTest(200, 'OK', jsonReponseString));

        Test.startTest();
        ForeignExchangeTradeController.ResponseWrapper exchangeRateResponse = ForeignExchangeTradeController.getExchangeRate('AED', 'YER');
        Test.stopTest();
        
        System.assertEquals(Label.ExchangeRateResponseHandlingError, exchangeRateResponse.errorString);
    }
}