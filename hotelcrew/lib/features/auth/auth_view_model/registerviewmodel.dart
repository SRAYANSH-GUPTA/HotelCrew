import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/register.dart';

// Dio Client Setup
class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        String errorMessage;

        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timeout. Please try again.';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Server is taking too long to respond.';
            break;
          case DioExceptionType.badResponse:
            errorMessage = 'Received invalid status code: ${e.response?.statusCode}';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'Request to API was cancelled.';
            break;
          case DioExceptionType.unknown:
          default:
            errorMessage = 'Unexpected error: ${e.message}';
            break;
        }

        // Reject the error with the error message
        return handler.reject(DioException(
          requestOptions: e.requestOptions, // Pass the requestOptions here
          type: e.type,
          error: errorMessage,
        ));
      },
    ));
  }

  Future<UserRegistrationResponse?> registerUser(UserRegistrationRequest user) async {
    try {
      final response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/registrationOTP/',
        data: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return UserRegistrationResponse.fromJson(response.data);
      } else {
        print(response.statusCode);
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      throw ApiError('An unexpected error occurred: ${e.message}');
    }
  }
}
