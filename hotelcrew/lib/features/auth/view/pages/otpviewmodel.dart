import 'package:dio/dio.dart';
import 'dart:convert';
import 'otpmodel.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    // Set up interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Error occurred: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  // Function to send OTP
  Future<void> sendOtp(OtpRequest otpRequest) async {
    try {
      final response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/register/',
        data: json.encode(otpRequest.toJson()),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('OTP sent successfully');
      } else {
        // Handle API error
        throw ApiError.fromJson(response.data);
      }
    } on DioError catch (e) {
      // Handle Dio specific errors
      if (e.response != null) {
        // Server responded with an error
        throw ApiError.fromJson(e.response!.data);
      } else {
        // Something went wrong before reaching the server
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
