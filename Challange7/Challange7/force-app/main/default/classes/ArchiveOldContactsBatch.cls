public class ArchiveOldContactsBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Căutăm contacte modificate acum mai mult de 6 luni cu email gol
        DateTime sixMonthsAgo = DateTime.now().addMonths(-6);
        
        return Database.getQueryLocator([
            SELECT Id, Is_Archived__c 
            FROM Contact 
            WHERE Email = NULL 
            AND LastModifiedDate < :sixMonthsAgo
            AND Is_Archived__c = false
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for (Contact con : scope) {
            con.Is_Archived__c = true;
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed.');
    }
}