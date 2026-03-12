public with sharing class LeadManager {
    public static void qualifyAndConvertLeads(List<Lead> leadsToQualify) {
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        List<Lead> leadsToUpdate = new List<Lead>();
        
        // Luăm statusul de conversie
        List<LeadStatus> convertStatuses = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        if (convertStatuses.isEmpty()) return;
        
        String statusLabel = convertStatuses[0].MasterLabel;

        for (Lead l : leadsToQualify) {
            // Logica: Status Open și Revenue > 100k
            if (l.Status == 'Open - Not Contacted' && l.AnnualRevenue > 100000) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);
                lc.setConvertedStatus(statusLabel);
                leadsToConvert.add(lc);
                
                // Populăm câmpul cerut de test
                leadsToUpdate.add(new Lead(Id = l.Id, Conversion_Status__c = 'Converted'));
            }
        }

        if (!leadsToConvert.isEmpty()) {
            Database.convertLead(leadsToConvert);
            update leadsToUpdate;
        }
    }
}