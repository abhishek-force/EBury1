import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getExchangeRate from '@salesforce/apex/ForeignExchangeTradeController.getExchangeRate';

import rateErrorLabel from '@salesforce/label/c.UserFriendlyExchangeRateProcessingError';

import FOREIGN_EXCHANGE_TRADE from '@salesforce/schema/ForeignExchangeTrade__c';
import SELL_CURRENCY from '@salesforce/schema/ForeignExchangeTrade__c.SellCurrency__c';
import SELL_AMOUNT from '@salesforce/schema/ForeignExchangeTrade__c.SellAmount__c';
import BUY_CURRENCY from '@salesforce/schema/ForeignExchangeTrade__c.BuyCurrency__c';
import BUY_AMOUNT from '@salesforce/schema/ForeignExchangeTrade__c.BuyAmount__c';
import RATE from '@salesforce/schema/ForeignExchangeTrade__c.Rate__c';

export default class NewForeignExchangeTradeLWC extends NavigationMixin (LightningElement) {
    FOREIGN_EXCHANGE_TRADE = FOREIGN_EXCHANGE_TRADE;
    SELL_CURRENCY = SELL_CURRENCY;
    SELL_AMOUNT = SELL_AMOUNT;
    BUY_CURRENCY = BUY_CURRENCY;
    BUY_AMOUNT = BUY_AMOUNT;
    RATE = RATE;

    sellcurrency;
    buycurrency;
    sellAmount;
    buyAmount;
    conversionRate;
    
    errorMessage;
    enableCreateButton = false;
    rateError = rateErrorLabel;

    handleCurrencyChange(event){
        var name = event.target.fieldName;
        
        if(name == this.SELL_CURRENCY.fieldApiName){
            this.sellcurrency = event.target.value;
        } else {
            this.buycurrency = event.target.value;
        }

        if(this.sellcurrency != undefined && this.buycurrency != undefined){
            getExchangeRate({sellCurrencyCode: this.sellcurrency, buyCurrencyCode : this.buycurrency})
                .then(result => {
                    if(result.errorString == undefined){
                        this.conversionRate = result.exchangeRate;
                        this.calculateBuyAmount();
                    } else {
                        this.errorMessage = this.rateError;
                    }
                })
                .catch(error => {
                    this.errorMessage = this.rateError;
                });
        }
    }

    handleSellAmountChange(event){
        this.sellAmount = event.target.value;
        this.calculateBuyAmount();
    }

    calculateBuyAmount(){
        if(this.sellAmount && this.sellcurrency && this.buycurrency) {
            this.buyAmount = this.sellAmount * this.conversionRate;
            this.enableCreateButton = true;
        }
    }

    handleSuccess(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                recordId: event.detail.id
            },
        });
    }

    handleCancel() {
        const custEvent = new CustomEvent('navigateback');
        this.dispatchEvent(custEvent);
    }
}