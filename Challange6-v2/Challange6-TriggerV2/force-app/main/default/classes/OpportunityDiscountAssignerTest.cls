@isTest
private class OpportunityDiscountAssignerTest {

    // Helper method to create a test Opportunity
    private static Opportunity createTestOpportunity(String stage, Decimal amount) {
        return new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = System.today().addMonths(1),
            StageName = stage,
            Amount = amount
        );
    }

    @isTest static void testNoDiscount() {
        Opportunity opp = createTestOpportunity('Closed Won', 10000);
        Test.startTest();
        insert opp;
        Test.stopTest();
        opp = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(10000, opp.Amount);
    }

    @isTest static void testProspectingDiscount() {
        Opportunity opp = createTestOpportunity('Prospecting', 20000);
        Test.startTest();
        insert opp;
        Test.stopTest();
        opp = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(20000 * 0.95, opp.Amount);
    }

    @isTest static void testQualificationDiscount() {
        Opportunity opp = createTestOpportunity('Qualification', 10000);
        Test.startTest();
        insert opp;
        Test.stopTest();
        opp = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(10000 * 0.90, opp.Amount);
    }

    @isTest static void testNegotiationReviewDiscount() {
        Opportunity opp = createTestOpportunity('Negotiation/Review', 50000);
        Test.startTest();
        insert opp;
        Test.stopTest();
        opp = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(50000 * 0.85, opp.Amount);
    }

    @isTest static void testBulkDiscounts() {
        List<Opportunity> opps = new List<Opportunity>{
            createTestOpportunity('Prospecting', 15000),
            createTestOpportunity('Negotiation/Review', 30000),
            createTestOpportunity('Closed Lost', 50000)
        };
        Test.startTest();
        insert opps;
        Test.stopTest();

        Map<Id, Opportunity> oppsById = new Map<Id, Opportunity>([
            SELECT Id, Amount, StageName FROM Opportunity WHERE Id IN :opps
        ]);
        System.assertEquals(15000 * 0.95, oppsById.get(opps[0].Id).Amount);
        System.assertEquals(30000 * 0.85, oppsById.get(opps[1].Id).Amount);
        System.assertEquals(50000, oppsById.get(opps[2].Id).Amount); // No discount applied
    }
}
