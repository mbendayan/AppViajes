import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DioClient {
  static Dio? _dio;

  static Dio getInstance() {
    if (_dio != null) return _dio!;

    final baseUrl = _getBaseUrl();

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    return _dio!;
  }

  static String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080/';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/';
    }

    return 'http://localhost:8080/';
  }
}
