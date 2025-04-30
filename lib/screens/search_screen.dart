// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/product.dart';
// import '../widgets/product_card.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final ApiService _apiService = ApiService();
  
//   List<Product> _searchResults = [];
//   bool _isLoading = false;
//   bool _hasSearched = false;

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _searchProducts(String query) async {
//     if (query.trim().isEmpty) return;

//     setState(() {
//       _isLoading = true;
//       _hasSearched = true;
//     });

//     try {
//       // In a real app, you would have a search endpoint or filter from all products
//       final allProducts = await _apiService.getProducts();
      
//       // Filter products that match the search query
//       final results = allProducts.where((product) {
//         return product.title.toLowerCase().contains(query.toLowerCase()) ||
//             product.description.toLowerCase().contains(query.toLowerCase()) ||
//             product.category.toLowerCase().contains(query.toLowerCase());
//       }).toList();

//       setState(() {
//         _searchResults = results;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
      
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error searching products: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: _searchController,
//           decoration: const InputDecoration(
//             hintText: 'Search products...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.grey),
//           ),
//           onSubmitted: _searchProducts,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () => _searchProducts(_searchController.text),
//           ),
//           if (_searchController.text.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _searchResults = [];
//                   _hasSearched = false;
//                 });
//               },
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : !_hasSearched
//               ? const Center(
//                   child: Text('Search for products'),
//                 )
//               : _searchResults.isEmpty
//                   ? const Center(
//                       child: Text('No products found'),
//                     )
//                   : GridView.builder(
//                       padding: const EdgeInsets.all(16),
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 0.75,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                       ),
//                       itemCount: _searchResults.length,
//                       itemBuilder: (context, index) {
//                         return ProductCard(product: _searchResults[index]);
//                       },
//                     ),
//     );
//   }
// }


// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/store.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final Store store;
  final List<Product> products;
  final List<String> categories;

  const SearchScreen({
    super.key,
    required this.store,
    required this.products,
    required this.categories,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Product> _filteredProducts;
  late List<String> _filteredCategories;
  String _searchQuery = '';
  List<String> _recentSearches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
    _filteredCategories = widget.categories;
    _loadRecentSearches();
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // Load recent searches from SharedPreferences
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  // Save a search query to recent searches
  Future<void> _saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Remove if already exists to avoid duplicates
      _recentSearches.remove(query);
      // Add to beginning of list
      _recentSearches.insert(0, query);
      // Keep only the last 5 searches
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
      // Save to storage
      prefs.setStringList('recent_searches', _recentSearches);
    });
  }
  
    // Clear all recent searches
  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = [];
      prefs.remove('recent_searches');
    });
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      
      if (_searchQuery.isEmpty) {
        _filteredProducts = widget.products;
        _filteredCategories = widget.categories;
      } else {
        // Filter products
        _filteredProducts = widget.products.where((product) {
          return product.title.toLowerCase().contains(_searchQuery) ||
                 product.description.toLowerCase().contains(_searchQuery) ||
                 product.category.toLowerCase().contains(_searchQuery);
        }).toList();

        // Filter categories
        _filteredCategories = widget.categories.where((category) {
          return category.toLowerCase().contains(_searchQuery);
        }).toList();

        // Save the search query if it's not empty
        if (_searchQuery.trim().isNotEmpty) {
          _saveSearchQuery(_searchQuery);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search products or categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _search,
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _saveSearchQuery(query);
                }
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildRecentSearches()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: const Text('Clear all'),
                ),
            ],
          ),
        ),
        if (_recentSearches.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No recent searches'),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final search = _recentSearches[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(search),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        _recentSearches.removeAt(index);
                        prefs.setStringList('recent_searches', _recentSearches);
                      });
                    },
                  ),
                  onTap: () {
                    _searchController.text = search;
                    _search(search);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

   Widget _buildSearchResults() {
    if (_filteredProducts.isEmpty && _filteredCategories.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView(
      children: [
        if (_filteredCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ..._filteredCategories.map((category) => ListTile(
              leading: const Icon(Icons.category),
              title: Text(category),
              onTap: () {
                Navigator.pop(context, category);
              },
            )),
        if (_filteredProducts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ..._filteredProducts.map((product) => ListTile(
              leading: Image.network(
                product.thumbnail,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported),
              ),
              title: Text(product.title),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
            )),
      ],
    );
  }
}