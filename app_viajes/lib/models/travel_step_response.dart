class CreateTravelStepResponse {
  final int id;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String name;
  final double cost;
  final String recommendations;

  CreateTravelStepResponse({
    required this.id,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.name,
    required this.cost,
    required this.recommendations,
  });

  factory CreateTravelStepResponse.fromJson(Map<String, dynamic> json) {
    return CreateTravelStepResponse(
      id: json['id'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      name: json['name'],
      cost: (json['cost'] as num).toDouble(),
      recommendations: json['recommendations'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'location': location,
        'name': name,
        'cost': cost,
        'recommendations': recommendations,
      };
}
