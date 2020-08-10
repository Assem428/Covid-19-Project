trigger AverageRecoveryAndFatalityPeriod on Patient__c (before insert, before update, after insert, after update, after delete) {
    Set<Id> AreaIds= new Set<Id>(); 
    List<Area__c> AreasToUpdate= new List<Area__c>();
    if((Trigger.isBefore && Trigger.isInsert)||(Trigger.isBefore && Trigger.isUpdate)){
    for(Patient__c pat1 : Trigger.new){
        if(pat1.Cured_Date__c != Null){
            pat1.State__c = 'Cured';
        } else if(pat1.Fatal_Date__c != Null) {
            pat1.State__c = 'Fatal';
        }
    }
    }    
    if (Trigger.isAfter){
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Patient__c pat: Trigger.new){ 
                AreaIds.add(pat.AreaId__c); 
        }
    }
    if(Trigger.isDelete){
        for(Patient__c pat: Trigger.old){ 
                AreaIds.add(pat.AreaId__c);
        }
    }
      }
List <Area__c> AreasToUpdateAveragePeriods = [SELECT Id,
                                                (SELECT Id, Name  
                                                FROM Patients__r WHERE 	AreaId__c != Null) 
                                                FROM Area__c 
                                                WHERE Id in :AreaIds];
    
        AggregateResult[] groupedResultsCured = [SELECT AVG(Recovery_Period_for_this_Patient__c)aver 
                                                 FROM Patient__c WHERE AreaId__c IN : AreaIds];
        Object avgAmountCured = groupedResultsCured[0].get('aver');
        
        
        AggregateResult[] groupedResultsFatal = [SELECT AVG(Fatal_Period_for_this_Patient__c)aver 
                                                 FROM Patient__c WHERE AreaId__c IN : AreaIds];
        Object avgAmountFatal = groupedResultsFatal[0].get('aver');
        
        for(Area__c areas: AreasToUpdateAveragePeriods){
          if(areas.Patients__r.size()>0) 
                areas.Recovery_Period__c = Integer.valueOf(avgAmountCured);
                areas.Fatality_Period__c = Integer.valueOf(avgAmountFatal);
                AreasToUpdate.add(areas);
    }
    update AreasToUpdate;
}