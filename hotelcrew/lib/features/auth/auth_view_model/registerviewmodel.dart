import 'package:dio/dio.dart';
import '../auth_models/registermodel.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
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
        print("Error occurred: ${error.message}");
        return handler.next(error); 
      },
    ));
  }

  Future<RegistrationResponse> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/register/',
        data: {
          "email": email,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      // Parse the JSON response into a RegistrationResponse model
      return RegistrationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to register user: $e");
    }
  }
}
