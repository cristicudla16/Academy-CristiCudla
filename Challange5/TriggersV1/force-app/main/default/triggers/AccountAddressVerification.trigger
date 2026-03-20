trigger AccountAddressVerification on Account (before insert, before update) {
    // Apelăm metoda din clasa creată la Pasul 1
    if (Trigger.isBefore) {
        AccountTriggerHandler.validatePostalCodes(Trigger.new);
    }
}