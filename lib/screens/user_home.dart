import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/product_grid_page.dart';
import 'package:flutter_application_1/settings/settings_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        const ProductGridPage(),
        const SettingsPage(),
        const Center(child: Text('')),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 163, 43),
        title: Text(
          "GAD gets",
          style: GoogleFonts.stardosStencil(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 30, 28, 28),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
        
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/j.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
          color: const Color.fromARGB(217, 4, 2, 2)
             
            ),
          ),
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 211, 126, 22),
        color: const Color.fromARGB(255, 197, 128, 24),
        buttonBackgroundColor: const Color.fromARGB(255, 79, 77, 82),
        height: 60,
        index: _selectedIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.menu, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
