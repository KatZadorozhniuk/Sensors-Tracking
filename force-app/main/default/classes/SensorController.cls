public with sharing class SensorController {
    @AuraEnabled(cacheable=true)
    public static List<Sensor__c> getSensors() {
        return [SELECT Id, Name, Max_Vectors_Length__c FROM Sensor__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Sensor_Event__c> getSensorEvents(Id sensorId) {
        return [SELECT Id, Name, x__c, y__c, z__c, Sensor__c FROM Sensor_Event__c WHERE Sensor__c = :sensorId];
    }

    @AuraEnabled
    public static void updateSensorEvent(Sensor_Event__c sensorEvent) {
        update sensorEvent;
    }
}