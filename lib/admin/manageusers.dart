// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 176, 179, 183), 
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'User Information',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 135, 131, 137), Color.fromARGB(255, 228, 231, 232)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 189, 187, 187).withOpacity(0.9), // Card background color
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Center(
                    child: CircleAvatar(radius: 40, backgroundImage: FileImage(image!)),
                  )
                else
                  const Center(
                    child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                  ),
                const SizedBox(height: 20),
                Text('Name: $name', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Email: $email', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 10),
                Text('Phone: $phone', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 10),
                Text('Location: $location', style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
