 import 'package:flutter/material.dart';

class CreateTravelRequest{
    final String name;
    final String destination;
    final String startDate ;
    final String endDate;
   
    final List<String> preferences;
 

 CreateTravelRequest(
  {
  required this.name,
  required this.destination,
  required this.endDate,
  required this.startDate,
  required this.preferences
 }
 );
CreateTravelRequest copyWith({
    String? name,
    String? destination,
    String? startDate,
    String? endDate,
    List<String>? preferences,
  }) {
    return CreateTravelRequest(
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      preferences: preferences ?? this.preferences,
    );
  }
 Map<String, dynamic> toJson() => {
  'name' : name,
  'destination' : destination,
  'start_date' : startDate,
  'end_date' : endDate,
  'preferences' : preferences
 };
}