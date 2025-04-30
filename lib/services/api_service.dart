import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/store.dart';

class ApiService {
  // Configuration to switch between APIs
  static const bool useDjangoAPI = false; // Set to true to use Django API, false for dummyjson
  
  // Base URLs
  static const String dummyJsonBaseUrl = 'https://dummyjson.com';
  static const String djangoBaseUrl = 'http://10.0.2.2:8000/api'; // Replace with your Django API URL

  String get baseUrl => useDjangoAPI ? djangoBaseUrl : dummyJsonBaseUrl;

  /// Fetches all products from the API
  /// For Django API: Expects endpoint at '/products/' with GET method
  /// For dummyjson: Uses '/products' endpoint
  Future<List<Product>> getProducts() async {
    if (useDjangoAPI) {
      // Django API implementation
      final response = await http.get(Uri.parse('$baseUrl/products/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else  {
        var r=response.statusCode;
        throw Exception('Failed to load products from Django API');
      }
    } else {
      // dummyjson implementation
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsList = data['products'];
        return productsList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products from dummyjson');
      }
    }
  }

  /// Fetches products by category
  /// For Django API: Expects endpoint at '/products/category/{category}/' with GET method
  /// For dummyjson: Uses '/products/category/$category' endpoint
  Future<List<Product>> getProductsByCategory(String category) async {
    if (useDjangoAPI) {
    final response = await http.get(Uri.parse('$baseUrl/products/?category=$category'));
  
  if (response.statusCode == 200) {
  final List<dynamic> data = json.decode(response.body);
      
       return data.map((item) {
        // Convert each field to the correct type
        return Product.fromJson({
          'id': item['id'].toString(),
          'title': item['title'].toString(),
          'price': item['price'].toString(), // Ensure string for _parseDouble
          'description': item['description'].toString(),
          'category': item['category'].toString(),
          'images': (item['images'] as List).map((e) => e.toString()).toList(),
          'rating': item['rating'], // Can be num or string
          'thumbnail': item['thumbnail'].toString(),
          'storeId': item['store']?.toString(),
        });
      }).toList();
    
  } else {
    throw Exception('Failed to load products for category');
  }
    } else {
      final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsList = data['products'];
        return productsList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products by category from dummyjson');
      }
    }
  }

  /// Fetches all available categories
  /// For Django API: Expects endpoint at '/products/categories/' with GET method
  /// For dummyjson: Uses '/products/categories' endpoint
  Future<List<String>> getCategories({String? storeId}) async {
    if (useDjangoAPI) {
      final response = await http.get(Uri.parse('$baseUrl/categories/?store=$storeId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<String>((item) {
          if (item is String) return item;
          if (item is Map && item.containsKey('name')) return item['name'].toString();
          return item.toString();
        }).toList();
      } else {
        throw Exception('Failed to load categories from Django API');
      }
    } else {
      final response = await http.get(Uri.parse('$baseUrl/products/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<String>((item) => item['slug'].toString()).toList();
      } else {
        throw Exception('Failed to load categories from dummyjson');
      }
    }
  }

  // Dummy data methods - These would need to be replaced with actual Django API implementations
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

  /// Fetches all stores
  /// For Django API: Expects endpoint at '/stores/' with GET method
  /// Currently using dummy data - replace with actual API call
  Future<List<Store>> getStores() async {
    if (useDjangoAPI) {
      // TODO: Implement actual Django API call
      final response = await http.get(Uri.parse('$baseUrl/stores/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Store.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load stores from Django API');
      }
    } else {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      return _dummyStores;
    }
  }

  /// Fetches categories for a specific store
  /// For Django API: Expects endpoint at '/stores/{storeId}/categories/' with GET method
  /// Currently using dummy data - replace with actual API call
  Future<List<String>> getStoreCategories(String storeId) async {
    if (useDjangoAPI) {
      // TODO: Implement actual Django API call
      final response = await http.get(Uri.parse('$baseUrl/stores/$storeId/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<String>((item) => item.toString()).toList();
      } else {
        throw Exception('Failed to load store categories from Django API');
      }
    } else {
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
}