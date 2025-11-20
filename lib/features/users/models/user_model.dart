import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "createdAt": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
