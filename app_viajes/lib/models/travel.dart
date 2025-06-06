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
    print("as");
    return Travel(
      id: json['id'],
      name: json['name'],
      preferences: json['preferences'],
      destination: json['destination'],
      creationDate: DateTime.parse(json['creationDate']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      steps: (json['steps'] as List)
          .map((e) => Steps.fromJson(e))
         .toList(),
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
