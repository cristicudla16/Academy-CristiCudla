trigger OpportunityTrigger on Opportunity (before insert, before update) {
    if (Trigger.isBefore) {
        // Aceasta este linia critică: trimitem oportunitățile către clasa de logică
        OpportunityDiscountAssigner.applyDiscounts(Trigger.new);
    }
}