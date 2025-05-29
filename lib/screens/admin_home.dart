import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/manageorders.dart';
import 'package:flutter_application_1/admin/manageproducts.dart';
import 'package:flutter_application_1/admin/manageusers.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ManageProductsPage(),
    ManageOrdersPage(),
    ManageUsersPage(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 235, 129, 36),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/j.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 60.0,
        backgroundColor: const Color.fromARGB(0, 197, 81, 9), 
        color: const Color.fromARGB(255, 213, 134, 6),
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: const <Widget>[
          Icon(Icons.production_quantity_limits, size: 30, color: Color.fromARGB(255, 0, 0, 0)),
          Icon(Icons.shopping_cart, size: 30, color: Color.fromARGB(255, 0, 0, 0)),
          Icon(Icons.people, size: 30, color: Color.fromARGB(255, 0, 0, 0)),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
