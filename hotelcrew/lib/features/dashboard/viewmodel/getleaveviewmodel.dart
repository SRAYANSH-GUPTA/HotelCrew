import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import "package:shared_preferences/shared_preferences.dart";
import '../model/getleavemodel.dart'; // Adjust the import path based on your project structure

// Custom Logger Interceptor
class LeaveCountViewModel with ChangeNotifier {
   
  final Dio _dio;
  final String _apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/leave_list/';


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
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get(
        _apiUrl,
        options: Options(
          headers: {'Authorization': "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        _leaveRequests = data
            .map((json) => LeaveRequest.fromJson(json).toJson())
            .toList();
            print("%%%%%%%%%%%%%%%%%%%%%@");
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