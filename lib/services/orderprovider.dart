import 'package:flutter/material.dart';
import 'cart_provider.dart'; // Ensure CartItem is defined here

class OrdersProvider extends ChangeNotifier {
  // Each order is a Map: { 'items': List<CartItem>, 'received': bool }
  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  void addOrder(List<CartItem> cartItems) {
    _orders.add({
      'items': List<CartItem>.from(cartItems), // Defensive copy
      'received': false,
    });
    notifyListeners();
  }

  void markAsReceived(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders[index]['received'] = true;
      notifyListeners();
    }
  }



  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
