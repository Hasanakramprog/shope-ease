import 'package:flutter/material.dart';
import 'package:shop_app/screens/checkout_screen.dart';
import '../services/cart_service.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  final CartService cartService;
  
  const CartScreen({
    super.key, 
    required this.cartService,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (widget.cartService.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearCartDialog(),
            ),
        ],
      ),
      body: _buildCartContent(),
      bottomNavigationBar: widget.cartService.items.isEmpty
          ? null
          : _buildCheckoutBar(),
    );
  }

  Widget _buildCartContent() {
    if (widget.cartService.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.cartService.items.length,
      itemBuilder: (ctx, i) => CartItemCard(
        cartItem: widget.cartService.items[i],
        onIncrease: () => _updateItemQuantity(i, increase: true),
        onDecrease: () => _updateItemQuantity(i, increase: false),
        onRemove: () => _removeItem(i),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${widget.cartService.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to checkout screen
 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CheckoutScreen(
      cartService: widget.cartService,
      storePhoneNumber: '+1234567890', // Your store's WhatsApp number
    ),
  ),
);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateItemQuantity(int index, {required bool increase}) async {
    final productId = widget.cartService.items[index].product.id;
    
    if (increase) {
      await widget.cartService.addItem(widget.cartService.items[index].product);
    } else {
      await widget.cartService.decreaseQuantity(productId);
    }
    
    if (mounted) setState(() {});
  }

  Future<void> _removeItem(int index) async {
    final productId = widget.cartService.items[index].product.id;
    await widget.cartService.removeItem(productId);
    if (mounted) setState(() {});
  }

  Future<void> _showClearCartDialog() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Clear'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    ) ?? false;

    if (shouldClear && mounted) {
      await widget.cartService.clear();
      setState(() {});
    }
  }
}