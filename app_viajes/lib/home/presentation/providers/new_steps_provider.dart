import 'package:app_viajes/config/dio/dio_client.dart';
import 'package:app_viajes/models/step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final newStepsProvider =
    FutureProvider.family<List<Steps>, int>((ref, travelId) async {
  final dio = DioClient.getInstance();
  final response = await dio.post('/travels/$travelId/generateSteps');

  final List data = response.data as List;
  return data.map((json) => Steps.fromJson(json)).toList();
});
