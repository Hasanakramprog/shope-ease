import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/services/cart_service.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart'; 
// void main() {
//   runApp(const MyApp());
// }
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartService = CartService();
  await cartService.loadCart();
  await testApiFunction();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(cartService: cartService));
}
Future<void> testApiFunction() async {
  var result = await ApiService().getProducts(); // example
  print(result);
}
class MyApp extends StatelessWidget {
  final CartService cartService;
  const MyApp({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(cartService: cartService),
    );
  }
}