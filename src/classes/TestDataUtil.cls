public class TestDataUtil
{
	//Create a Contact
	public static Contact createContact(String level, String accountId)
	{
		Contact con = new Contact();

		con.FirstName = 'Test';
		con.LastName = 'Test';
		con.Level__c = level;
		con.AccountId = accountId;

		return con;
	}

	//Create an Account
	public static Account createAccount()
	{
		Account acc = new Account();

		acc.Name = 'Test Account';

		return acc;
	}

	//Create multiple Contacts
	public static List<Contact> createBulkContact(String accountId, Integer numContacts)
	{
    	List<Contact> newContacts = new List<Contact>();
    	Contact newContact;

    	for(integer i = 0; i < numContacts; i++)
    	{
    	    newContact =  new Contact();
    	    newContact.AccountId = accountId;
            newContact.FirstName = 'Test';
            newContact.LastName = 'Test' + i;
            newContact.Level__c = 'Primary';

            newContacts.add(newContact);
        }

        return newContacts;
    }

}