import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_provider.dart';

class Module {
  final int id;
  final String title;
  final String description;
  final String iconName;
  final bool isLocked;
  final int totalLessons;
  final int completedLessons;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.isLocked,
    required this.totalLessons,
    required this.completedLessons,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['icon_name'],
      isLocked: json['is_locked'] == 1,
      totalLessons: json['total_lessons'],
      completedLessons: json['completed_lessons'],
    );
  }

  double get progress => totalLessons == 0 ? 0.0 : completedLessons / totalLessons;
}

class LearningProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  List<Module> _modules = [];
  bool _isLoading = false;

  LearningProvider(this.authProvider);

  List<Module> get modules => _modules;
  bool get isLoading => _isLoading;

  Future<void> fetchModules() async {
    if (authProvider.user == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('${authProvider.baseUrl}/modules?userId=${authProvider.user!.id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _modules = data.map((m) => Module.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching modules: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
