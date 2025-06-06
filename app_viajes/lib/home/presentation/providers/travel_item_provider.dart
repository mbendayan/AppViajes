import 'package:app_viajes/home/presentation/providers/travel_provider.dart';
import 'package:app_viajes/models/trave_menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final travelItemProvider = Provider<AsyncValue<List<TravelMenuItem>>>((ref) {
  final travelState = ref.watch(travelProvider);

  return travelState.when(
    data: (travels) => AsyncValue.data(
      travels.map((t) => TravelMenuItem.fromTravel(t)).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});