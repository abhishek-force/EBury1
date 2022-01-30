import { LightningElement, wire } from 'lwc';
import getTradeRecords from '@salesforce/apex/ForeignExchangeTradeController.getTradeRecords';

const columns = [
    { label: 'Sell CCY', fieldName: 'SellCurrency__c', type: 'text' },
    { label: 'Sell Amount', fieldName: 'SellAmount__c', type: 'number' },
    { label: 'Buy CCY', fieldName: 'BuyCurrency__c', type: 'text' },
    { label: 'Buy Amount', fieldName: 'BuyAmount__c', type: 'number' },
    { label: 'Rate', fieldName: 'Rate__c', type: 'number' },
    { label: 'Date Booked', fieldName: 'DateBookedFormula__c', type: 'datetime' }
];

export default class ExistingForeignExchangeTradesLWC extends LightningElement {
    columns = columns;
    showTradeCreationPage = false;
    fetchedTradeRecords = [];
    errorMessage;
    
    @wire(getTradeRecords)
    wiredTradeRecords({ error, data }) {
        if (data) {
            this.fetchedTradeRecords = data;
        } else if (error) {
            this.errorMessage = 'There is an error!';
        }
    }

    handleClick(event) {
        this.showTradeCreationPage = !this.showTradeCreationPage;
    }
}