import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../model/getleavemodel.dart'; // Adjust the import path based on your project structure

// Custom Logger Interceptor
class LeaveCountViewModel with ChangeNotifier {
  final Dio _dio;
  final String _apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/leave_list/';
  final String _authToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs'; // Replace with your token management logic

  LeaveCountViewModel() : _dio = Dio() {
    // Add logger interceptor
    // _dio.interceptors.add(CustomLogInterceptor());
  }

  List<Map<String, dynamic>> _leaveRequests = [];
  List<Map<String, dynamic>> get leaveRequests => _leaveRequests;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<List<Map<String, dynamic>>> fetchLeaveRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get(
        _apiUrl,
        options: Options(
          headers: {'Authorization': _authToken},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        _leaveRequests = data
            .map((json) => LeaveRequest.fromJson(json).toJson())
            .toList();
            print("%%%%%%%%%%%%%%%%%%%%%%");
            print(_leaveRequests);
          return _leaveRequests;
      } else if (response.statusCode == 401) {
        _errorMessage = 'Authentication failed. Please log in again.';
      } else {
        _errorMessage = 'Failed to load leave requests.';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _leaveRequests;
  }
}