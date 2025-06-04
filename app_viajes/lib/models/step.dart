class Steps {
  final String id;
  final String? travelId;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String name;
  final double cost;
  final String recommendations;

  Steps({
    required this.id,
    required this.travelId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.name,
    required this.cost,
    required this.recommendations,
  });

  factory Steps.fromJson(Map<String, dynamic> json) => Steps(
    id: json['id'],
    travelId: json['travelId'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    location: json['location'],
    name: json['name'],
    cost: json['cost'].toDouble(),
    recommendations: json['recommendations'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'travelId': travelId,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'location': location,
    'name': name,
    'cost': cost,
    'recommendations': recommendations,
  };
}
