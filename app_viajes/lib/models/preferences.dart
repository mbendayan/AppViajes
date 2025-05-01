class Preferences {
  final String id;
  final double budget;
  final List<String> tripType;
  final String housingType;
  final List<String> transportType;

  Preferences({
    required this.id,
    required this.budget,
    required this.tripType,
    required this.housingType,
    required this.transportType,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
    id: json['id'],
    budget: json['budget'].toDouble(),
    tripType: List<String>.from(json['tipoViajes']),
    housingType: json['housingType'],
    transportType: List<String>.from(json['transportType']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'budget': budget,
    'tipoViajes': tripType,
    'housingType': housingType,
    'transportType': transportType,
  };
}
