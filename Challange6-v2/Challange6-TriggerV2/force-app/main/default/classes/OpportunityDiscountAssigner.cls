public class OpportunityDiscountAssigner {
    public static void applyDiscounts(List<Opportunity> oppList) {
        for (Opportunity opp : oppList) {
            // Verificăm să avem un Amount valid pentru a evita erori de calcul
            if (opp.Amount != null) {
                if (opp.StageName == 'Prospecting') {
                    opp.Amount = opp.Amount * 0.95;
                } else if (opp.StageName == 'Qualification') {
                    opp.Amount = opp.Amount * 0.90;
                } else if (opp.StageName == 'Negotiation/Review') {
                    opp.Amount = opp.Amount * 0.85;
                }
            }
        }
    }
}