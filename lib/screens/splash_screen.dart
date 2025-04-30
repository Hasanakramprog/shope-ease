import 'package:flutter/material.dart';
import 'package:shop_app/screens/store_list_screen.dart';
import 'package:shop_app/services/cart_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
   final CartService cartService;
    const SplashScreen({super.key, required this.cartService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => const HomeScreen()),
        MaterialPageRoute(builder: (context) => StoreListScreen(cartService: widget.cartService,)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(75),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // App Name
            const Text(
              'ShopEase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            // Tagline
            const Text(
              'Your one-stop shopping destination',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}