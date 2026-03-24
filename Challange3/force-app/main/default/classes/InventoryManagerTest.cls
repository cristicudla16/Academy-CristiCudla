@isTest
private class InventoryManagerTest {

    @isTest 
    static void testAddingNewItem() {
        InventoryManager manager = new InventoryManager();
        manager.addItem('Laptop', 5);
        System.assertEquals(5, manager.getQuantity('Laptop'), 'Cantitatea de Laptop ar trebui să fie 5.');
    }

    @isTest 
    static void testAddingToExistingItem() {
        InventoryManager manager = new InventoryManager();
        manager.addItem('Laptop', 3);
        manager.addItem('Laptop', 2);
        System.assertEquals(5, manager.getQuantity('Laptop'), 'Cantitatea ar trebui să se cumuleze la 5.');
    }

    @isTest 
    static void testRemovingItem() {
        InventoryManager manager = new InventoryManager();
        manager.addItem('Laptop', 5);
        manager.removeItem('Laptop', 2);
        System.assertEquals(3, manager.getQuantity('Laptop'), 'Ar trebui să rămână 3 laptopuri.');
    }

    @isTest 
    static void testRemovingMoreThanCurrentQuantity() {
        InventoryManager manager = new InventoryManager();
        manager.addItem('Mouse', 10);
        manager.removeItem('Mouse', 15);
        System.assertEquals(0, manager.getQuantity('Mouse'), 'Cantitatea nu poate fi negativă, deci trebuie să fie 0.');
    }

    @isTest 
    static void testNullInputs() {
        InventoryManager manager = new InventoryManager();
        // Testăm adăugarea cu null
        manager.addItem(null, 10);
        System.assertEquals(0, manager.getQuantity(null), 'Input-ul null nu ar trebui să creeze iteme.');
        
        // Testăm eliminarea cu null sau item inexistent
        manager.removeItem(null, 5);
        manager.removeItem('Inexistent', 5);
        System.assertEquals(0, manager.getQuantity('Inexistent'), 'Eliminarea din ceva ce nu există returnează 0.');
    }

    @isTest 
    static void testBlankAndNullQuantity() {
        InventoryManager manager = new InventoryManager();
        manager.addItem('Tastatura', null);
        manager.addItem('', 10);
        System.assertEquals(0, manager.getQuantity('Tastatura'), 'Dacă quantity e null, nu se adaugă nimic.');
        System.assertEquals(0, manager.getQuantity(''), 'Dacă numele e gol, nu se adaugă nimic.');
    }
}