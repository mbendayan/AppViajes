import 'package:flutter/material.dart';

class User {
  final String id;

  final String username;
  final String email;
  final String password;
  final DateTime registerDate;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.registerDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      registerDate: DateTime.parse(json['registerDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': password,
      'fechaRegistro': registerDate.toIso8601String(),
    };
  }
}
