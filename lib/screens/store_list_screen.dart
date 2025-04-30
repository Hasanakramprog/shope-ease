// screens/store_list_screen.dart
import 'package:flutter/material.dart';
import 'package:shop_app/models/store.dart';
import 'package:shop_app/services/cart_service.dart';
import 'package:shop_app/widgets/store_card.dart';
import '../services/api_service.dart';
class StoreListScreen extends StatefulWidget {
  final CartService cartService;
  const StoreListScreen({super.key, required this.cartService});

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final ApiService _apiService = ApiService();
  List<Store> stores = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStores();
    
  }

  Future<void> _loadStores() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      
      final storesList = await _apiService.getStores();
      
      setState(() {
        stores = storesList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading stores: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stores')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return StoreCard(store: store,cartService: widget.cartService,);
                  },
                ),
    );
  }
}