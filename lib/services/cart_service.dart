import 'dart:convert';

import '../models/product.dart';
import '../models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
// class CartService {
//   final List<CartItem> _items = [];

//   List<CartItem> get items => _items;

//   double get totalAmount {
//     return _items.fold(0, (sum, item) => sum + item.totalPrice);
//   }

//   int get itemCount {
//     return _items.fold(0, (sum, item) => sum + item.quantity);
//   }

//   void addItem(Product product) {
//     final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
//     if (existingIndex >= 0) {
//       _items[existingIndex].quantity += 1;
//     } else {
//       _items.add(CartItem(product: product));
//     }
//   }
//     Future<int> getItemCount() async {
//     return _items.length;
//   }

//   void removeItem(int productId) {
//     _items.removeWhere((item) => item.product.id == productId);
//   }

//   void decreaseQuantity(int productId) {
//     final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    
//     if (existingIndex >= 0) {
//       if (_items[existingIndex].quantity > 1) {
//         _items[existingIndex].quantity -= 1;
//       } else {
//         _items.removeAt(existingIndex);
//       }
//     }
//   }

//   void clear() {
//     _items.clear();
//   }
// }

// // services/cart_service.dart
// import '../models/product.dart';

// class CartService {
//   final List<Product> _items = [];

//   Future<void> addItem(Product product) async {
//     _items.add(product);
//     // In a real app, you might want to persist this to local storage
//   }

//   Future<int> getItemCount() async {
//     return _items.length;
//   }

//   Future<List<Product>> getItems() async {
//     return _items;
//   }

//   Future<void> clearCart() async {
//     _items.clear();
//   }
// }
class CartService {
  static const String _cartKey = 'cart_items';
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cartKey);
    
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      _items = jsonList.map((jsonItem) => CartItem.fromJson(jsonItem)).toList();
    }
  }

  Future<void> addItem(Product product) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    await _saveToPrefs();
  }

  Future<int> getItemCount() async {
    return _items.fold<int>(0, (int sum, CartItem item) => sum + item.quantity);
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    await _saveToPrefs();
  }

  Future<void> decreaseQuantity(int productId) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity -= 1;
      } else {
        _items.removeAt(existingIndex);
      }
      await _saveToPrefs();
    }
  }

  Future<void> clear() async {
    _items.clear();
    await _saveToPrefs();
  }
}