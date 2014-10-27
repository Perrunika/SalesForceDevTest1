@isTest(seeAllData=false)
private class ContactTriggerHandlerTest
{
	/*
	 * Test that a case is created every time a contact is inserted
	 */

	static void caseCreationTest() 
	{
		Account acc = TestDataUtil.createAccount();
		insert acc;

		Contact con1 = TestDataUtil.createContact('Primary', acc.Id);
		insert con1;

		Contact con2 = TestDataUtil.createContact('Secondary', acc.Id);
		insert con2;

		Contact con3 = TestDataUtil.createContact('Tertiary', acc.Id);
		insert con3;

		List<Case> primaryCases = [Select Id, ContactId, Status, Origin, Priority, AccountId From Case Where ContactId = : con1.Id];

		List<Case> secondaryCases = [Select Id, Priority From Case Where ContactId = : con2.Id];

		List<Case> tertiaryCases = [Select Id, Priority From Case Where ContactId = : con3.Id];

		System.assertEquals(1, primaryCases.size());
		System.assertEquals(con1.Id, primaryCases[0].ContactId);
		System.assertEquals('Working', primaryCases[0].Status);
		System.assertEquals('New Contact', primaryCases[0].Origin);
		System.assertEquals('High', primaryCases[0].Priority);
		System.assertEquals( acc.Id, primaryCases[0].AccountId);

		System.assertEquals('Medium', secondaryCases[0].Priority);
		System.assertEquals('Low', tertiaryCases[0].Priority);

	}

	/*
	 * Test the creation of cases when multiple contacts are inserted
	 */

	static void caseCreationBulkTest() 
	{
		Account acc = TestDataUtil.createAccount();
		insert acc;

		List<Contact> cons = TestDataUtil.createBulkContact(acc.Id, 200);

		Test.startTest();

		insert cons;

		Test.stopTest();

		List<Case> newCases = [Select Id, ContactId, Status, Origin, Priority, AccountId From Case];

		System.assertEquals(200, newCases.size());

		for(Case c : newCases)
		{
			System.assertEquals('Working', c.Status);
			System.assertEquals('New Contact', c.Origin);
			System.assertEquals('High', c.Priority);
			System.assertEquals(acc.Id, c.AccountId);
		}
	}
}