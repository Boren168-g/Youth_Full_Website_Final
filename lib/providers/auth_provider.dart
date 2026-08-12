import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;
  bool _isInitialized = false;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _loadUser();
  }

  String get baseUrl {
    return 'https://youth-full-website-final.onrender.com/api';
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user_data');
      if (userStr != null) {
        _user = User.fromJson(jsonDecode(userStr));
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email.trim().toLowerCase(), 'password': password}),
      ).timeout(const Duration(seconds: 120));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _user = User.fromJson(data['user']);
        await _saveUser(_user!);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      _error = "Connection Error: $e";
    }
    
    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signUp(String name, String email, String password, UserRole role) async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'role': role.name,
        }),
      ).timeout(const Duration(seconds: 120));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _user = User.fromJson(data['user']);
        await _saveUser(_user!);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      _error = "Connection Error: $e";
    }
    
    _loading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    notifyListeners();
  }
}
