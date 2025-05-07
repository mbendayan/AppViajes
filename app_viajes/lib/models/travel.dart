class Travel {
  final String id;
  final String name;
  final int peopleCount;
  final String travelType;
  final String destination;
  final String code;
  final bool isPublic;
  final DateTime creationDate;
  final String status;
  final String creatorId;
  final List<String> participantIds;
  final List<String>? recommendationIds;

  Travel({
    required this.id,
    required this.name,
    required this.peopleCount,
    required this.travelType,
    required this.destination,
    required this.code,
    required this.isPublic,
    required this.creationDate,
    required this.status,
    required this.creatorId,
    required this.participantIds,
    this.recommendationIds,
  });

  factory Travel.fromJson(Map<String, dynamic> json) => Travel(
    id: json['id'],
    name: json['name'],
    peopleCount: json['peopleCount'],
    travelType: json['travelType'],
    destination: json['destination'],
    code: json['code'],
    isPublic: json['isPublic'],
    creationDate: DateTime.parse(json['creationDate']),
    status: json['status'],
    creatorId: json['creatorId'],
    participantIds: List<String>.from(json['participantIds']),
    recommendationIds: List<String>.from(json['recommendationIds'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'peopleCount': peopleCount,
    'travelType': travelType,
    'destination': destination,
    'code': code,
    'isPublic': isPublic,
    'creationDate': creationDate.toIso8601String(),
    'status': status,
    'creatorId': creatorId,
    'participantIds': participantIds,
    'recommendationIds': recommendationIds,
  };
}
