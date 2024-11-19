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

  Future<dynamic> registerUser(UserRegistrationRequest user) async {
    try {
    final response = await dio.post(
      'https://hotelcrew-1.onrender.com/api/auth/registrationOTP/',
      data: json.encode(user.toJson()),
      options: Options(
        validateStatus: (status) => status! < 501, // Treats 500+ codes as errors
      ),
    );
  
      if (response.statusCode == 200) {
        return UserRegistrationResponse.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        return "User with this email already exists.";
      }
      else if(response.statusCode == 500)
      {
        print("Server Error");
        return "Server Error";
      }
       else {
        print(response.statusCode);
        return "User Already Registered";
      }
    } on DioException catch (e) {
    // Handling Dio exceptions
    String errorMessage = "";
    if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Connection timeout, please try again"; // Timeout error message
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Receive timeout, please try again"; // Receive timeout message
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = "Bad response from server"; // Bad response error message
    } else {
      errorMessage = "Unexpected error occurred"; // For other Dio errors
    }

    print("Dio error: $errorMessage");
    return errorMessage;
  } 
  }
}
