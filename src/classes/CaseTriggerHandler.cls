/* 
 * CaseTriggerHandler
 *
 * Creates a new task for the user
 * who owns the contact for each new case added to the system.
 * 
 */

public with sharing class CaseTriggerHandler
{
	public static void OnAfterInsert(list<Case> newCase, map<Id,Case> newCaseMap)
	{
		// A list to store the created Cases
       	List<Task> taskToInsert = new List<Task>();
       	
		Set<Id> Ids = new Set<Id>();

		for(Case c : newCase)
		{
			Ids.add(c.ContactId);
		}

		//Create a map with the First and Last Names of the Contacts associated to the cases.
		Map<Id, Contact> contactMap = new Map<Id, Contact>([Select Id, FirstName, LastName From Contact Where Id IN : Ids]); 

		// Loop over the Cases
       	for(Case c : newCase)
       	{
       		Task taskToAdd = new Task();

            taskToAdd.OwnerId = c.OwnerId;
            taskToAdd.Priority = 'Normal';
            taskToAdd.Subject = 'Welcome call for ' + contactMap.get(c.ContactId).LastName + ' - ' + c.CaseNumber;
            taskToAdd.WhoId = c.ContactId;

            if(c.Priority == 'High')
            {
            	taskToAdd.ActivityDate = System.Today().addDays(7);
            }

            if(c.Priority == 'Medium')
            {
            	taskToAdd.ActivityDate = System.Today().addDays(14);
            }

            if(c.Priority == 'Low')
            {
            	taskToAdd.ActivityDate = System.Today().addDays(21);
            }

            taskToInsert.add(taskToAdd);
       	} 
		
		// Insert the created tasks
       	try
		{
       		insert taskToInsert;

       	} catch (System.DmlException e)
       	{
    		for (Integer i = 0; i < e.getNumDml(); i++)
    		{
        		System.debug(e.getDmlMessage(i));
        	}
        }
	}
}