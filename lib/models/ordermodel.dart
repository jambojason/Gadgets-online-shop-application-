class OrderItem {
  final int? id;
  final String title;
  final double price;
  final int quantity;
  final String imagePath;

  OrderItem({
    this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      quantity: map['quantity'],
      imagePath: map['imagePath'],
    );
  }
}
