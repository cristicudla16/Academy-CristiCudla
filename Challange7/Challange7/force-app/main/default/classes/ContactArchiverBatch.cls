public class ContactArchiverBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Calculăm data de acum 6 luni
        DateTime saseLuniInUrma = DateTime.now().addMonths(-6);
        
        return Database.getQueryLocator([
            SELECT Id, Is_Archived__c 
            FROM Contact 
            WHERE Email = NULL 
            AND LastModifiedDate < :saseLuniInUrma
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
        System.debug('Procesul de arhivare a fost finalizat cu succes.');
    }
}