import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/getannouncementmodel.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final List<Announcement> _announcements = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String? _nextPageUrl;  // Store the next page URL

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String _apiUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/announcements/?page=1'; // Initial URL
  final Dio _dio = Dio();

  // Getter method for the nextPageUrl
  String? getNextPageUrl() => _nextPageUrl;

  // Fetch announcements from API, including pagination
  Future<void> fetchAnnouncements({String? url}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        _errorMessage = 'Access token not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final String apiUrl = url ?? _apiUrl;
      
      final response = await _dio.get(apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Update nextPageUrl if it's available in the response
        _nextPageUrl = response.data['next'];

        List<dynamic> data = response.data['results'];  // Fetch the list of announcements
        _announcements.addAll(data.map((json) => Announcement.fromJson(json)).toList());
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load announcements';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetAnnouncements() {
    _announcements.clear();
    _nextPageUrl = null;
    notifyListeners();
  }
}
