public class DiscountCalculator {
    public Decimal calculateDiscount(Decimal amount) {
        if (amount == null) {
            return 0;
        }
        if (amount >= 100) {
            return amount * 0.90;
        }
        return amount;
    }
}