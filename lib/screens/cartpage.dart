// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/cart_provider.dart';
import 'package:flutter_application_1/services/orderprovider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Your Order'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.imagePath.startsWith('assets/')
                        ? Image.asset(
                            item.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          )
                        : Image.file(
                            File(item.imagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(item.title),
                  subtitle: Text('\$${item.price} x ${item.quantity}'),
                  trailing: TextButton(
                    onPressed: () {
                      cart.removeItem(item);
                      Navigator.pop(context);
                      _showCheckoutDialog(context, cart); // refresh dialog
                    },
                    child: const Text(
                      'cancel order',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (cart.items.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  final ordersProvider =
                      Provider.of<OrdersProvider>(context, listen: false);

                  ordersProvider.addOrder(List<CartItem>.from(cart.items));
                  Navigator.pop(context);
                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 212, 148, 9)),
                child: const Text('Place Order'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 215, 213), // Soft gray-blue background
      appBar: AppBar(
        title: const Text(
          "Your Cart",
          style: TextStyle(color: Color.fromARGB(255, 33, 22, 3)),
        ),
        backgroundColor: const Color.fromARGB(255, 186, 120, 13), // Dark blue-gray
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.imagePath.startsWith('assets/')
                              ? Image.asset(
                                  item.imagePath,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image),
                                )
                              : Image.file(
                                  File(item.imagePath),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(item.title),
                        subtitle: Text('\$${item.price} x ${item.quantity}'),
                        trailing: Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
          ),
          if (cart.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 237, 141, 6).withOpacity(0.95),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showCheckoutDialog(context, cart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
