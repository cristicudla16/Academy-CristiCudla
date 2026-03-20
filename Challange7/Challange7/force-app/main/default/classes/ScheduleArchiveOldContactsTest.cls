@isTest
private class ScheduleArchiveOldContactsTest {

    @isTest
    static void testScheduledClass() {
        // Simulate the creation of a Contact record that matches the batch's criteria
        // Create test data
        Contact testContact = new Contact(LastName = 'Testerson', Email = null);
        insert testContact;
        
        // Set created date to be 7 months old
        Test.setCreatedDate(testContact.Id, Date.today().addMonths(-7));

        // Schedule the batch job within the test method
        Test.startTest();
        String CRON_EXP = '0 0 2 ? * SUN *';   // every Sunday at 2 AM
        ScheduleArchiveOldContacts sched = new ScheduleArchiveOldContacts();
        System.SchedulableContext sc = null;
        sched.execute(sc);
        Test.stopTest();

        Integer countCron = [SELECT Count() FROM CronTrigger];
		System.assert(countCron > 0, 'The batch job should have been triggered.');

        // Assert the expected outcome
        testContact = [SELECT Is_Archived__c FROM Contact WHERE Id = :testContact.Id];
        System.assert(testContact.Is_Archived__c, 'The contact should be archived with IsArchived__c set to true.');
    }

    @isTest
    static void testScheduledClassCronExpression() {
        // Simulate the creation of a Contact record that matches the batch's criteria
        // Create test data
        Contact testContact = new Contact(LastName = 'Testerson', Email = null);
        insert testContact;
        
        // Set created date to be 7 months old
        Test.setCreatedDate(testContact.Id, Date.today().addMonths(-7));

        // Schedule the batch job within the test method
        Test.startTest();
        String CRON_EXP = '0 0 2 ? * SUN *';   // every Sunday at 2 AM
        ScheduleArchiveOldContacts sched = new ScheduleArchiveOldContacts();
        String jobId = System.schedule('Test Schedule', CRON_EXP, sched);
        // Now that the Test.stopTest call will have been made, the job should have run once.
        CronTrigger ctAfter = [SELECT CronExpression FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_EXP, ctAfter.CronExpression);
        Test.stopTest();
    }
}
