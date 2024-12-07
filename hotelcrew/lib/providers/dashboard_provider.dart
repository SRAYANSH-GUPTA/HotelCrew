// FILE: lib/providers/dashboard_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardState {
  final Map<String, double> staffStatusData;
  final Map<String, double> roomStatusData;
  final Map<String, double> attendanceData;
  final bool isLoading;
  final String error;

  DashboardState({
    this.staffStatusData = const {"Busy": 0, "Vacant": 0},
    this.roomStatusData = const {"Occupied": 0, "Unoccupied": 0},
    this.attendanceData = const {"Present": 0, "Absent": 0, "Leave": 0},
    this.isLoading = false,
    this.error = '',
  });

  DashboardState copyWith({
    Map<String, double>? staffStatusData,
    Map<String, double>? roomStatusData,
    Map<String, double>? attendanceData,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      staffStatusData: staffStatusData ?? this.staffStatusData,
      roomStatusData: roomStatusData ?? this.roomStatusData,
      attendanceData: attendanceData ?? this.attendanceData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState());

  Future<void> fetchStaffStatus(String token) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final response = await http.get(
        Uri.parse('https://hotelcrew-1.onrender.com/api/taskassignment/staff/available/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int availableStaff = data['availablestaff'] ?? 0;
        final int staffBusy = data['staffbusy'] ?? 0;
        final int totalStaff = data['totalstaff'] ?? 0;

        state = state.copyWith(
          staffStatusData: {
            "Vacant": availableStaff / totalStaff * 100,
            "Busy": staffBusy / totalStaff * 100,
          },
          isLoading: false,
        );
      } else {
        throw Exception('Failed to fetch staff status');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> fetchRoomData(String token) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final response = await http.get(
        Uri.parse('https://hotelcrew-1.onrender.com/api/hoteldetails/all-rooms/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int roomsOccupied = data['rooms_occupied'] ?? 0;
        final int availableRooms = data['available_rooms'] ?? 0;
        final double totalRooms = (roomsOccupied + availableRooms).toDouble();

        state = state.copyWith(
          roomStatusData: {
            "Occupied": totalRooms > 0 ? (roomsOccupied / totalRooms) * 100 : 0,
            "Unoccupied": totalRooms > 0 ? (availableRooms / totalRooms) * 100 : 0,
          },
          isLoading: false,
        );
      } else {
        throw Exception('Failed to fetch room data');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> fetchAttendanceData(String token) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final response = await http.get(
        Uri.parse('https://hotelcrew-1.onrender.com/api/attendance/week-stats/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<String> dates = List<String>.from(data['dates']);
        
        if (dates.isNotEmpty) {
          final int lastIndex = dates.length - 1;
          final int totalPresent = data['total_crew_present'][lastIndex];
          final int totalAbsent = data['total_staff_absent'][lastIndex];
          final int totalLeave = data['total_leave'][lastIndex];
          final int totalRecords = totalPresent + totalAbsent + totalLeave;

          state = state.copyWith(
            attendanceData: {
              "Present": totalRecords > 0 ? (totalPresent / totalRecords) * 100 : 0,
              "Absent": totalRecords > 0 ? (totalAbsent / totalRecords) * 100 : 0,
              "Leave": totalRecords > 0 ? (totalLeave / totalRecords) * 100 : 0,
            },
            isLoading: false,
          );
        }
      } else {
        throw Exception('Failed to fetch attendance data');
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});