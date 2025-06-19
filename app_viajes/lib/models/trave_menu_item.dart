import 'package:app_viajes/models/preferences.dart';
import 'package:app_viajes/models/travel.dart';

class TravelMenuItem {
  final String title;
  final String destination;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int? id;
  final String? preferences;

  const TravelMenuItem({
    this.id = 0,
    this.title = "",
    this.destination = "",
    this.dateStart,
    this.dateEnd,
    this.preferences = "",
  });

  factory TravelMenuItem.fromTravel(Travel travel) {
    return TravelMenuItem(
      title: travel.name,
      destination: travel.destination,
      dateStart: travel.startDate,
      dateEnd: travel.endDate,
      id: travel.id,
      preferences: travel.preferences,
    );
  }

  factory TravelMenuItem.fromJson(Map<String, dynamic> json) {
    return TravelMenuItem(
      title: json['name'] ?? '',
      destination: json['destination'] ?? '',
      dateStart: DateTime.parse(json['startDate']),
      dateEnd: DateTime.parse(json['endDate']),
      id: json['id'] ?? 0,
      preferences: json['preferences'] ?? '',
    );
  }
}
