class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List<String> images; // now it's a List<String>!
  final double rating;
  final String thumbnail; // <<-- add this
  // final String storeId;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.rating,
    required this.thumbnail, // <<-- add this
    // required this.storeId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'],
      price: _parseDouble(json['price']),
      description: json['description'],
      category: json['category'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      rating: _parseDouble(json['rating']),
      thumbnail: json['thumbnail'], // <<-- add this
      // storeId: json['storeId'],
      
    );
  }
  static double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
      'category': category,
      'images': images,
      // include any other fields
    };
  }

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     id: json['id'],
  //     title: json['title'],
  //     description: json['description'],
  //     price: json['price'],
  //     thumbnail: json['thumbnail'],
  //     rating: json['rating'],
  //     category: json['category'],
  //     // include any other fields
  //   );
  // }
}