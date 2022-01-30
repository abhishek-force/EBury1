/************************************************************************************************
 * Test Factory Class to generate data for test classes
 * Created:
 * Modified:
 ************************************************************************************************/
public class TestFactory {
    
    /********************************************************************************************
     * Method to create and return instance of ForeignExchangeTrade__c object
     * 
     ********************************************************************************************/
    public static ForeignExchangeTrade__c createForeignExchangeTrade() {
        ForeignExchangeTrade__c inst = new ForeignExchangeTrade__c();
        inst.SellAmount__c = 100;
        inst.SellCurrency__c = 'EUR';
        inst.BuyAmount__c = 8500;
        inst.BuyCurrency__c = 'INR';
        inst.Rate__c = 85;
        return inst;
    }
}
