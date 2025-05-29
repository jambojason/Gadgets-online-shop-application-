import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_database.dart';
import 'package:flutter_application_1/models/product_model.dart.dart';
import 'package:flutter_application_1/services/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductGridPage extends StatefulWidget {
  const ProductGridPage({super.key});

  @override
  State<ProductGridPage> createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = ProductDatabase.instance.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final products = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            _loadProducts();
            setState(() {});
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
  final product = products[index];

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 6,
    shadowColor: Colors.grey.withOpacity(0.5),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: product.imagePath.startsWith('assets/')
                  ? Image.asset(product.imagePath, fit: BoxFit.cover)
                  : Image.file(File(product.imagePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => cart.addItem(product.name, product.price, product.imagePath),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 127, 8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
             child: const Text(
  'Add to Cart',
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 0, 0, 0), 
  ),
),

            ),
          ),
        ],
      ),
    ),
  );
},

          ),
        );
      },
    );
  }
}
