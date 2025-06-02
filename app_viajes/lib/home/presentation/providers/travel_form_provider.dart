import 'package:app_viajes/models/travel_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final travelFormProvider =
    StateNotifierProvider<TravelFormNotifier, CreateTravelRequest>(
  (ref) => TravelFormNotifier(),
);

class TravelFormNotifier extends StateNotifier<CreateTravelRequest> {
  TravelFormNotifier()
      : super(CreateTravelRequest(
          name: '',
          destination: '',
          startDate: '',
          endDate: '',
          preferences: [],
        ));
  
  void updateForm({
    required List<String> preferences,
  }) {
    state.preferences = preferences;

  }
  void updateForm2({
    String name = "",
    String destination = "",
    String startDate = "",
    String endDate = "",
    
  }) {
    if (name != "") {
      state.name = name;
    }
    if (destination != "") {
      state.destination = destination;
    }
     if (startDate != "") {
      state.startDate = startDate;
    }
     if (endDate != "") {
      state.endDate = endDate;
    }
    
  }

}

  
