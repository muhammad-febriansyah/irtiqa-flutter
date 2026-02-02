import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

class ApiClient {
  static late Dio _dio;
  static final GetStorage _storage = GetStorage();

  static void initialize() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
    final timeout = int.parse(dotenv.env['API_TIMEOUT'] ?? '30000');

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: timeout),
      receiveTimeout: Duration(milliseconds: timeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          _storage.remove('auth_token');
          _storage.remove('user_data');
          Get.offAllNamed('/login');
        }
        return handler.next(error);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: false,
    ));
  }

  static Dio get dio => _dio;

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }

  static void saveToken(String token) {
    _storage.write('auth_token', token);
  }

  static String? getToken() {
    return _storage.read('auth_token');
  }

  static void removeToken() {
    _storage.remove('auth_token');
  }

  static bool get isAuthenticated => getToken() != null;

  static String getBaseUrl() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
    return baseUrl.replaceAll(RegExp(r'/api/v1/?$'), '');
  }

  static String getImageBaseUrl() {
    return dotenv.env['IMG_BASE_URL'] ?? 'http://localhost:8000/storage';
  }

  static String getAssetUrl(String? path) {
    if (path == null || path.isEmpty) return '';

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final imageBaseUrl = getImageBaseUrl();

    String cleanPath = path;
    if (cleanPath.startsWith('/storage/')) {
      cleanPath = cleanPath.substring(9);
    } else if (cleanPath.startsWith('storage/')) {
      cleanPath = cleanPath.substring(8);
    } else if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    final baseUrl = imageBaseUrl.endsWith('/')
        ? imageBaseUrl.substring(0, imageBaseUrl.length - 1)
        : imageBaseUrl;

    return '$baseUrl/$cleanPath';
  }
}
