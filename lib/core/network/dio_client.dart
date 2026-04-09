import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../services/storage_service.dart';
import './api_endpoints.dart';

class DioClient {
  late final Dio _dio;
  final _logger = Logger();
  final StorageService? _storageService;

  DioClient({StorageService? storageService}) : _storageService = storageService {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final user = _storageService?.getUser();
          if (user?.token != null) {
            options.headers['Authorization'] = 'Bearer ${user!.token}';
          }
          
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger
              .d('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger
              .e('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          
          if (e.response?.statusCode == 401) {
            // Handle global 401 logout if needed
            // _storageService?.clearAll();
          }
          
          return handler.next(e);
        },
      ),
    );
  }

  Dio get instance => _dio;
}
