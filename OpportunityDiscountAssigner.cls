public class OpportunityDiscountAssigner {
    
    public static void applyDiscounts(List<Opportunity> oppList) {
        for (Opportunity opp : oppList) {
            // Verificăm dacă există o valoare în câmpul Amount pentru a evita erori de tip NullPointerException
            if (opp.Amount != null) {
                switch on opp.StageName {
                    when 'Prospecting' {
                        opp.Amount *= 0.95; // 5% discount
                    }
                    when 'Qualification' {
                        opp.Amount *= 0.90; // 10% discount
                    }
                    when 'Negotiation/Review' {
                        opp.Amount *= 0.85; // 15% discount
                    }
                    when else {
                        // Nu se aplică nicio reducere pentru alte stadii
                    }
                }
            }
        }
    }
}