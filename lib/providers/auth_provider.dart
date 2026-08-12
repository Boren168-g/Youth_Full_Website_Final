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
    return 'https://youth-full-website-final.onrender.com/api';
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      debugPrint('Attempting Cloud Login (Timeout: 120s)...');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim(), 'password': password}),
      ).timeout(const Duration(seconds: 120)); // Increased to 120 seconds

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          _user = User.fromJson(data['user']);
          _loading = false;
          notifyListeners();
          return true;
        }
      }
      _error = "Server response error. Please wait 10 seconds and try again.";
    } catch (e) {
      _error = "Server is waking up (Cloud Wake-up). Please wait 15 seconds and try clicking Login again. [Code: 120s-V3]";
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
      debugPrint('Attempting Cloud Register (Timeout: 120s)...');
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'role': role.name,
        }),
      ).timeout(const Duration(seconds: 120)); // Increased to 120 seconds

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _user = User.fromJson(data['user']);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = "Registration error. Try again.";
    } catch (e) {
      _error = "Server is waking up. Please wait 15 seconds and try clicking Create Account again. [Code: 120s-V3]";
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
        body: jsonEncode({
          'userId': _user!.id,
          'className': programName,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Successfully applied!'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Server is busy. Try again shortly.'};
    }
    return {'success': false, 'message': 'Action failed.'};
  }
}
