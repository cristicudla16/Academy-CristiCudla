@isTest
public class ArchiveOldContactsBatchTest {

    @isTest static void testBatchProcess(){
        // Create test data
        Contact testContact = new Contact(LastName = 'Testerson', Email = null);
        insert testContact;
        
        // Set created date to be 7 months old
        Test.setCreatedDate(testContact.Id, Date.today().addMonths(-7));
        
        // Clear the recycle bin to avoid false positives from previous test runs
        Database.emptyRecycleBin(new List<Contact>{testContact});
        
        // Run batch job
        Test.startTest();
        Database.executeBatch(new ArchiveOldContactsBatch());
        Test.stopTest();
        
        // Verify results
        testContact = [SELECT Id, Is_Archived__c FROM Contact WHERE Id = :testContact.Id];
        System.assert(testContact.Is_Archived__c, 'The Is_Archived__c field should be true');
    }
}
