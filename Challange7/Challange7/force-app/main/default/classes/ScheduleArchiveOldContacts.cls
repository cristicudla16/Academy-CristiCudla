public class ScheduleArchiveOldContacts implements Schedulable {
    public void execute(SchedulableContext sc) {
        ArchiveOldContactsBatch batch = new ArchiveOldContactsBatch();
        // Batch-ul trebuie pornit aici
        Database.executeBatch(batch);
    }
}