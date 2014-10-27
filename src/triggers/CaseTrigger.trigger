trigger CaseTrigger on Case (after insert)
{   
    /* After Insert */
    if(Trigger.isInsert && Trigger.isAfter)
    {
        CaseTriggerHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }

}