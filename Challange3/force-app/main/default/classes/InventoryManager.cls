public with sharing class InventoryManager {
    
    // Map pentru stocarea produselor si cantitatilor
    private Map<String, Item> inventory = new Map<String, Item>();

    private class Item {
        public String name;
        public Integer quantity;

        public Item(String name, Integer quantity) {
            this.name = name;
            this.quantity = quantity;
        }
    }

    public void addItem(String itemName, Integer quantity) {
        if (String.isBlank(itemName) || quantity == null || quantity < 0) {
            return;
        }
        String normalizedName = itemName.toLowerCase();
        if (inventory.containsKey(normalizedName)) {
            inventory.get(normalizedName).quantity += quantity;
        } else {
            inventory.put(normalizedName, new Item(itemName, quantity));
        }
    }

    public void removeItem(String itemName, Integer quantity) {
        if (String.isBlank(itemName) || quantity == null || quantity < 0) {
            return;
        }
        String normalizedName = itemName.toLowerCase();
        if (!inventory.containsKey(normalizedName)) {
            return;
        }
        Item existingItem = inventory.get(normalizedName);
        existingItem.quantity -= quantity;
        if (existingItem.quantity < 0) {
            existingItem.quantity = 0;
        }
    }

    public Integer getQuantity(String itemName) {
        if (String.isBlank(itemName)) {
            return 0;
        }
        String normalizedName = itemName.toLowerCase();
        if (!inventory.containsKey(normalizedName)) {
            return 0;
        }
        return inventory.get(normalizedName).quantity;
    }
}