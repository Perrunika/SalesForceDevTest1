/* 
 * ContactTriggerHandler
 *
 * Creates a new case for each new Contact added to the system.
 * 
 */

public with sharing class ContactTriggerHandler 
{
	public static void OnAfterInsert(list<Contact> newContact, map<Id,Contact> newContactMap)
	{
		// A list to store the created Cases
       	List<Case> casesToInsert = new List<Case>();

		// Loop over the contacts
    	for(Contact con : newContact)
       	{
       		Case caseToAdd = new Case();

            // Setting up the case field values
            caseToAdd.ContactId = con.Id;
            caseToAdd.Status 	= 'Working';
            caseToAdd.Origin 	= 'New Contact';
            caseToAdd.OwnerId 	= con.OwnerId;

            if(con.Level__c == 'Primary')
            {
            	caseToAdd.Priority = 'High';
            }

            if(con.Level__c == 'Secondary')
            {
            	caseToAdd.Priority = 'Medium';
            }

            if(con.Level__c == 'Tertiary')
            {
            	caseToAdd.Priority = 'Low';
            }
  
            
            //If the account is specified, related the case to that account
            if(con.AccountId != null)
            {
				caseToAdd.AccountId = con.AccountId;
			}

            casesToInsert.add(caseToAdd);
       	} 

       	//Insert the List with the created cases
       	try
       	{
    		insert casesToInsert;

       	} catch (System.DmlException e)
       	{
    		for (Integer i = 0; i < e.getNumDml(); i++)
    		{
        		System.debug(e.getDmlMessage(i));
        	}
        }
    }
}