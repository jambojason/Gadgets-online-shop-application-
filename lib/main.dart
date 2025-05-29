import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin_home.dart';
import 'package:flutter_application_1/screens/cartpage.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/orders_page.dart';
import 'package:flutter_application_1/screens/user_home.dart';
import 'package:flutter_application_1/settings/settings_page.dart'; // <-- Add this  // <-- Add this

import 'package:flutter_application_1/services/cart_provider.dart';
import 'package:flutter_application_1/services/orderprovider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (role == 'admin') return AdminHome();
    if (role == 'user') return UserHome();
    return LoginScreen(); // Default
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        '/cart': (context) => const CartPage(),
        '/orders': (context) => const OrdersPage(),     // <-- Add route for orders
        '/settings': (context) => const SettingsPage(), // <-- Optional: route for settings
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
