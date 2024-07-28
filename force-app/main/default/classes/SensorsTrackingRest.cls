@RestResource(urlMapping='/sensorsTrackingRest/*')
global with sharing class SensorsTrackingRest {
    
    @HttpPost
    global static String doPost(String requestBody) {
       
        Map<String, Object> request = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
        String sensorId = (String) request.get('sensorid');
        List<Object> vectors = (List<Object>) request.get('vectors');

        Sensor__c sensor;
        List<Sensor__c> sensorsList = [SELECT Id FROM Sensor__c WHERE Name = :sensorId LIMIT 1];
        if (sensorsList.isEmpty()) {
            sensor = new Sensor__c(Name = sensorId);
            insert sensor;
        } else {
            sensor = sensorsList.get(0);
        }

        List<Sensor_Event__c> events = new List<Sensor_Event__c>();
        for (Object vectorObj : vectors) {
            Map<String, Object> vector = (Map<String, Object>) vectorObj;
            Decimal x = (Decimal) vector.get('x');
            Decimal y = (Decimal) vector.get('y');
            Decimal z = (Decimal) vector.get('z');
 
            Sensor_Event__c event = new Sensor_Event__c(
                Sensor__c = sensor.Id,
                x__c = x,
                y__c = y,
                z__c = z);
            events.add(event);
        }
        insert events;
        return 'Sensor events created successfully.';
    }
    private static Decimal calculateModulus(Decimal x, Decimal y, Decimal z) {
        return Math.sqrt(x * x + y * y + z * z);
    }
}