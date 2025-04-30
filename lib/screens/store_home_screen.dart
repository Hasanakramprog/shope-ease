// // screens/store_home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:shop_app/models/product.dart';
// import 'package:shop_app/models/store.dart';
// import 'package:shop_app/screens/cart_screen.dart';
// import 'package:shop_app/services/api_service.dart';
// import 'package:shop_app/widgets/category_chips.dart';
// import 'package:shop_app/widgets/product_grid.dart';
// class StoreHomeScreen extends StatefulWidget {
//   final Store store;

//   const StoreHomeScreen({super.key, required this.store});

//   @override
//   State<StoreHomeScreen> createState() => _StoreHomeScreenState();
// }

// class _StoreHomeScreenState extends State<StoreHomeScreen> {
//   final ApiService _apiService = ApiService();
//   List<Product> products = [];
//   List<String> categories = [];
//   String? selectedCategory;
//   bool isLoading = true;
//   String errorMessage = '';
//     int cartItemCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadStoreData();
//   }

//   Future<void> _loadStoreData() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = '';
//       });
      
//       final productsList = await _apiService.getProducts();
//       final categoriesList = await _apiService.getCategories();
      
//       setState(() {
//         products = productsList;
//         categories = categoriesList;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error loading store data: $e';
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
//                   onRefresh: _loadStoreData,
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



// screens/store_home_screen.dart
import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/store.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/search_screen.dart';
// import 'package:shop_app/screens/wishlist_screen.dart';
// import 'package:shop_app/screens/profile_screen.dart';
import 'package:shop_app/services/api_service.dart';
import 'package:shop_app/services/cart_service.dart';
import 'package:shop_app/widgets/category_chips.dart';
import 'package:shop_app/widgets/product_grid.dart';

class StoreHomeScreen extends StatefulWidget {
  final Store store;
  final CartService cartService;
  final String? selectedCategory;

  StoreHomeScreen({super.key, required this.store, required this.cartService, this.selectedCategory});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final ApiService _apiService = ApiService();
  // final CartService _cartService = CartService();
  List<Product> products = [];
  List<String> categories = [];
  String? selectedCategory;
  bool isLoading = true;
  String errorMessage = '';
  int cartItemCount = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
    _loadCartCount();
  }

  Future<void> _loadStoreData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      
      final productsList = await _apiService.getProducts();
      final categoriesList = await _apiService.getCategories();
      
      setState(() {
        products = productsList;
        categories = categoriesList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading store data: $e';
        isLoading = false;
      });
    }
  }

 Future<void> _loadCartCount() async {
    final count = await widget.cartService.getItemCount();
    if (mounted) {
      setState(() => cartItemCount = count);
    }
  }

  Future<void> _filterByCategory(String? category) async {
    setState(() {
      isLoading = true;
      selectedCategory = category;
    });

    try {
      final List<Product> filteredProducts;
      if (category == null) {
        // filteredProducts = await _apiService.getProductsByStore(widget.store.id);
        // filteredProducts = await _apiService.getProductsByCategory(widget.store.id);
        filteredProducts = await _apiService.getProductsByCategory("Beauty"
        );
      } else {
        filteredProducts = await _apiService.getProductsByCategory(
          category,
        );
      }

      setState(() {
        products = filteredProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error filtering products: $e';
        isLoading = false;
      });
    }
  }

Future<void> _onAddToCart(Product product) async {
    await widget.cartService.addItem(product);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
      await _loadCartCount(); // Refresh the count
    }
  }

  // void _onSearchPressed() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SearchScreen(
  //         store: widget.store,
  //         products: products,
  //         categories: categories,
  //       ),
  //     ),
  //   );
  // }

  Future<void> _onSearchPressed() async {
  final returnedCategory = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchScreen(
        store: widget.store,
        products: products,
        categories: categories,
      ),
    ),
  );

  if (returnedCategory != null) {
    // Handle the returned category (e.g., filter products, update UI)
    // print("Received category: $returnedCategory");
    _filterByCategory(returnedCategory);
    // Example: Filter products by category
    // setState(() { ... });
  }
}

  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Categories - handled in body
        break;
      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const WishlistScreen()),
        // );
        break;
      case 3:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
        // );
        break;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.store.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
          IconButton(
            icon: Badge(
              label: Text(cartItemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cartService: widget.cartService)),
              ).then((_) => _loadCartCount());
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: // Home
        return _buildHomeContent();
      case 1: // Categories
        return _buildCategoriesContent();
      default:
        return Container(); // Shouldn't happen as we navigate for other tabs
    }
  }

  Widget _buildHomeContent() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            : RefreshIndicator(
                onRefresh: _loadStoreData,
                child: Column(
                  children: [
                    CategoryChips(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        _filterByCategory(category);
                      },
                    ),
                    Expanded(
                      child: ProductGrid(
                        products: products,
                        onAddToCart: _onAddToCart,
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildCategoriesContent() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category),
          onTap: () {
            setState(() {
              _currentIndex = 0;
              selectedCategory = category;
            });
            _filterByCategory(category);
          },
        );
      },
    );
  }
}