import { LightningElement, wire, track } from 'lwc';
import getTradeRecords from '@salesforce/apex/ForeignExchangeRateTradeController.getTradeRecords';

const columns = [
    { label: 'Sell CCY', fieldName: 'SellCurrency__c', type: 'text' },
    { label: 'Sell Amount', fieldName: 'SellAmount__c', type: 'number' },
    { label: 'Buy CCY', fieldName: 'BuyCurrency__c', type: 'text' },
    { label: 'Buy Amount', fieldName: 'BuyAmount__c', type: 'number' },
    { label: 'Rate', fieldName: 'Rate__c', type: 'number' },
    { label: 'Date Booked', fieldName: 'DateBooked__c', type: 'date' }
];

export default class ExistingForeignExchangeTradesLWC extends LightningElement {
    columns = columns;
    showTradeCreationPage = false;
    fetchedTradeRecords = [];
    
    @wire(getTradeRecords)
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

    handleClick(event) {
        console.log('Button_Clicked ', event.target.label);
        this.showTradeCreationPage = !this.showTradeCreationPage;
    }
}