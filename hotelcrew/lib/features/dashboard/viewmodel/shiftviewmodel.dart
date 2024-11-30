import 'package:dio/dio.dart'; 
import '../model/shiftmodel.dart';// Assuming you are using Dio for API requests

class StaffScheduleService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/edit/schedule_list/'; // Your API endpoint

  // Fetch staff schedules from the API and transform the data
  Future<List<Map<String, String>>> fetchAndTransformStaffSchedules() async {
    try {
      Response response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA2MTA1LCJpYXQiOjE3MzI2MTQxMDUsImp0aSI6IjFmYWI0NTI4MTQzNDRhNTU5MGY3Y2YzYzFlMzc4YmFmIiwidXNlcl9pZCI6OTB9.JjlVfhXpewcsFv6V1JN8Q5L2C7WHMVOUwgKKp7ZtFDc',
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
      } 
      else if(response.statusCode == 401){
        throw Exception('Log In Again');
      }
      else {
        throw Exception('Failed to load staff schedules');
      }
    } catch (error) {
      // Handle errors
      print("Error fetching data: $error");
      rethrow; // Rethrow the error to be handled in the UI layer
    }
  }
}
