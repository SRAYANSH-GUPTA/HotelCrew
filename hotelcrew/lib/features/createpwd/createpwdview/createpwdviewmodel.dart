import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'createpwdmodel.dart';

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
        print('Error occurred: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<String> sendOtp(ResetPasswordRequest resetPasswordRequest) async {
    try {
      final response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/reset-password/',
        data: json.encode(resetPasswordRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final successResponse = SuccessResponse.fromJson(response.data);
        print(successResponse);
        return successResponse.message;
      } else if (response.statusCode == 400) {
        final errorResponse = ErrorResponse.fromJson(response.data);
        print(errorResponse);
        throw Exception(errorResponse.error.join(', '));
      } else {
        throw Exception('Unexpected error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorResponse = ErrorResponse.fromJson(e.response!.data);
        throw Exception(errorResponse.error.join(', '));
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}

class CreatePwdViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> sendOtp(String email, String newPassword, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Validate passwords before sending request
      if (newPassword != confirmPassword) {
        throw Exception("Passwords do not match.");
      }

      final resetPasswordRequest = ResetPasswordRequest(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _successMessage = await _dioClient.sendOtp(resetPasswordRequest);
      print(resetPasswordRequest);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
