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
        // Log the response
        print("Response received: ${response.data}");
        return handler.next(response);
      },
      onError: (DioError error, handler) {
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

      if (response.statusCode == 200) {
        // Parsing the JSON response to LoginResponse model for success response
        return LoginResponse.fromJson(response.data);
      } else {
        // Handle unexpected status codes
        return LoginResponse(
          status: "error",
          message: "Unexpected status code: ${response.statusCode}",
        );
      }
    } on DioError catch (e) {
      // Handling specific Dio errors
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        // Server responded with an error, parse it
        final errorData = e.response?.data as Map<String, dynamic>;
        return LoginResponse(
          status: errorData["status"] ?? "error",
          message: errorData["message"] ?? "An error occurred",
        );
      } else if (e.type == DioErrorType.connectionTimeout) {
        return LoginResponse(
          status: "error",
          message: "Connection timed out. Please try again.",
        );
      } else if (e.type == DioErrorType.receiveTimeout) {
        return LoginResponse(
          status: "error",
          message: "Server response timed out. Please try again.",
        );
      } else if (e.type == DioErrorType.badResponse) {
        return LoginResponse(
          status: "error",
          message: "Invalid credentials or server error.",
        );
      } else {
        return LoginResponse(
          status: "error",
          message: "An unexpected error occurred: ${e.message}",
        );
      }
    } catch (e) {
      // Handling any other exceptions
      return LoginResponse(
        status: "error",
        message: "Failed to log in: $e",
      );
    }
  }
}
