import 'package:app_viajes/models/travel.dart';

class TravelMenuItem {
  final String title ;
  final String destination;
  final DateTime? dateStart;
  final DateTime? dateEnd;

  const TravelMenuItem({
     this.title = "",
     this.destination = "",
     this.dateStart,
     this.dateEnd,
  });

  factory TravelMenuItem.fromTravel(Travel travel) {
    return TravelMenuItem(
      title: travel.name,
      destination: travel.destination,
      dateStart: travel.startDate,
      dateEnd: travel.endDate,
    );
  }



  factory TravelMenuItem.fromJson(Map<String, dynamic> json) {
    return TravelMenuItem(
      title: json['name'] ?? '',
      destination: json['destination'] ?? '',
      dateStart: DateTime.parse(json['startDate']),
      dateEnd: DateTime.parse(json['endDate']),
    );
  }
}
