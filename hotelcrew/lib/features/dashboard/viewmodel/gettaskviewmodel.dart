import 'dart:async';
import 'package:dio/dio.dart';
import '../model/gettaskmodel.dart';

class TaskService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://yourapi.com/api/tasks';

  // Simulated API response
  Future<List<Task>> fetchTasks() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Mock data based on your API documentation
    List<Map<String, dynamic>> mockData = [
      {
        "id": 1,
        "title": "Prepare meeting agenda",
        "assigned_to": 5,
        "description": "Prepare the agenda for the upcoming meeting with the board of directors.",
        "status": "Pending",
        "deadline": "2024-11-30"
      },
      {
        "id": 2,
        "title": "Clean Room 101",
        "assigned_to": 3,
        "description": "Clean and sanitize Room 101 before the arrival of the VIP guest.",
        "status": "In Progress",
        "deadline": "2024-11-25"
      },
      {
        "id": 3,
        "title": "Inventory check",
        "assigned_to": 4,
        "description": "Conduct an inventory check of all items in the storage room.",
        "status": "Completed",
        "deadline": "2024-11-20"
      },
      {
        "id": 4,
        "title": "Update guest records",
        "assigned_to": 2,
        "description": "Update the guest records with the latest information.",
        "status": "Pending",
        "deadline": "2024-12-01"
      },
    ];

    // Simulate converting response to Task objects
    return mockData.map((task) => Task.fromJson(task)).toList();
  }
}
