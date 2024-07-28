import { LightningElement, wire, track } from 'lwc';
import getSensors from '@salesforce/apex/SensorController.getSensors';
import getSensorEvents from '@salesforce/apex/SensorController.getSensorEvents';
import updateSensorEvent from '@salesforce/apex/SensorController.updateSensorEvent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SensorTracking extends LightningElement {
    @track sensors = [];
    @track sensorOptions = [];
    @track selectedSensorId;
    @track sensorEvents;
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'X', fieldName: 'x__c', type: 'number', editable: true },
        { label: 'Y', fieldName: 'y__c', type: 'number', editable: true },
        { label: 'Z', fieldName: 'z__c', type: 'number', editable: true },
    ];

    @wire(getSensors)
    wiredSensors({ error, data }) {
        if (data) {
            this.sensors = data;
            this.sensorOptions = data.map(sensor => ({
                label: sensor.Name,
                value: sensor.Id
            }));
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleSensorChange(event) {
        this.selectedSensorId = event.detail.value;
        getSensorEvents({ sensorId: this.selectedSensorId })
            .then(data => {
                this.sensorEvents = data;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues.slice();
        const promises = updatedFields.map(field => {
            return updateSensorEvent({ sensorEvent: field });
        });

        Promise.all(promises)
            .then(() => {
                this.showToast('Success', 'Records updated', 'success');
                return getSensorEvents({ sensorId: this.selectedSensorId });
            })
            .then(data => {
                this.sensorEvents = data;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}