import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import "../model/addstaff.dart";
import 'package:shared_preferences/shared_preferences.dart';
class StaffViewModel extends ChangeNotifier {
  final Dio _dio = Dio(); // Initialize Dio instance
  final String apiUrl = 'https://hotelcrew-1.onrender.com/edit/create/';

  List<Staff> _staffList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Staff> get staffList => _staffList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch Staff from API
  Future<void> fetchStaff() async {
    _isLoading = true;
    notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');


    try {
      final response = await _dio.get(apiUrl,
      options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      _staffList = (response.data as List)
          .map((staffData) => Staff.fromJson(staffData))
          .toList();
    } catch (error) {
      _errorMessage = "Failed to fetch staff.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Staff to API
  Future<void> addStaff(Staff newStaff) async {
    try {
      final response = await _dio.post(apiUrl, data: newStaff.toJson());
      _staffList.add(Staff.fromJson(response.data));
      notifyListeners();
    } catch (error) {
      _errorMessage = "Failed to add staff.";
      notifyListeners();
    }
  }
}
