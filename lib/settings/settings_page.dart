// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/settings/profile_editpage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String name = '';
  String email = '';
  String phone = '';
  String location = '';
  File? image;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'profile.db');
    final dbExists = await databaseExists(path);
    if (!dbExists) return;

    final db = await openDatabase(path);
    final data = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (data.isNotEmpty) {
      final profile = data.first;
      setState(() {
        name = profile['name'] as String? ?? '';
        email = profile['email'] as String? ?? '';
        phone = profile['phone'] as String? ?? '';
        location = profile['location'] as String? ?? '';
        final imagePath = profile['image'] as String?;
        if (imagePath != null && imagePath.isNotEmpty) {
          image = File(imagePath);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 45, 44, 45),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 200, 11, 11)),
            label: const Text(
              'Logout',
              style: TextStyle(color: Color.fromARGB(255, 197, 8, 8)),
            ),
          ),
  TextButton.icon(
    onPressed: () {
      Navigator.pushNamed(context, '/orders');
    },
    icon: const Icon(Icons.shopping_bag, color: Color.fromARGB(255, 214, 90, 7)),
    label: const Text('My Orders', style: TextStyle(color: Color.fromARGB(255, 205, 91, 10))),
  ),
  IconButton(
    icon: const Icon(Icons.edit, color: Colors.white),
    onPressed: () async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileEditPage()),
      );
      if (result == true) {
        await loadProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    },
  ),
],

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C2C2E), Color(0xFF3C3C3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  image != null
                      ? CircleAvatar(radius: 50, backgroundImage: FileImage(image!))
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Name: $name',
                            style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Email: $email',
                            style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Phone: $phone',
                            style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Location: $location',
                            style: const TextStyle(color: Colors.white70, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          
          ],
        ),
      ),
     
    );
  }
}
