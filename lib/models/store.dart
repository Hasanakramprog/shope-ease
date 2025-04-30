// models/store.dart
class Store {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final List<String> categories;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.categories,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id']?.toString() ?? '',
      name: json['name'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      categories: List<String>.from(json['categories']),
    );
  }
}