// import 'package:shop_app/models/product.dart';

// class CartItem {
//   final Product product;
//   int quantity;

//   CartItem({
//     required this.product,
//     this.quantity = 1,
//   });

//   double get totalPrice => product.price * quantity;
// } 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/product.dart';
import 'dart:convert';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}