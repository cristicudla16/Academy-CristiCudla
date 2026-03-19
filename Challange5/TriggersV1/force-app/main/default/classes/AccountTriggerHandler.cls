public class AccountTriggerHandler {
    
    public static void validatePostalCodes(List<Account> accountList) {
        // Regex for Brazil: 5 digits, optional hyphen, 3 digits
        String brazilRegex = '^[0-9]{5}-?[0-9]{3}$';
        // Regex for Romania: 6 digits
        String romaniaRegex = '^[0-9]{6}$';

        for (Account acc : accountList) {
            if (acc.BillingPostalCode != null) {
                String postalCode = acc.BillingPostalCode;
                
                boolean isValidBrazil = Pattern.matches(brazilRegex, postalCode);
                boolean isValidRomania = Pattern.matches(romaniaRegex, postalCode);
                
                if (!isValidBrazil && !isValidRomania) {
                    acc.BillingPostalCode.addError('The Billing Postal Code must be in a valid Brazilian (00000-000) or Romanian (000000) format.');
                }
            }
        }
    }
}