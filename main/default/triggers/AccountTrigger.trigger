trigger AccountTrigger on Account ( before insert, after insert, after update, after delete ) {
    if(!Bypass_Automations__c.getInstance().Bypass_Triggers__c){
        new AccountTriggerHandler().run();
    }
}