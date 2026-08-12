enum UserRole { student, parent, volunteer, donor }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final int points;
  final int streak;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.points = 0,
    this.streak = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'points': points,
        'streak': streak,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        name: json['name'],
        email: json['email'],
        role: UserRole.values.firstWhere((e) => e.name == json['role']),
        points: json['points'] ?? 0,
        streak: json['streak'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
