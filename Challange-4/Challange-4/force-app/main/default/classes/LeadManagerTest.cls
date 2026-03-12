
@isTest
private class LeadManagerTest {

    // Helper method to create a lead with given criteria
    private static Lead createTestLead(String lastName, String companyName, String status, Decimal annualRevenue) {
        Lead lead = new Lead(
            LastName = lastName,
            Company = companyName,
            Status = status,
            AnnualRevenue = annualRevenue
        );
        return lead;
    }

    @isTest static void testQualifiedLeadsConversion() {
        Lead qualifiedLead = createTestLead('HighValue', 'HighTech', 'Open - Not Contacted', 150000);
        insert qualifiedLead;

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(new List<Lead>{qualifiedLead});
        Test.stopTest();

        Lead postConversionLead = [SELECT Conversion_Status__c FROM Lead WHERE Id = :qualifiedLead.Id];
        System.assertEquals('Converted', postConversionLead.Conversion_Status__c, 'The lead conversion status should be set to Converted.');
    }

    @isTest static void testNonQualifiedLeads_NoRevenue() {
        Lead nonQualifiedLead = createTestLead('LowValue', 'LowTech', 'Open - Not Contacted', 0);
        insert nonQualifiedLead;

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(new List<Lead>{nonQualifiedLead});
        Test.stopTest();

        Lead postConversionLead = [SELECT Conversion_Status__c FROM Lead WHERE Id = :nonQualifiedLead.Id];
        System.assertEquals(null, postConversionLead.Conversion_Status__c, 'The lead conversion status should remain null.');
    }

    @isTest static void testNonQualifiedLeads_WrongStatus() {
        Lead leadWrongStatus = createTestLead('WrongStatus', 'NoConvert', 'Working - Contacted', 200000);
        insert leadWrongStatus;

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(new List<Lead>{leadWrongStatus});
        Test.stopTest();

        Lead postConversionLead = [SELECT Conversion_Status__c FROM Lead WHERE Id = :leadWrongStatus.Id];
        System.assertEquals(null, postConversionLead.Conversion_Status__c, 'The lead conversion status should remain null.');
    }

    @isTest
    static void testBulkLeadConversion() {
        List<Lead> leads = new List<Lead>{
            createTestLead('BulkQual1', 'BulkComp1', 'Open - Not Contacted', 500000),
            createTestLead('BulkQual2', 'BulkComp2', 'Open - Not Contacted', 100001),
            createTestLead('BulkUnqual', 'BulkComp3', 'Working - Contacted', 120000)
        };
        insert leads;
    
        Test.startTest();
        LeadManager.qualifyAndConvertLeads(leads);
        Test.stopTest();
    
        List<Lead> postConversionLeads = [SELECT LastName, Conversion_Status__c FROM Lead WHERE Id IN :leads];
        System.assertEquals(3, postConversionLeads.size(), 'There should be three leads after conversion.');
    
        Integer convertedLeadsCount = 0;
        for (Lead l : postConversionLeads) {
            if (l.Conversion_Status__c == 'Converted') {
                convertedLeadsCount++;
            }
        }
        System.assertEquals(2, convertedLeadsCount, 'There should be two converted leads.');
    }

    @isTest static void testNoLeadsPassed() {
        List<Lead> emptyLeadsList = new List<Lead>();

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(emptyLeadsList);
        Test.stopTest();

        Integer contactCount = [SELECT count() FROM Contact];
        Integer opportunityCount = [SELECT count() FROM Opportunity];
        System.assertEquals(0, contactCount, 'No contacts should be created.');
        System.assertEquals(0, opportunityCount, 'No opportunities should be created.');
    }

    @isTest static void testLeadConvertResultHandling() {
        Lead qualifiedLead = createTestLead('ResultHandling', 'ResultInc', 'Open - Not Contacted', 150000);
        insert qualifiedLead; 

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(new List<Lead>{qualifiedLead});
        Test.stopTest();

        Lead postConversionLead = [SELECT Conversion_Status__c FROM Lead WHERE Id = :qualifiedLead.Id];
        System.assertEquals('Converted', postConversionLead.Conversion_Status__c, 'The lead conversion status should be set to Converted.');
    }
}