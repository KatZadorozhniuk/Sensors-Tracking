@isTest
public class SensorControllerTest {
    
    @isTest
    static void testGetSensors() {
        
        Sensor__c sensor1 = new Sensor__c(Name = 'Sensor 1');
        Sensor__c sensor2 = new Sensor__c(Name = 'Sensor 2');
        insert new List<Sensor__c> { sensor1, sensor2 };
        
        Test.startTest();
        List<Sensor__c> result = SensorController.getSensors();
        Test.stopTest();
        
       
        
        System.assertEquals(2, result.size(), 'Очікувалося 2 сенсори');
    }
    
    @isTest
    static void testGetSensorEvents() {
        
        Sensor__c sensor = new Sensor__c(Name = 'Sensor 1');
        insert sensor;
        
        Sensor_Event__c event1 = new Sensor_Event__c(Sensor__c = sensor.Id, x__c = 1, y__c = 1, z__c = 1);
        Sensor_Event__c event2 = new Sensor_Event__c(Sensor__c = sensor.Id, x__c = 2, y__c = 2, z__c = 2);
        insert new List<Sensor_Event__c> { event1, event2 };
        
        
        Test.startTest();
        List<Sensor_Event__c> result = SensorController.getSensorEvents(sensor.Id);
        Test.stopTest();
        
        
        
        System.assertEquals(2, result.size(), 'Очікувалося 2 події сенсора');
    }
}