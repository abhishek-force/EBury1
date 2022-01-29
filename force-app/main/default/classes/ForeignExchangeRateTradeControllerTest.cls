/********************************************************************************************
 * Test Class for class ForeignExchangeRateTradeController
 * Created:
 * Modified:
 ********************************************************************************************/
@isTest
private class ForeignExchangeRateTradeControllerTest {
    
    /****************************************************************************************
     * Setup method to create test data for test class
     ****************************************************************************************/
    @TestSetup
    static void makeData(){
        List<ForeignExchangeTrade__c> tradeRecordList = new List<ForeignExchangeTrade__c>();
        tradeRecordList.add(TestFactory.createForeignExchangeRateTrade());
        tradeRecordList.add(TestFactory.createForeignExchangeRateTrade());
        insert tradeRecordList;
    }
    
    /****************************************************************************************
     * Testmethod to test foreign exchange trade query
     ****************************************************************************************/
    @isTest
    private static void testQueryResult(){
        List<ForeignExchangeTrade__c> tradeRecords;
        
        Test.startTest();
        tradeRecords = ForeignExchangeRateTradeController.getTradeRecords();
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
        Decimal exchangeRate = ForeignExchangeRateTradeController.getExchangeRate('AED', 'YER');
        Test.stopTest();
        
        System.assertEquals(68.1316418, exchangeRate.setScale(7));
    }
}