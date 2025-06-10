import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:app_viajes/models/step.dart';
import 'package:app_viajes/models/travel.dart';
import 'package:app_viajes/models/travel_request.dart';
import 'package:app_viajes/models/travel_response.dart';
import 'package:app_viajes/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../config/dio/dio_client.dart';

final travelProvider =
    StateNotifierProvider<TravelNotifier, AsyncValue<List<Travel>>>(
      (ref) => TravelNotifier(),
    );

class TravelNotifier extends StateNotifier<AsyncValue<List<Travel>>> {
  TravelNotifier() : super(const AsyncValue.loading());

  final Dio _dio = DioClient.getInstance();

  Future<void> fetchUserTravels(int userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _dio.get('/api/users/$userId/travels');
      final List<Travel> travels =
          (response.data as List).map((e) => Travel.fromJson(e)).toList();
      state = AsyncValue.data(travels);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createTravel(CreateTravelRequest request, WidgetRef ref) async {
    try {
      final response = await _dio.post(
        '/travels/create',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final created = CreateTravelResponse.fromJson(data);

        // Guardamos las actividades generadas en el provider
        ref.read(generatedStepsProvider.notifier).state = created.steps;
      } else {
        throw Exception("Error al crear viaje: ${response.statusCode}");
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception("Error de red: ${e.response?.data ?? e.message}");
      }
      rethrow;
    }
  }
}
