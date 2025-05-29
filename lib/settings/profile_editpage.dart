import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  File? _image;
  Database? _database;

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'profile.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT,
            location TEXT,
            image TEXT
          )
        ''');
      },
    );
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await _database!.query('profile', where: 'id = ?', whereArgs: [1]);
    if (data.isNotEmpty) {
      final profile = data.first;
      nameController.text = profile['name'] as String? ?? '';
      emailController.text = profile['email'] as String? ?? '';
      phoneController.text = profile['phone'] as String? ?? '';
      locationController.text = profile['location'] as String? ?? '';
      if (profile['image'] != null && (profile['image'] as String).isNotEmpty) {
        setState(() {
          _image = File(profile['image'] as String);
        });
      }
    }
  }

  Future<void> saveProfile() async {
    final imagePath = _image?.path ?? '';
    await _database!.insert(
      'profile',
      {
        'id': 1,
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'location': locationController.text,
        'image': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Navigator.pop(context as BuildContext, true); // Fixed pop with result
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 176, 103, 13),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 20, 20, 20)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 156, 153, 157), Color.fromARGB(255, 141, 142, 142)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 350,
            height: 600,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 116, 114, 111),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        backgroundColor: Colors.grey,
                        child: _image == null
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(Icons.camera_alt, color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(controller: nameController, hint: 'Name'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: emailController, hint: 'Email'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: phoneController, hint: 'Phone Number'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: locationController, hint: 'Location'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        color: Color.fromARGB(255, 231, 237, 238),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 2, color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 2, color: Colors.black),
        ),
      ),
    );
  }
}
