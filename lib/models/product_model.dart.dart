class Product {
  final int? id;
  final String name;
  final double price;
  final String imagePath;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imagePath': imagePath,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imagePath: json['imagePath'] as String,
      );
}
