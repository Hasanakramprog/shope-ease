// import 'package:flutter/material.dart';
// import '../widgets/product_grid.dart';
// import '../widgets/category_chips.dart';
// import '../services/api_service.dart';
// import '../models/product.dart';
// import 'cart_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService _apiService = ApiService();
//   List<Product> products = [];
//   List<String> categories = [];
//   String? selectedCategory;
//   bool isLoading = true;
//   String errorMessage = '';
//   int cartItemCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = '';
//       });
      
//       // Load products and categories
//       final productsList = await _apiService.getProducts();
//       final categoriesList = await _apiService.getCategories();
      
//       setState(() {
//         products = productsList;
//         categories = categoriesList;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error loading data: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _filterByCategory(String? category) async {
//     setState(() {
//       isLoading = true;
//       selectedCategory = category;
//     });

//     try {
//       final List<Product> filteredProducts;
//       if (category == null) {
//         filteredProducts = await _apiService.getProducts();
//       } else {
//         filteredProducts = await _apiService.getProductsByCategory(category);
//       }

//       setState(() {
//         products = filteredProducts;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error filtering products: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'ShopEase',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // TODO: Implement search functionality
//             },
//           ),
//           IconButton(
//             icon: Badge(
//               label: Text(cartItemCount.toString()),
//               child: const Icon(Icons.shopping_cart),
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CartScreen()),
//               );
//             },
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
//               : RefreshIndicator(
//                   onRefresh: _loadData,
//                   child: Column(
//                     children: [
//                       // Categories
//                       CategoryChips(
//                         categories: categories,
//                         selectedCategory: selectedCategory,
//                         onCategorySelected: (category) {
//                           _filterByCategory(category);
//                         },
//                       ),
                      
//                       // Products Grid
//                       Expanded(
//                         child: ProductGrid(products: products),
//                       ),
//                     ],
//                   ),
//                 ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: 0,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_border),
//             label: 'Wishlist',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
