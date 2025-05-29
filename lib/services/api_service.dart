// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';





class ApiService {
  final String baseUrl = 'http://192.168.120.43/flutter_api/';



  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login.php'),
        body: {
          'username': username.trim(),
          'password': password.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final user = User.fromJson(data['user']);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('username', user.username);
          prefs.setString('role', user.role);

          print('Login successful: ${user.username}, Role: ${user.role}');
          return user;
        } else {
          print('Login failed: ${data['message']}');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during login: $e');
    }

    return null;
  }

  Future<bool> register(String username, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register.php'),
        body: {
          'username': username.trim(),
          'password': password.trim(),
          'role': role.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          print('Registration successful for $username');
          return true;
        } else {
          print('Registration failed: ${data['message']}');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during registration: $e');
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('User logged out.');
  }

  Future<String?> getStoredRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<String?> getStoredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
