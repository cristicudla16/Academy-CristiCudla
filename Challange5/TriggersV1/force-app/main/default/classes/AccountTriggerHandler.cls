public class AccountTriggerHandler {
    
    public static void validatePostalCodes(List<Account> accountList) {
        // Regex clar pentru Brazilia si Romania
        String brazilRegex = '^[0-9]{5}-?[0-9]{3}$';
        String romaniaRegex = '^[0-9]{6}$';
        // Mesajul trebuie sa fie IDENTIC cu cel din test
        String errorMessage = 'The Billing Postal Code is not in the correct format.';

        for (Account acc : accountList) {
            String postalCode = acc.BillingPostalCode;
            
            // 1. Daca e null, trebuie sa dea eroare (pentru testNullPostalCode)
            if (postalCode == null) {
                acc.BillingPostalCode.addError(errorMessage);
            } 
            else {
                boolean isValidBrazil = Pattern.matches(brazilRegex, postalCode);
                boolean isValidRomania = Pattern.matches(romaniaRegex, postalCode);
                
                // 2. Daca nu e valid, trebuie sa dea eroare (pentru testInvalidPostalCode)
                if (!isValidBrazil && !isValidRomania) {
                    acc.BillingPostalCode.addError(errorMessage);
                }
            }
        }
    }
}