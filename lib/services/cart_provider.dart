import 'dart:collection';
import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final double price;
  final String imagePath; // Image path for the product
  int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  // ✅ Get all items (read-only)
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  // ✅ Add an item to the cart (or increase quantity if it exists)
  void addItem(String title, double price, String imagePath) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(title: title, price: price, imagePath: imagePath));
    }
    notifyListeners();
  }

  // ✅ Remove an item completely from the cart
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // ✅ Clear the entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ✅ Total price of all items
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  // ✅ Decrease quantity of an item, or remove it if quantity reaches 0
  void decreaseItemQuantity(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // ✅ Increase quantity of an item (if you want separate button support)
  void increaseItemQuantity(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  // ✅ Total number of items in the cart
  int get itemCount => _items.fold(0, (count, item) => count + item.quantity);
}
