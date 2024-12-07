import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementViewModel {
  final Dio _dio = Dio();
  String? _accessToken;

  AnnouncementViewModel() {
    _initializeHeaders();
  }

  Future<void> _initializeHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token') ?? "";
    print("Access Token: $_accessToken"); // Add this to debug token retrieval
  }

  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String message,
    required String priorityLevel,
    required List<String> departments,
  }) async {
    await _initializeHeaders();
    const String endpoint = "https://hotelcrew-1.onrender.com/api/taskassignment/announcements/";
    print(departments.join(",").toLowerCase());
    print(priorityLevel.toLowerCase());
    try {
      print("!!!!!!!!!!!");
      print(departments.join(","));
      final response = await _dio.post(
        endpoint,
        data: {
          "title": title,
          "description": message,
          "department": departments.join(""),
          "urgency": priorityLevel
        },
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      print(response.data);
      print(response.statusCode);
      print(departments.toString());

      if (response.statusCode == 201) {
        return {
          "status": true,
          "message": response.data['message'] ?? "Announcement created successfully",
        };
      }
       else if (response.statusCode == 400) {
        return {
          "status": true,
          "message": response.data['department'] ?? "Failed to create Announcement",
        };
      }
       else {
        print(response.statusCode);
        print(response.data);
        return {
          "status": false,
          "message": response.data['message'] ?? "Failed to create announcement",
        };
      }
    } on DioException catch (e) {
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
      print(e);
      return {
        "status": false,
        "message": "An unexpected error occurred.",
      };
    }
  }
}
