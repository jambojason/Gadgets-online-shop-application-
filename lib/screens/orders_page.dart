import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/cart_provider.dart';
import 'package:flutter_application_1/services/orderprovider.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 140, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 245, 235),
      body: orders.isEmpty
          ? const Center(child: Text('No orders placed yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, orderIndex) {
                final orderData = orders[orderIndex];
                final items = orderData['items'] as List<CartItem>;
                final received = orderData['received'] as bool;

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 4,
                  child: ExpansionTile(
                    title: Text(
                      'Order ${orderIndex + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    children: [
                      ...items.map((item) {
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
                          subtitle: Text(
                              '\$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                          trailing: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      if (!received)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                           onPressed: () {
  Future.microtask(() {
    Provider.of<OrdersProvider>(context, listen: false)
        .markAsReceived(orderIndex);
  });

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Success"),
      content: const Text("Order received successfully."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
},
            label: const Text("Order Received"),
                          ),
                        ),
                      if (received)
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Order Received ✔",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
