import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final staffPerformanceProvider = StateNotifierProvider<StaffPerformanceViewModel, StaffPerformanceState>(
  (ref) => StaffPerformanceViewModel(),
);

class StaffPerformanceState {
  final List<double> performancePercentages;
  final bool isLoading;
  final String errorMessage;

  StaffPerformanceState({
    required this.performancePercentages,
    required this.isLoading,
    required this.errorMessage,
  });

  StaffPerformanceState copyWith({
    List<double>? performancePercentages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StaffPerformanceState(
      performancePercentages: performancePercentages ?? this.performancePercentages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class StaffPerformanceViewModel extends StateNotifier<StaffPerformanceState> {
  StaffPerformanceViewModel()
      : super(StaffPerformanceState(
          performancePercentages: [],
          isLoading: true,
          errorMessage: '',
        )) {
    fetchPerformanceData();
  }

  Future<void> fetchPerformanceData() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('http://hotelcrew-1.onrender.com/api/statics/performance/hotel/week/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> weeklyStats = data['weekly_stats'];

        final performancePercentages = weeklyStats
            .map((stat) => stat['performance_percentage'] as double)
            .toList();

        state = state.copyWith(
          performancePercentages: performancePercentages,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          errorMessage: 'Failed to load data: ${response.statusCode}',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error: $e',
        isLoading: false,
      );
    }
  }
}