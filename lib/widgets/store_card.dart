import 'package:flutter/material.dart';
import 'package:shop_app/models/store.dart';
import 'package:shop_app/screens/store_home_screen.dart';
import 'package:shop_app/services/cart_service.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final CartService cartService;
   const StoreCard({
    super.key,
    required this.store,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreHomeScreen(store: store,cartService: cartService,),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  store.logoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Handling errors when the image fails to load
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error, // Icon when image fails
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                store.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
