import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/store.dart'; // make sure paths are correct

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

 Future<List<Product>> getProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/products'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> productsList = data['products']; // access the list inside the map
    return productsList.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}


  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productsList = data['products'];
      return productsList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for category');
    }
  }

Future<List<String>> getCategories() async {
  final response = await http.get(Uri.parse('$baseUrl/products/categories'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map<String>((item) => item['slug'] as String).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
// Dummy data
  final List<Store> _dummyStores = [
    Store(
      id: '1',
      name: 'Dummy Store 1',
      description: 'This is the description for Store 1.',
      logoUrl: 'https://media.istockphoto.com/id/912819604/vector/storefront-flat-design-e-commerce-icon.jpg?s=612x612&w=0&k=20&c=_x_QQJKHw_B9Z2HcbA2d1FH1U1JVaErOAp2ywgmmoTI=',
      categories: ['Electronics', 'Fashion'],
    ),
    Store(
      id: '2',
      name: 'Dummy Store 2',
      description: 'This is the description for Store 2.',
      logoUrl: 'https://media.istockphoto.com/id/912819604/vector/storefront-flat-design-e-commerce-icon.jpg?s=612x612&w=0&k=20&c=_x_QQJKHw_B9Z2HcbA2d1FH1U1JVaErOAp2ywgmmoTI=',
      categories: ['Home', 'Garden'],
    ),
  ];

  // final Map<String, List<Product>> _dummyProducts = {
  //   '1': [
  //     Product(
  //       id: 'p1',
  //       name: 'Product 1',
  //       description: 'Description for Product 1',
  //       imageUrl: 'https://example.com/product1.png',
  //       price: 29.99,
  //     ),
  //     Product(
  //       id: 'p2',
  //       name: 'Product 2',
  //       description: 'Description for Product 2',
  //       imageUrl: 'https://example.com/product2.png',
  //       price: 59.99,
  //     ),
  //   ],
  //   '2': [
  //     Product(
  //       id: 'p3',
  //       name: 'Product 3',
  //       description: 'Description for Product 3',
  //       imageUrl: 'https://example.com/product3.png',
  //       price: 19.99,
  //     ),
  //   ],
  // };

  Future<List<Store>> getStores() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return _dummyStores;
  }

  // Future<List<Product>> getProductsByStore(String storeId) async {
  //   await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
  //   return _dummyProducts[storeId] ?? [];
  // }

  Future<List<String>> getStoreCategories(String storeId) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    final store = _dummyStores.firstWhere(
      (store) => store.id == storeId,
      orElse: () => Store(
        id: '',
        name: '',
        description: '',
        logoUrl: '',
        categories: [],
      ),
    );
    return store.categories;
  }

}