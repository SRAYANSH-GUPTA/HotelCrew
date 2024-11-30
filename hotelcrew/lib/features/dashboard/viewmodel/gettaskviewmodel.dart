import 'dart:async';
import 'package:dio/dio.dart';
import '../model/gettaskmodel.dart';

class TaskService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/tasks/all/';

  // Fetch tasks with pagination
  Future<List<Task>> fetchTasks({int page = 1, int pageSize = 10}) async {
    try {
      // Simulate network delay
      // await Future.delayed(const Duration(seconds: 2));

      // API Request with query parameters for pagination
      final response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501, 
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA2MTA1LCJpYXQiOjE3MzI2MTQxMDUsImp0aSI6IjFmYWI0NTI4MTQzNDRhNTU5MGY3Y2YzYzFlMzc4YmFmIiwidXNlcl9pZCI6OTB9.JjlVfhXpewcsFv6V1JN8Q5L2C7WHMVOUwgKKp7ZtFDc', // Replace with actual token
          },
        ),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      print("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // If the request is successful, extract data
        final data = response.data;

        // Ensure the response contains results
        if (data['results'] != null) {
          // Convert the 'results' to a list of Task objects
          final taskList = (data['results'] as List)
              .map((task) => Task.fromJson(task as Map<String, dynamic>))
              .toList();

          return taskList;
        } else {
          throw Exception('No tasks found in the response');
        }
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors (network or data parsing)
      print('Error fetching tasks: $e');
      rethrow;
    }
  }
}
