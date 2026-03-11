public class DiscountCalculator{
    public Decimal calculateDiscount(Decimal amount,String discountCode)
{
    if (amount ==null){
        return amount;
    }
    Decimal finalAmount= amount;

    if(amount>=100 && amount <=200){
        finalAmount= amount * 0.90;
    } else if(amount >200 && amount <500){
        finalAmount= amount * 0.85;
    } else if(amount >=500){
        finalAmount= amount * 0.80;
    }
    if (discountCode != null && discountCode == 'OSF5') {
            finalAmount = finalAmount * 0.95;
        }

    return finalAmount;

}
}