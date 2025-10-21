import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  DioClient._();
  static final DioClient _instance = DioClient._();
  factory DioClient() => _instance;

  Dio? _dio;
  PersistCookieJar? _cookieJar;

  // Backend base URL loaded from .env. Must be like: https://finder-backend-latest.onrender.com
  static String get baseUrl {
    final value = dotenv.env['baseUrl'];
    print('Loaded baseUrl: $value');
    if (value == null || value.isEmpty) {
      throw StateError('Missing baseUrl in .env');
    }
    return value;
  }

  Future<Dio> get instance async {
    if (_dio != null) return _dio!;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        followRedirects: false,
        validateStatus: (code) => code != null && code < 500,
      ),
    );

    final dir = await getApplicationSupportDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'),
      ignoreExpires: false,
    );

    dio.interceptors.add(CookieManager(_cookieJar!));

    _dio = dio;
    return _dio!;
  }

  Future<void> clearCookies() async {
    await _cookieJar?.deleteAll();
  }
}

