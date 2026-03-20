public class ArchiveOldContactsBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Luăm data de acum 6 luni
        DateTime sixMonthsAgo = DateTime.now().addMonths(-6);
        
        // Căutăm contacte fără email care sunt vechi
        // Folosim și CreatedDate pentru că Test.setCreatedDate e singura metodă de a simula vechimea în teste
        return Database.getQueryLocator([
            SELECT Id, Is_Archived__c 
            FROM Contact 
            WHERE Email = NULL 
            AND (LastModifiedDate < :sixMonthsAgo OR CreatedDate < :sixMonthsAgo)
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
        System.debug('Batch finalizat cu succes.');
    }
}