import 'package:app_viajes/models/step.dart';
import 'package:flutter/material.dart';

class CreateTravelResponse {
  final int id;
  final String name;
  final String preferences;
  final String destination;
  final List<Steps> steps;

  CreateTravelResponse({
    required this.id,
    required this.name,
    required this.preferences,
    required this.destination,
    required this.steps,
  });

  factory CreateTravelResponse.fromJson(Map<String, dynamic> json) {
    return CreateTravelResponse(
      id: json['id'],
      name: json['name'],
      preferences: json['preferences'],
      destination: json['destination'],
      steps: (json['steps'] as List<dynamic>)
          .map((e) => Steps.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'preferences': preferences,
        'destination': destination,
        'steps': steps.map((e) => e.toJson()).toList(),
      };
}
