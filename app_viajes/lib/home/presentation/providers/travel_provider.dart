import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:app_viajes/models/step.dart';
import 'package:app_viajes/models/travel_request.dart';
import 'package:app_viajes/models/travel_response.dart';
import 'package:app_viajes/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../config/dio/dio_client.dart';

final travelProvider = StateNotifierProvider<TravelNotifier, AsyncValue<User?>>(
  (ref) => TravelNotifier(),
);


class TravelNotifier extends StateNotifier<AsyncValue<User?>> {
  TravelNotifier() : super(const AsyncValue.data(null)) {
    _checkTokenOnInit();
  }

  final Dio _dio = DioClient.getInstance();


  Future<void> _checkTokenOnInit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      try {
        final response = await _dio.get('/auth/me');
        final user = User.fromJson(response.data);
        state = AsyncValue.data(user);
      } catch (_) {
        state = AsyncValue.data(null);
      }
    }
  }
Future<void> createTravel(CreateTravelRequest request, WidgetRef ref) async {
    try {
      final response = await _dio.post(
        '/travels/create',
        data: request.toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final created = CreateTravelResponse.fromJson(data);

        // Guardamos las actividades generadas en el provider
       ref.read(generatedStepsProvider.notifier).state = created.steps;


        print(ref.read(generatedStepsProvider));
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
