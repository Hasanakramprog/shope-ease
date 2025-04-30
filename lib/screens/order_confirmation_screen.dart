// import 'package:flutter/material.dart';
// import '../models/shipping_address.dart';
// import '../models/payment_method.dart';
// import 'home_screen.dart';

// class OrderConfirmationScreen extends StatelessWidget {
//   final String orderId;
//   final ShippingAddress shippingAddress;
//   final String deliveryOption;
//   final PaymentMethod paymentMethod;

//   const OrderConfirmationScreen({
//     super.key,
//     required this.orderId,
//     required this.shippingAddress,
//     required this.deliveryOption,
//     required this.paymentMethod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Confirmation'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: const Icon(
//                 Icons.check,
//                 color: Colors.white,
//                 size: 60,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Thank you for your order!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Order ID: $orderId',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 32),
//             Container(
//               padding: const EdgeInsets.all(16),
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Order Details',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Divider(),
//                   _buildDetailsRow('Delivery Option', deliveryOption),
//                   _buildDetailsRow('Payment Method', _getPaymentMethodName(paymentMethod)),
//                   const Divider(),
//                   const Text(
//                     'Shipping Address',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(shippingAddress.fullName),
//                   Text(shippingAddress.addressLine1),
//                   if (shippingAddress.addressLine2.isNotEmpty) Text(shippingAddress.addressLine2),
//                   Text('${shippingAddress.city}, ${shippingAddress.state} ${shippingAddress.zipCode}'),
//                   Text(shippingAddress.country),
//                   Text(shippingAddress.phoneNumber),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               'We\'ll email you an order confirmation with details and tracking info.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomeScreen()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Continue Shopping',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailsRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getPaymentMethodName(PaymentMethod method) {
//     switch (method) {
//       case PaymentMethod.creditCard:
//         return 'Credit/Debit Card';
//       case PaymentMethod.paypal:
//         return 'PayPal';
//       case PaymentMethod.applePay:
//         return 'Apple Pay';
//       default:
//         return 'Unknown';
//     }
//   }
// }