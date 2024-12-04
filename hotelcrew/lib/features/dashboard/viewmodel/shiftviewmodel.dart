import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/shiftmodel.dart'; // Assuming you are using Dio for API requests

class StaffScheduleService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/edit/schedule_list/'; // Your API endpoint

  // Fetch staff schedules from the API and transform the data
  Future<List<Map<String, String>>> fetchAndTransformStaffSchedules() async {
    try {
      // Retrieve the access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      Response response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // Use the retrieved token
          },
        ),
      );

      if (response.statusCode == 200) {
        // Check if the response is successful
        List<dynamic> scheduleList = response.data['schedule_list'];
        print(scheduleList);
        print("hello");
        // Convert the raw data into the required format
        List<StaffSchedule> staffSchedules = scheduleList
            .map((shiftData) => StaffSchedule.fromApiResponse(shiftData))
            .toList();

        // Return the transformed list
        print(staffSchedules.map((schedule) => schedule.toMap()).toList());
        return staffSchedules.map((schedule) => schedule.toMap()).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Log In Again');
      } else {
        throw Exception('Failed to load staff schedules');
      }
    } catch (error) {
      // Handle errors
      print("Error fetching data: $error");
      rethrow; // Rethrow the error to be handled in the UI layer
    }
  }
}