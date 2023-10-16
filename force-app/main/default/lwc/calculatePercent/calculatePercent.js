import { LightningElement } from 'lwc';

export default class CalculatePercent extends LightningElement {
    value = 0;
    selectedPercentage = '10';
    result = 0;

    percentageOptions = [
        { label: '10%', value: '0.10' },
        { label: '20%', value: '0.20' },
        { label: '30%', value: '0.30' },
        { label: '40%', value: '0.40' },
        { label: '50%', value: '0.50' },
    ];

    handleInputChange(event) {
        this.value = parseFloat(event.target.value);
    }

    handlePercentageChange(event) {
        this.selectedPercentage = event.detail.value;
    }

    calculatePercentage() {
        const percentage = parseFloat(this.selectedPercentage);
        this.result = (this.value * percentage).toFixed(2);
    }
}