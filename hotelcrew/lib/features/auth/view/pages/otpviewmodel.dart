import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'otpmodel.dart';
import 'dart:developer';
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
      onError: (DioError e, handler) {
        print('Error occurred: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<SuccessResponse> sendOtp(OtpRequest otpRequest) async {
  try {
    final response = await dio.post(
      'https://hotelcrew-1.onrender.com/api/auth/register/',
      data: json.encode(otpRequest.toJson()),
    );

    if (response.statusCode == 201) {
      final successResponse = SuccessResponse.fromJson(response.data);
      return successResponse;
    } else if (response.statusCode == 400) {
      final errorResponse = ErrorResponse.fromJson(response.data);
      throw Exception(errorResponse.error.join(', '));
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  } on DioError catch (e) {
    if (e.response != null) {
      final errorResponse = ErrorResponse.fromJson(e.response!.data);
      throw Exception(errorResponse.error.join(', '));
    } else {
      throw Exception('Network error: ${e.message}');
    }
  }
}

}



class OtpViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _accessToken;
  String? _refreshToken;
  int? _userId; // Add userId field

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  int? get userId => _userId; // Add a getter for userId

  Future<void> sendOtp(String email, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    _accessToken = null;
    _refreshToken = null;
    _userId = null; // Reset userId when initiating a new request
    notifyListeners();

    try {
      final otpRequest = OtpRequest(email: email, otp: otp);
      final response = await _dioClient.sendOtp(otpRequest);

      // Set the success message, access token, refresh token, and userId
      _successMessage = response.message;
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _userId = response.userId; // Set the userId
      
      // Optionally log these for debugging
      log(_accessToken ?? "Access token not available");
      log(_refreshToken ?? "Refresh token not available");
      log('User ID: $_userId');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
