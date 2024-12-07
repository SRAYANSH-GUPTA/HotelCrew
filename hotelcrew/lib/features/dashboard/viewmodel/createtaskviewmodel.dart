import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../model/createtaskmodel.dart';

class TaskViewModel {
  final Dio _dio = Dio();

  final String baseUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/tasks/';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> assignTask(Task task, BuildContext context) async {
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
            'Authorization': 'Bearer $token', // Use the retrieved token
          },
        ),
      );
      print(response.data);
      print("%"*7);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('Task Created Successfully: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task Created Successfully: ${response.data['message']}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to create task: ${response.data['message']}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error Response: ${e.response?.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response?.data['message'] ?? 'Failed to create task'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception(e.response?.data['message'] ?? 'Failed to create task');
      } else {
        print('Error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('An error occurred. Please try again.');
      }
    }
  }
}