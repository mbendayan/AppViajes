import 'package:app_viajes/models/step.dart';

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
    try {
      final id =
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? -1;
      final name = json['name'] ?? '';
      final destination = json['destination'] ?? '';

      final preferencesRaw = json['preferences'];
      final preferences =
          preferencesRaw is String
              ? preferencesRaw
              : preferencesRaw != null
              ? preferencesRaw.toString()
              : '';

      final stepsRaw = json['steps'] as List<dynamic>? ?? [];
      final steps =
          stepsRaw
              .map((e) {
                try {
                  return Steps.fromJson(e);
                } catch (e) {
                  print("⚠️ Error parseando un Step individual: $e");
                  return null;
                }
              })
              .whereType<Steps>()
              .toList();

      return CreateTravelResponse(
        id: id,
        name: name,
        preferences: preferences,
        destination: destination,
        steps: steps,
      );
    } catch (e) {
      print('❌ Error al parsear CreateTravelResponse: $e');
      print('🔍 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'preferences': preferences,
    'destination': destination,
    'steps': steps.map((e) => e.toJson()).toList(),
  };
}
