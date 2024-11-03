import 'package:dio/dio.dart';
import '../models/register.dart';
class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = 'https://hotelcrew-1.onrender.com/api/';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        print('Request Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Error: ${e.response?.statusCode} ${e.message}');
        handler.next(e);
      },
    ));
  }

  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    try {
      final response = await _dio.post('auth/register/', data: request.toJson());
      return RegisterResponse.fromJson(response.data);
    } on DioError catch (e) {
      // Handle error
      print('Error during registration: ${e.message}');
      throw e;
    }
  }
}
