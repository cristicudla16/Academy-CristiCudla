
@isTest
public class DiscountCalculatorTest {
    
    @isTest
    static void testAmountLessThan100() {
        DiscountCalculator calc = new DiscountCalculator();
        // Sub 100, fără cod
        System.assertEquals(50.0, calc.calculateDiscount(50.0, null), 'No discount under 100');
        // Sub 100, cu codul OSF5 (doar 5% reducere aplicată)
        System.assertEquals(47.5, calc.calculateDiscount(50.0, 'OSF5'), '5% extra discount under 100');
    }
    
    @isTest
    static void testTier10Percent() {
        DiscountCalculator calc = new DiscountCalculator();
        // Între 100 și 200 (10% reducere)
        System.assertEquals(90.0, calc.calculateDiscount(100.0, 'INVALID'), '10% for 100');
        System.assertEquals(180.0, calc.calculateDiscount(200.0, null), '10% for 200');
        // Între 100 și 200, cu cod OSF5 (10% + 5% extra)
        System.assertEquals(85.5, calc.calculateDiscount(100.0, 'OSF5'), '10% + 5% for 100');
    }
    
    @isTest
    static void testTier15Percent() {
        DiscountCalculator calc = new DiscountCalculator();
        // Peste 200 și sub 500 (15% reducere)
        System.assertEquals(255.0, calc.calculateDiscount(300.0, null), '15% for 300');
        // Peste 200 și sub 500, cu cod OSF5 (15% + 5% extra)
        System.assertEquals(242.25, calc.calculateDiscount(300.0, 'OSF5'), '15% + 5% for 300');
    }
    
    @isTest
    static void testTier20Percent() {
        DiscountCalculator calc = new DiscountCalculator();
        // Peste sau egal cu 500 (20% reducere)
        System.assertEquals(400.0, calc.calculateDiscount(500.0, null), '20% for 500');
        // Peste 500, cu cod OSF5 (20% + 5% extra)
        System.assertEquals(380.0, calc.calculateDiscount(500.0, 'OSF5'), '20% + 5% for 500');
    }
    
    @isTest
    static void testNullAmount() {
        DiscountCalculator calc = new DiscountCalculator();
        // Testăm input-ul null
        System.assertEquals(null, calc.calculateDiscount(null, 'OSF5'), 'Null amount should return null');
    }
}