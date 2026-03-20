public class ScheduleArchiveOldContacts implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Testele se așteaptă ca această clasă să pornească batch-ul de mai sus
        ArchiveOldContactsBatch batch = new ArchiveOldContactsBatch();
        Database.executeBatch(batch);
    }
}