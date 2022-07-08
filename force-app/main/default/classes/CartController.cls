public with sharing class CartController {
    @AuraEnabled(Cacheable=true)
    public static void addProductToCart(Decimal price, String productId, String flavour,Integer quantity){
        CartItem newItem = new CartItem();
        newItem.productId = productId;
        newItem.price = price;
        newItem.flavour = flavour;
        newItem.quantity = quantity;
        Map<String,CartItem> cartItems = new Map<String,CartItem>();
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');
        if((Map<String,CartItem>)sessionPart.get('cart') != null){
            cartItems = (Map<String,CartItem>)sessionPart.get('cart');
        }
        if(cartItems.keySet().contains(newItem.productId)){
            CartItem dupCartItem = cartItems.get(newItem.productId);
           dupCartItem.quantity += newItem.quantity;
           cartItems.put(newItem.productId,dupCartItem);                   
        } else {
            cartItems.put(newItem.productId,newItem);
        }              
        sessionPart.put('cart', cartItems);
    }
    @AuraEnabled(Cacheable=true)
    public static String getItemsFromCart(){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');
            if((Map<String,CartItem>)sessionPart.get('cart') != null){
                Map<String,CartItem> cartItems = (Map<String,CartItem>)sessionPart.get('cart');
                return JSON.serialize(cartItems.values());
            }
            else {
                return 'error';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void deleteItemFromCart(String productId){
        Map<String,CartItem> cartItems = new Map<String,CartItem>();

        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');
        if((Map<String,CartItem>)sessionPart.get('cart') != null)
        cartItems = (Map<String,CartItem>)sessionPart.get('cart');
        if(cartItems.keySet().contains(productId)){
            cartItems.remove(productId);              
         }
        sessionPart.put('cart', cartItems);
    }
    @AuraEnabled
    public static void changeQuantity(String productId, Integer quantity){
        Map<String,CartItem> cartItems = new Map<String,CartItem>();
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');
        if((Map<String,CartItem>)sessionPart.get('cart') != null)
        cartItems = (Map<String,CartItem>)sessionPart.get('cart');
        if(cartItems.keySet().contains(productId)){
            CartItem dupCartItem = cartItems.get(productId);
            dupCartItem.quantity = quantity;   
            cartItems.put(productId,dupCartItem);
         }
        sessionPart.put('cart', cartItems);
    }
    @AuraEnabled
    public static void clearCart(){
        Map<String,CartItem> cartItems = new Map<String,CartItem>();
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.cartStorage');
        if((Map<String,CartItem>)sessionPart.get('cart') != null)
        cartItems = (Map<String,CartItem>)sessionPart.get('cart');
        cartItems.clear();
        sessionPart.put('cart', cartItems);
    }

    public class CartItem{
        String flavour;
        Decimal price;
        String productId;
        Integer quantity;
    }
}
