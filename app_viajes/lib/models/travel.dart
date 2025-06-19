import 'package:app_viajes/models/preferences.dart';
import 'package:app_viajes/models/step.dart';

class Travel {
  final int? id;
  final String name;
  final String? preferences;
  final String destination;
  final DateTime? creationDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Steps>? steps;

  Travel({
    this.id,
    required this.name,
    this.preferences,
    required this.destination,
    this.creationDate,
    this.startDate,
    this.endDate,
    this.steps,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null || json['name'] is! String) {
      throw FormatException("Missing or invalid 'name' field");
    }
    if (json['destination'] == null || json['destination'] is! String) {
      throw FormatException("Missing or invalid 'destination' field");
    }

    return Travel(
      id: json['id'],
      name: json['name'],
      preferences: json['preferences'],
      destination: json['destination'],
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate']) ??
              (throw FormatException("Invalid 'creationDate' format"))
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate']) ??
              (throw FormatException("Invalid 'startDate' format"))
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate']) ??
              (throw FormatException("Invalid 'endDate' format"))
          : null,
      steps: json['steps'] != null
          ? (json['steps'] as List)
              .map((e) => Steps.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'preferences': preferences,
        'destination': destination,
        'creationDate': creationDate?.toIso8601String(),
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'steps': steps?.map((e) => e.toJson()).toList(),
      };
}
