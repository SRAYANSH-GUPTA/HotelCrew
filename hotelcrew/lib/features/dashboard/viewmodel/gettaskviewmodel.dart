import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/gettaskmodel.dart';

class TaskService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/tasks/all/';

  // Fetch tasks with pagination
  Future<List<Task>> fetchTasks({int page = 1, int pageSize = 10}) async {
    try {
      // Retrieve the access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      // API Request with query parameters for pagination
      final response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // Use the retrieved token
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