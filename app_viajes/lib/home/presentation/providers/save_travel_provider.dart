import 'dart:convert';

import 'package:app_viajes/config/dio/dio_client.dart';
import 'package:app_viajes/home/presentation/providers/current_travel_provider.dart';
import 'package:app_viajes/home/presentation/providers/step_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final saveTravelProvider = AsyncNotifierProvider<SaveTravelController, void>(() {
  return SaveTravelController();
});

class SaveTravelController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No necesita hacer nada al inicializar
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final steps = ref.read(generatedStepsProvider);
    final travel = ref.read(currentTravelProvider); // Asegurate que exista

    if (userId == null || travel == null) {
      throw Exception("Faltan datos del usuario o del viaje");
    }

    final formattedSteps = steps.map((step) => {
  "id": step.id,  // puede ser null si es nuevo
  "name": step.name,
  "description": "",
  "location": step.location,
  "startDate": step.startDate.toIso8601String(),
  "endDate": step.endDate.toIso8601String(),
  "cost": step.cost,
  "recommendations": step.recommendations ?? "",
}).toList();

    final dio = DioClient.getInstance();

    // Guardar el viaje para el usuario
    final response1 = await dio.post(
      '/api/users/$userId/savetravel/${travel.id}',
    );

    if (response1.statusCode != 200) {
      throw Exception("Error al guardar viaje: ${response1.data}");
    }
print(jsonEncode({"steps": formattedSteps}));
print(formattedSteps.runtimeType);

    // Actualizar steps
    final response2 = await dio.put(
  '/travels/${travel.id}/steps',
  data: formattedSteps, 
);


    if (response2.statusCode != 200) {
      throw Exception("Error al actualizar actividades: ${response2.data}");
    }
  }
}
