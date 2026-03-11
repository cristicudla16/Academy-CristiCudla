@isTest
public class DiscountCalculatorTest {
    
    @isTest
    static void testDiscountApplied() {
        DiscountCalculator calculator = new DiscountCalculator();
        
        // Folosim 100.0 (Decimal) pentru a se potrivi cu semnătura metodei
        Decimal result1 = calculator.calculateDiscount(100.0);
        System.assertEquals(90.0, result1, '10% discount should be applied to 100');
        
        Decimal result2 = calculator.calculateDiscount(200.0);
        System.assertEquals(180.0, result2, '10% discount should be applied to amounts > 100');
    }
    
    @isTest
    static void testNoDiscountApplied() {
        DiscountCalculator calculator = new DiscountCalculator();
        
        Decimal result = calculator.calculateDiscount(50.0);
        System.assertEquals(50.0, result, 'No discount should be applied to amounts < 100');
    }
    
    @isTest
    static void testNullAmount() {
        DiscountCalculator calculator = new DiscountCalculator();
        
        // Testăm cazul de null
        Decimal result = calculator.calculateDiscount(null);
        System.assertEquals(0, result, 'Null amount should return 0');
    }
}
