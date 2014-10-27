@isTest
private class CaseTriggerHandlerTest 
{
	/*
	 * Test that a task is created every time a contact is inserted
	 */
	
	static void taskCreationTest()
	{
		Account acc = TestDataUtil.createAccount();
		insert acc;

		Contact con1 = TestDataUtil.createContact('Primary', acc.Id);
		insert con1;

		Contact con2 = TestDataUtil.createContact('Secondary', acc.Id);
		insert con2;

		Contact con3 = TestDataUtil.createContact('Tertiary', acc.Id);
		insert con3;

		List<Task> highTask = [Select Id, OwnerId, Priority, Subject, ActivityDate From Task Where WhoId =: con1.Id];

		List<Task> normalTask = [Select Id, OwnerId, Priority, Subject, ActivityDate From Task Where WhoId =: con2.Id];

		List<Task> lowTask = [Select Id, OwnerId, Priority, Subject, ActivityDate From Task Where WhoId =: con3.Id];

		List<Case> newCase = [Select Id, CaseNumber, ContactId, Status, Origin, Priority, AccountId, OwnerId From Case];

		List<Contact> newContact = [Select Id, FirstName, LastName From Contact Where Id =: con1.Id];

		System.assertEquals(1, highTask.size());
		System.assertEquals(newCase[0].OwnerId, highTask[0].OwnerId);
		System.assertEquals('Welcome call for ' + newContact[0].LastName + ' - ' + newCase[0].CaseNumber, highTask[0].Subject);
		System.assertEquals('Normal', highTask[0].Priority);

		System.assertEquals(System.today().addDays(7), highTask[0].ActivityDate);
		System.assertEquals(System.today().addDays(14), normalTask[0].ActivityDate);
		System.assertEquals(System.today().addDays(21), lowTask[0].ActivityDate);
	}

	/*
	 * Test the creation of tasks when multiple contacts are inserted
	 */

	static void taskCreationBulkTest()
	{
		Account acc = TestDataUtil.createAccount();
		insert acc;

		List<Contact> cons = TestDataUtil.createBulkContact(acc.Id, 200);

		Test.startTest();
		insert cons;
		Test.stopTest();

		List<Task> newTasks = [Select Id, OwnerId, Priority, Subject, ActivityDate From Task];
		List<Case> newCases = [Select Id, CaseNumber, ContactId, Status, Origin, Priority, AccountId, OwnerId From Case];

		System.assertEquals(200, newTasks.size());
		System.assertEquals(200, newCases.size());

		for(Task t : newTasks)
		{
			System.assertEquals('Normal', t.Priority);
			System.assertEquals(System.today() + 7, t.ActivityDate);
		}
		
		
	}
	
}