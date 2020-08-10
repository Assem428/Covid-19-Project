@isTest
public class AverageRecoveryAndFatalityPeriodTest {
    @isTest static void TestAverageRecoveryAndFatalityPeriodTrigger(){
        Area__c areas = new Area__c();
        areas.Name = 'TestArea';
        insert areas;
        
        Patient__c pat = new Patient__c();
        pat.Name = 'TestPatient';
        pat.Created_Date__c = date.today();
        pat.Cured_Date__c = date.today().addDays(8);
        pat.AreaId__c = areas.Id;
        insert pat;
        
        Patient__c pat0 = new Patient__c();
        pat0.Name = 'TestPatient';
        pat0.Created_Date__c = date.today();
        pat0.Cured_Date__c = date.today().addDays(13);
        pat0.AreaId__c = areas.Id;
        insert pat0;
        
        Patient__c pat1 = new Patient__c();
        pat1.Name = 'TestPatient1';
        pat1.Created_Date__c = date.today();
        pat1.Cured_Date__c = date.today().addDays(5);
        pat1.AreaId__c = areas.Id;
        insert pat1;
        delete pat1;
        
        Patient__c pat2 = new Patient__c();
        pat2.Name = 'TestPatient2';
        pat2.Created_Date__c = date.today();
        pat2.Fatal_Date__c = date.today().addDays(7);
        pat2.AreaId__c = areas.Id;
        insert pat2;
        
        Patient__c pat3 = new Patient__c();
        pat3.Name = 'TestPatient2';
        pat3.Created_Date__c = date.today();
        pat3.Fatal_Date__c = date.today().addDays(10);
        pat3.AreaId__c = areas.Id;
        insert pat3;
        
        
        Area__c areas1 = [Select ID, Recovery_Period__c FROM Area__c];
        system.assertEquals(10, areas1.Recovery_Period__c);
        Area__c areas2 = [Select ID, Fatality_Period__c FROM Area__c];
        system.assertEquals(8, areas2.Fatality_Period__c);
    }
}