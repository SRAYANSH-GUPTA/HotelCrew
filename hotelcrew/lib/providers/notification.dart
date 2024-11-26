import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(true) {
    _loadNotificationPreference();
  }

  // Load the saved notification preference
  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('notification') ?? true; 
    // Default to true if not set
  }

  // Toggle the notification preference
  Future<void> toggleNotification() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', state); 
    print(prefs.getBool('notification'));
    print("!!!!!!!!!!!!!!!!");
    // Save to SharedPreferences
  }
}

// Declare the provider globally
final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>(
  (ref) => NotificationNotifier(),
);
