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
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      rating: json['rating'].toDouble(),
      thumbnail: json['thumbnail'], // <<-- add this
      // storeId: json['storeId'],
      
    );
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