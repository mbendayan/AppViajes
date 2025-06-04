import 'package:app_viajes/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../config/dio/dio_client.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.data(null)) {
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

  Future<String> login(String email, String password) async {
  state = const AsyncValue.loading();
  try {
    final response = await _dio.post('/api/users/login', data: {
      'email': email,
      'password': password,
    });

    
    final user = User.fromJson(response.data);


    

    state = AsyncValue.data(user);
    return 'success';
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    return 'Error al iniciar sesión: ${_parseError(e)}';
  }
}

Future<String> register(String email, String password) async {
  state = const AsyncValue.loading();
  try {
    final response = await _dio.post('/api/users/register', data: {
      'email': email,
      'password': password,
    });

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _saveToken(token);

    state = AsyncValue.data(user);
    return 'success';
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    return 'Error al registrarse: ${_parseError(e)}';
  }
}

String? _parseError(Object error) {
  if (error is DioException) {
    return error.response?.data.toString() ?? error.message;
  }
  return error.toString();
}

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    state = const AsyncValue.data(null);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
