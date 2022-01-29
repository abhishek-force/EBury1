import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getExchangeRate from '@salesforce/apex/ForeignExchangeRateTradeController.getExchangeRate';


import FOREIGN_EXCHANGE_TRADE from '@salesforce/schema/ForeignExchangeTrade__c';
import SELL_CURRENCY from '@salesforce/schema/ForeignExchangeTrade__c.SellCurrency__c';
import SELL_AMOUNT from '@salesforce/schema/ForeignExchangeTrade__c.SellAmount__c';
import BUY_CURRENCY from '@salesforce/schema/ForeignExchangeTrade__c.BuyCurrency__c';
import BUY_AMOUNT from '@salesforce/schema/ForeignExchangeTrade__c.BuyAmount__c';
import RATE from '@salesforce/schema/ForeignExchangeTrade__c.Rate__c';
import DATE_BOOKED from '@salesforce/schema/ForeignExchangeTrade__c.DateBooked__c';

export default class NewForeignExchangeTradeLWC extends NavigationMixin (LightningElement) {
    //@api recordId;
    objectApiName = 'ForeignExchangeTrade__c';
    FOREIGN_EXCHANGE_TRADE = FOREIGN_EXCHANGE_TRADE;
    SELL_CURRENCY = SELL_CURRENCY;
    SELL_AMOUNT = SELL_AMOUNT;
    BUY_CURRENCY = BUY_CURRENCY;
    BUY_AMOUNT = BUY_AMOUNT;
    RATE = RATE;
    DATE_BOOKED = DATE_BOOKED;

    sellcurrency;
    buycurrency;
    sellAmount;
    buyAmount;
    conversionRate;

    handleCurrencyChange(event){
        var name = event.target.fieldName;
        console.log('currencyFieldAPI ', name);
        console.log('currencyFieldAPI ', event.target.value);

        console.log('this.SELL_CURRENCY ', this.SELL_CURRENCY);
        console.log('this.BUY_CURRENCY ', this.BUY_CURRENCY);

        if(name == this.SELL_CURRENCY.fieldApiName){
            this.sellcurrency = event.target.value;
        } else {
            this.buycurrency = event.target.value;
        }

        console.log('sellcurrency1', this.sellcurrency);
        console.log('buycurrency1', this.buycurrency);

        if (this.sellcurrency != undefined && this.buycurrency != undefined){
            console.log('sellcurrency2', this.sellcurrency);
            console.log('buycurrency2', this.buycurrency);

            getExchangeRate({sellCurrencyCode: this.sellcurrency, buyCurrencyCode : this.buycurrency})
                .then(result => {
                    this.conversionRate = result;
                    console.log('currencyFieldAPI X', result);
                    this.calculateBuyAmount();
                })
                .catch(error => {
                    //this.error = error;
                    console.log('error ' + error);
                });
        }
    }

    handleSellAmountChange(event){
        this.sellAmount = event.target.value;
        console.log('currencyFieldAPI ', this.sellAmount);
        this.calculateBuyAmount();
    }

    calculateBuyAmount(){
        if(this.sellAmount && this.sellcurrency && this.buycurrency) {
            this.buyAmount = this.sellAmount * this.conversionRate;
            console.log('currencyFieldAPI ', this.buyAmount);
        }
    }

    wiredTradeRecords({ error, data }) {
        if (data) {
            console.log('In Data');
            this.fetchedTradeRecords = data;
            console.log('After Data', data.length);
        } else if (error) {
            console.log('In error');
            console.log('Error=', error);
        }
    }

    handleSuccess(event) {
        console.log('event.detail.id >> ', event.detail.id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                recordId: event.detail.id
            },
        });

        /*createRecord(recordInput)
            .then(account => {
                //move this to another method
                const event = new ShowToastEvent({
                    title: 'Success!',
                    message: 'A new record is created',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'There is unexpected error!',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            });*/
    }

    handleCancel() {
        console.log('log1');
        const custEvent = new CustomEvent('navigateback');
        console.log('log2');
        this.dispatchEvent(custEvent);
    }
}