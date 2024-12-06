import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftProvider {
  Future<Map<String, String>> fetchShiftData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    final response = await Dio().get(
      'https://hotelcrew-1.onrender.com/api/edit/user_profile/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data['user'];
      String shift = data['shift'] ?? 'Day';
      String shiftTime;

      switch (shift) {
        case 'Morning':
          shiftTime = '6:00 AM - 2:00 PM';
          break;
        case 'Evening':
          shiftTime = '2:00 PM - 10:00 PM';
          break;
        case 'Night':
        default:
          shiftTime = '10:00 PM - 6:00 AM';
          break;
      }

      return {'shift': shift, 'shiftTime': shiftTime};
    } else {
      throw Exception('Failed to load shift data');
    }
  }
}