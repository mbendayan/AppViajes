class Steps {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String name;
  final String cost;
  final String? recommendations;

  Steps({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.name,
    required this.cost,
    this.recommendations,
  }) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError(
        'La fecha de fin no puede ser anterior a la fecha de inicio',
      );
    }
  }
  factory Steps.fromJson(Map<String, dynamic> json) {
    try {
      return Steps(
        id:
            json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString()) ?? -1,
        startDate: DateTime.parse(json['start_date'] ?? json['startDate']),
        endDate: DateTime.parse(json['end_date'] ?? json['endDate']),
        location: json['location'] ?? '',
        name: json['name'] ?? '',
        cost: json['cost']?.toString() ?? '0',
        recommendations: json['recommendations'],
      );
    } catch (e, stack) {
      print('❌ Error al parsear Steps: $e');
      print('🔍 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'location': location,
    'name': name,
    'cost': cost,
    'recommendations': recommendations,
  };
}
