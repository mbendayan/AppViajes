class Steps {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String name;
  final String cost;
  final String recommendations;

  Steps({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.name,
    required this.cost,
    required this.recommendations,
  });

  factory Steps.fromJson(Map<String, dynamic> json) {
    print("aj");
    return Steps(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      name: json['name'],
      cost: json['cost'].toString() ,
      recommendations: json["recommendations"]
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'location': location,
    'name': name,
    'cost': cost,
    'recommendations': recommendations,
  };
}
