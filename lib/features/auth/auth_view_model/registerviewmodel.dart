import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/register.dart';

// Dio Client Setup
class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://hotelcrew-1.onrender.com/api/auth/registrationOTP/',
            connectTimeout: const Duration(seconds: 10), // 10 seconds to establish connection
            receiveTimeout: const Duration(seconds: 15), // 15 seconds to receive data
            headers: {
              'Content-Type': 'application/json', // Default headers
            },
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log request data for debugging
        print("Request: ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log response data for debugging
        print("Response: ${response.statusCode} ${response.data}");
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
            errorMessage =
                'Received invalid status code: ${e.response?.statusCode}';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'Request to API was cancelled.';
            break;
          case DioExceptionType.unknown:
          default:
            errorMessage = 'Unexpected error: ${e.message}';
            break;
        }

        // Log the error and reject with the customized message
        print("Dio error: $errorMessage");
        return handler.reject(DioException(
          requestOptions: e.requestOptions,
          type: e.type,
          error: errorMessage,
        ));
      },
    ));
  }

  Future<dynamic> registerUser(UserRegistrationRequest user) async {
    print("Trying to register user...");
    try {
      final response = await dio.post(
        '',
        data: json.encode(user.toJson()),
        options: Options(
          validateStatus: (status) => status! < 501, // Treats 500+ codes as errors
        ),
      );

      if (response.statusCode == 200) {
        return UserRegistrationResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        return "User with this email already exists.";
      } else if (response.statusCode == 500) {
        print("Server Error");
        return "Server Error";
      } else {
        print("Unexpected status code: ${response.statusCode}");
        return "Unexpected error";
      }
    } on DioException catch (e) {
      // Handle Dio exceptions using your error handling logic
      String errorMessage = "";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Receive timeout, please try again";
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = "Bad response from server";
      } else {
        errorMessage = "Unexpected error occurred";
      }

      print("Dio error: $errorMessage");
      return errorMessage;
    }
  }
}
