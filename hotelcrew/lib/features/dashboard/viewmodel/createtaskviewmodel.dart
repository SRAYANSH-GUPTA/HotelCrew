import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/createtaskmodel.dart';

class TaskViewModel {
  final Dio _dio = Dio();

  final String baseUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/tasks/';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> assignTask(Task task) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }

      final response = await _dio.post(
        baseUrl,
        data: task.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA2MTA1LCJpYXQiOjE3MzI2MTQxMDUsImp0aSI6IjFmYWI0NTI4MTQzNDRhNTU5MGY3Y2YzYzFlMzc4YmFmIiwidXNlcl9pZCI6OTB9.JjlVfhXpewcsFv6V1JN8Q5L2C7WHMVOUwgKKp7ZtFDc',
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('Task Created Successfully: ${response.data}');
      } else {
        throw Exception('Failed to create task');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error Response: ${e.response?.data}');
        throw Exception(e.response?.data['message'] ?? 'Failed to create task');
      } else {
        print('Error: ${e.message}');
        throw Exception('An error occurred. Please try again.');
      }
    }
  }
}
