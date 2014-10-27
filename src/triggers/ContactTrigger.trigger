trigger ContactTrigger on Contact (after insert) 
{   
    /* After Insert */
    if(Trigger.isInsert && Trigger.isAfter)
    {
        ContactTriggerHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }

}