import 'package:app_viajes/models/travel_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final travelFormProvider =
    StateNotifierProvider<TravelFormNotifier, CreateTravelRequest>(
  (ref) => TravelFormNotifier(),
);

class TravelFormNotifier extends StateNotifier<CreateTravelRequest> {
  TravelFormNotifier()
      : super(CreateTravelRequest(
          name: 'Viaje a la Patagoni',
          destination: 'El Calafate',
          startDate: '2025-06-15T08:00:00',
          endDate: '2025-06-20T20:00:00',
          preferences: ["aventura", "naturaleza", "gastronomía"],
        ));

  void setName(String name) => state = state.copyWith(name: name);
  void setDestination(String destination) => state = state.copyWith(destination: destination);
  void setDates(String start, String end) =>
      state = state.copyWith(startDate: start, endDate: end);
  void setPreferences(List<String> preferences) =>
      state = state.copyWith(preferences: preferences);
}
