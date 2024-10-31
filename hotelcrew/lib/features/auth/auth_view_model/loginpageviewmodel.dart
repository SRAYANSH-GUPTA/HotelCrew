import 'package:dio/dio.dart';
import '../auth_models/loginmodel.dart';

class AuthViewModel {
  final Dio _dio = Dio();

  AuthViewModel() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
      
        print("Response received: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        print("Error: ${error.message}");
        return handler.next(error);
      },
    ));
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/login/',
        data: {
          "email": email,
          "password": password,
        },
      );

      // Parsing the JSON response to LoginResponse model
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to log in: $e");
    }
  }
}
