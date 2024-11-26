import 'package:dio/dio.dart';
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

  
}


  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String message,
    required String priorityLevel,
    required List<String> departments,
  }) async {
    const String endpoint = "https://hotelcrew-1.onrender.com/api/taskassignment/announcements/";
    print(departments.join(",").toLowerCase());
    print(priorityLevel.toLowerCase());
    try {
      final response = await _dio.post(
        endpoint,
        data: {
         "title": title,
    "description": message,
    "department": departments.join(",").toLowerCase(),
    "urgency": priorityLevel.toLowerCase()
        },
       
         options: Options(
          validateStatus: (status) => status! < 501, 
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NTc4MzMzLCJpYXQiOjE3MzE5ODYzMzMsImp0aSI6IjMxNjk0NTQzNWIzYTQ0MDBhM2MxOGE5M2UzZTk5NTQ0IiwidXNlcl9pZCI6NzF9.Dyl7m7KmXCrMvqbPo31t9q7wWcYgLHCNi9SNO6SPfrY',
          },
        ),
        
        
      );
       
      

      if (response.statusCode == 201) {
        return {
          "status": true,
          "message": response.data['message'] ?? "Announcement created successfully",
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
