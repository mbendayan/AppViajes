import 'package:flutter/material.dart';

class User {
  final int id;

  final String? username;
  final String? email;
  final String? password;
  

  User({
    required this.id,
    this.username,
     this.email,
     this.password,
     
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': password,
      
    };
  }
}
