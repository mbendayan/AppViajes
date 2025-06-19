import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editTraverProvider =
    StateNotifierProvider<EditTravelNotifier, TravelMenuItem>(
      (ref) => EditTravelNotifier(),
    );

class EditTravelNotifier extends StateNotifier<TravelMenuItem> {
  EditTravelNotifier() : super(TravelMenuItem());

  void setTravel(TravelMenuItem travel) {
    state = travel;
  }
}
