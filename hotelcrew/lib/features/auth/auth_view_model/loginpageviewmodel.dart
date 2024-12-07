import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Make sure to import this for showing SnackBars
import '../auth_models/loginmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final apiUrl = dotenv.env['API_URL'] ?? 'https://hotelcrew-1.onrender.com/api/auth/login/';
    print(apiUrl);
    print("^^^^^^^^^^^^^^^");
   
    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          validateStatus: (status) => status! < 501, // Treats 500+ codes as errors
        ),
      );
       print(response.statusMessage);

      print("Response received: ${response.data}"); // Log the raw response data
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Login successful");
        try {
          final loginResponse = LoginResponse.fromJson(response.data);

          // Get the FCM token from shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? fcmToken = prefs.getString('fcm');

          if (fcmToken != null && fcmToken.isNotEmpty) {
            // Call the API to register the device token
            await registerDeviceToken(fcmToken, loginResponse.accessToken);
          }

          return loginResponse;
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
      String errorMessage = "An error occurred!!"; // General error message
      print("General error: $errorMessage");
      return errorMessage;
    }
  }

  Future<void> registerDeviceToken(String fcmToken, String authToken) async {
    final apiUrl = dotenv.env['REGISTER_DEVICE_TOKEN_URL'] ?? 'https://hotelcrew-1.onrender.com/api/auth/register-device-token/';
    print(apiUrl);
    print("Registering device token...");

    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          "fcm_token": fcmToken,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
          validateStatus: (status) => status! < 501, // Treats 500+ codes as errors
        ),
      );

      if (response.statusCode == 200) {
        print("Device token registered successfully: ${response.data}");
      } else {
        print("Failed to register device token: ${response.data}");
      }
    } on DioException catch (e) {
      print("Error registering device token: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
    }
  }
}
