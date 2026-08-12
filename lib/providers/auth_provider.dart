import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  String get baseUrl {
    // Ensuring no double slashes and correct path
    return 'https://youth-full-website-final.onrender.com/api';
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
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Login failed (Status: ${response.statusCode})';
      }
    } catch (e) {
      _error = "Connection Error: $e\nHint: If this is instant, please Hard Refresh (Ctrl+F5). [V4]";
      debugPrint('Auth Error: $e');
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
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Registration failed (Status: ${response.statusCode})';
      }
    } catch (e) {
      _error = "Connection Error: $e\nHint: Try again in 10 seconds. [V4]";
      debugPrint('Auth Error: $e');
    }
    
    _loading = false;
    notifyListeners();
    return false;
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> applyToProgram(String programName) async {
    if (_user == null) return {'success': false, 'message': 'Please sign in first.'};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enroll'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _user!.id, 'className': programName}),
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 201) return {'success': true, 'message': 'Success!'};
    } catch (e) {}
    return {'success': false, 'message': 'Error. Try again.'};
  }
}
