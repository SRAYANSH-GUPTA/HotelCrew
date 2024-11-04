import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/otpresetmodel.dart';

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

  Future<String> sendOtp(OtpRequest otpRequest) async {
    // if (!EmailValidator.validate(otpRequest.email)) {
    //   throw Exception('Invalid email format');
    // }

    try {
      final response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/verify-otp/',
        data: json.encode(otpRequest.toJson()),
      );
      print("got response");
      if (response.statusCode == 201 || response.statusCode == 200) {
        final successResponse = SuccessResponse.fromJson(response.data);
        print("sent");
        return successResponse.message;
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



class OtpresetModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> sendOtp(String email, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final otpRequest = OtpRequest(email: email, otp: otp);
      _successMessage = await _dioClient.sendOtp(otpRequest);
      print(otpRequest);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
