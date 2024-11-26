import 'dart:convert';
import 'package:dio/dio.dart'; 
import '../model/shiftmodel.dart';// Assuming you are using Dio for API requests

class StaffScheduleService {
  final Dio _dio = Dio();
  final String apiUrl = 'http://13.200.191.108:8000/api/edit/schedule_list/'; // Your API endpoint

  // Fetch staff schedules from the API and transform the data
  Future<List<Map<String, String>>> fetchAndTransformStaffSchedules() async {
    try {
      Response response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NTk5ODM1LCJpYXQiOjE3MzIwMDc4MzUsImp0aSI6ImYxYzFkODE1NTU3NTQzYjhiNWRlMzYzOTNmOTAxYThmIiwidXNlcl9pZCI6NjR9.dxiN8N9Cf7EWpg33MgjluaCfemeRxMytdD613bDhzWc',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Check if the response is successful
        List<dynamic> scheduleList = response.data['schedule_list'];
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
