import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  final CartService cartService;
  final String storePhoneNumber; // Store's WhatsApp number

  const CheckoutScreen({
    super.key,
    required this.cartService,
    required this.storePhoneNumber,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrderViaWhatsApp() async {
    if (!_formKey.currentState!.validate()) return;

    final itemsText = widget.cartService.items.map((item) {
      return '${item.product.title} (x${item.quantity}) - \$${item.totalPrice.toStringAsFixed(2)}';
    }).join('\n');

    final message = '''
*NEW ORDER* 🛒

*Customer Name:* ${_nameController.text}
*Delivery Address:* ${_addressController.text}

*Order Items:*
$itemsText

*Subtotal:* \$${widget.cartService.totalAmount.toStringAsFixed(2)}
*Notes:* ${_notesController.text}

Please confirm this order.
''';

    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/${widget.storePhoneNumber}?text=$encodedMessage';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      // Clear cart after successful order placement
      await widget.cartService.clear();
      Navigator.of(context).pop();
Navigator.of(context).pop();

      // Navigator.of(context).popUntil((route) => route.isFirst);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.cartService.items.map((item) => ListTile(
                title: Text(item.product.title),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
              )),
              const Divider(),
              ListTile(
                title: const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '\$${widget.cartService.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Order Notes (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _placeOrderViaWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.whatshot, color: Colors.white),
                  label: const Text(
                    'Place Order via WhatsApp',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}