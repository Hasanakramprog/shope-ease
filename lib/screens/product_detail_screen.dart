// import 'package:flutter/material.dart';
import '../models/product.dart';
// import '../services/cart_service.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final Product product;
//   final CartService cartService = CartService();
//   final PageController _pageController = PageController();

//   ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border),
//             onPressed: () {
//               // TODO: Add to wishlist functionality
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               // TODO: Share product functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Images (Image Slider)
//             SizedBox(
//               height: 300,
//               width: double.infinity,
//               child: Stack(
//                 children: [
//                   // PageView for Image Slider
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: product.images.length,
//                     itemBuilder: (context, index) {
//                       return Image.network(
//                         product.images[index],
//                         fit: BoxFit.contain,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) {
//                             return child; // Image loaded
//                           }
//                           return Center(
//                             child: CircularProgressIndicator(
//                               value: loadingProgress.expectedTotalBytes != null
//                                   ? (loadingProgress.cumulativeBytesLoaded /
//                                       (loadingProgress.expectedTotalBytes ?? 1))
//                                   : null,
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Center(
//                             child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//                           );
//                         },
//                       );
//                     },
//                   ),
                  
//                   // Left Arrow (Navigate to previous image)
//                   Positioned(
//                     left: 20,
//                     top: MediaQuery.of(context).size.height / 2 - 25,
//                     child: GestureDetector(
//                       onTap: () {
//                         _pageController.previousPage(
//                           duration: Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: Colors.black.withOpacity(0.5),
//                         child: Icon(Icons.arrow_left, color: const Color.fromARGB(255, 124, 15, 15)),
//                       ),
//                     ),
//                   ),

//                   // Right Arrow (Navigate to next image)
//                   Positioned(
//                     right: 20,
//                     top: MediaQuery.of(context).size.height / 2 - 25,
//                     child: GestureDetector(
//                       onTap: () {
//                         _pageController.nextPage(
//                           duration: Duration(milliseconds: 300),
//                           curve: Curves.ease,
//                         );
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: Colors.black.withOpacity(0.5),
//                         child: Icon(Icons.arrow_right, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Product Info
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.title,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade100,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.star, color: Colors.green, size: 16),
//                             const SizedBox(width: 4),
//                             Text(
//                               product.rating.toString(),
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Category: ${product.category}',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     '\$${product.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Description',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     product.description,
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
      
//       // Bottom Button (Add to Cart)
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, -3),
//             ),
//           ],
//         ),
//         child: ElevatedButton(
//           onPressed: () {
//             cartService.addItem(product);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Product added to cart'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text(
//             'Add to Cart',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// import 'package:photo_view/photo_view_image_raw.dart'; // to load images directly

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final PageController _pageController = PageController();

  ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images (Image Viewer Slider)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
  children: [
    PhotoViewGallery.builder(
      itemCount: product.images.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(product.images[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(color: Colors.black),
      pageController: _pageController,
    ),

    // Left Arrow
    Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () {
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
        ),
      ),
    ),

    // Right Arrow
    Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ),
        ),
      ),
    ),
  ],
)
,
            ),

            // Product Info (Description, Price, etc.)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Category: ${product.category}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
