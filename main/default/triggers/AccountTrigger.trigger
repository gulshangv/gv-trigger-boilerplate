trigger AccountTrigger on Account ( before insert, after insert, after update, after delete ) {
    new AccountTriggerHandler().run();
}