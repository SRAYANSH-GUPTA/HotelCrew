import 'package:dio/dio.dart';
import '../model/createannouncementmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementViewModel {
  final Dio _dio = Dio();

  AnnouncementViewModel() {
    _initializeHeaders();
  }

 Future<void> _initializeHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('access_token') ?? "";
  print("Access Token: $accessToken"); // Add this to debug token retrieval

  _dio.options.headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };
}


  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String message,
    required String priorityLevel,
    required List<String> departments,
  }) async {
    const String endpoint = "";

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          "title": title,
          "message": message,
          "priority_level": priorityLevel,
          "departments": departments,
        },
      );

      if (response.statusCode == 201) {
        return {
          "status": true,
          "message": response.data['message'] ?? "Announcement created successfully",
        };
      } else {
        return {
          "status": false,
          "message": response.data['message'] ?? "Failed to create announcement",
        };
      }
    } on DioError catch (e) {
      // Handling Dio-specific errors
      if (e.response != null) {
        print(e.response?.data);
        return {
          "status": false,
          "message": e.response?.data['message'] ?? "Server error occurred",
        };
      } else {
        return {
          "status": false,
          "message": "Network error occurred. Please check your connection.",
        };
      }
    } catch (e) {
      // Handling unexpected errors
      return {
        "status": false,
        "message": "An unexpected error occurred.",
      };
    }
  }
}
