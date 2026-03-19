@isTest
public class AccountAddressVerificationTest {

    // Helper method to create test accounts
    private static Account createTestAccount(String postalCode) {
        return new Account(Name = 'Test Account', BillingPostalCode = postalCode);
    }

    @isTest
    static void testValidRomanianPostalCode() {
        Account acc = createTestAccount('123456');
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Verify no errors were added
        System.assertEquals(0, acc.getErrors().size(), 'There should be no errors for a valid Romanian postal code.');
    }

    @isTest
    static void testValidBrazilianPostalCodeWithHyphen() {
        Account acc = createTestAccount('12345-678');
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Verify no errors were added
        System.assertEquals(0, acc.getErrors().size(), 'There should be no errors for a valid Brazilian postal code with hyphen.');
    }

    @isTest
    static void testValidBrazilianPostalCodeWithoutHyphen() {
        Account acc = createTestAccount('12345678');
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Verify no errors were added
        System.assertEquals(0, acc.getErrors().size(), 'There should be no errors for a valid Brazilian postal code without hyphen.');
    }

    @isTest
    static void testInvalidPostalCode() {
        Account acc = createTestAccount('ABC123');
        try {
            Test.startTest();
            insert acc;
            System.assert(false, 'Expected an exception due to invalid postal code.');
            Test.stopTest();
        } catch (DmlException e) {
            // Verify that the error message is as expected
            System.assert(e.getMessage().contains('The Billing Postal Code is not in the correct format.'));
        }
    }

    @isTest
    static void testNullPostalCode() {
        Account acc = createTestAccount(null);
        try {
            Test.startTest();
            insert acc;
            System.assert(false, 'Expected an exception due to null postal code.');
            Test.stopTest();
        } catch (DmlException e) {
            // Verify that the error message is as expected
            System.assert(e.getMessage().contains('The Billing Postal Code is not in the correct format.'));
        }
        
    }
}
