import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Make sure to import this for showing SnackBars
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

  Future<dynamic> loginUser(BuildContext context, String email, String password) async {
  try {
    final response = await _dio.post(
      'https://hotelcrew-1.onrender.com/api/auth/login/',
      data: {
        "email": email,
        "password": password,
      },
      options: Options(
        validateStatus: (status) => status! < 501, // Treats 500+ codes as errors
      ),
    );

    print("Response received: ${response.data}"); // Log the raw response data
    print("Status code: ${response.statusCode}");

  if (response.statusCode == 200) {
  print("Login successful");
  try {
    return LoginResponse.fromJson(response.data);
  } catch (e) {
    print("Error parsing response: $e");
    return "Error parsing response"; // Return a specific error message
  }
} else if (response.statusCode == 401) {
  return "Invalid credentials";
} else if (response.statusCode == 500) {
  return "Server error";
} else {
  return "Unexpected error occurred";
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
  } catch (e) {
    // Handling any other exceptions
    String errorMessage = "An error occurred"; // General error message
    print("General error: $errorMessage");
    return errorMessage;
  }
}
}

