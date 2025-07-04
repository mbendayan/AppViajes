import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../config/dio/dio_client.dart'; // contiene la baseUrl

class ApiService {
  final Dio _dio = DioClient.getInstance();

  Future<User> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _saveToken(token);

    return user;
  }

  Future<User> register(String email, String password) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
    });

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _saveToken(token);

    return user;
  }

  Future<User> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await _dio.get(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return User.fromJson(response.data);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> saveTravelToUser(int userId, int travelId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  final response = await _dio.post(
    '/api/users/$userId/savetravel/$travelId',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al guardar viaje: ${response.data}");
  }
}

Future<void> updateTravelSteps(int travelId, List<Map<String, dynamic>> steps) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  final response = await _dio.put(
    '/travels/$travelId/steps',
    data: {'steps': steps},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al actualizar actividades: ${response.data}");
  }
}
}
