import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/dashboard/home.dart';
import 'features/staff/staffdash.dart';
import 'features/dashboard/dashborad.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/staff/staffdash.dart';
void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
   await Firebase.initializeApp();
   print("Firebase initialized successfully!");
  runApp(
    const ProviderScope( // Wrap your app with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
void logFcmToken() async {
    // Get the FCM token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (token != null) {
      print("FCM Token: $token");
    } else {
      print("Failed to get FCM Token.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading access tokens and refresh tokens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Loading Shared preferences'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  bool _isTokenExpired = false;
  String _accessToken = "";

void logFcmToken() async {
    // Get the FCM token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (token != null) {
      print("FCM Token: $token");
    } else {
      print("Failed to get FCM Token.");
    }
     FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Fetch data from the "messages" collection
    QuerySnapshot snapshot = await firestore.collection('messages').get();

    // Iterate through the documents and print the message fields
    for (var doc in snapshot.docs) {
      String message = doc['message'];  // Assuming you have a 'message' field in your Firestore documents
      print('Message: $message');
    }
  } catch (e) {
    print('Error fetching messages: $e');
  }
  }

  @override
  void initState() {
    super.initState();
    initialization();
    logFcmToken();
      // Call this function to fetch and print messages

  }

  void initialization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasToken = prefs.containsKey('access_token');
    String refreshToken = prefs.getString('refresh_token') ?? "Not Available";
    FlutterNativeSplash.remove();
    if (hasToken) {
      String accessToken = prefs.getString('access_token') ?? "";
      int expirationTime = _getExpirationTimeFromToken(accessToken);
      print("token!!!!!!!!!!!!!!!");

      // Check if the token is expired
      if (_checkIfTokenExpired(expirationTime)) {
        await _refreshAccessToken(refreshToken);
      } else {
        setState(() {
          _isLoading = false;
          _accessToken = accessToken;
        });
        _navigateToDashboard();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const DashboardPage()),
      );
    }
  }

  int _getExpirationTimeFromToken(String token) {
    try {
      // Decode JWT token and extract the exp field
      //TODO: Implement a more robust way to decode JWT tokens
      List<String> parts = token.split('.');
      if (parts.length == 3) {
        String payload = parts[1];
        String normalized = base64Url.normalize(payload);
        String decoded = utf8.decode(base64Url.decode(normalized));
        Map<String, dynamic> decodedPayload = jsonDecode(decoded);
        return decodedPayload['exp'];
      }
      return 0;
    } catch (e) {
      print("Error decoding token: $e");
      return 0;
    }
  }

  bool _checkIfTokenExpired(int exp) {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return currentTime >= exp;
  }

  Future<void> _refreshAccessToken(String refreshToken) async {
    final url = Uri.parse('https://hotelcrew-1.onrender.com/api/auth/token/refresh/');
    final response = await http.post(url, body: {
      'refresh': refreshToken,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String newAccessToken = responseBody['access'];

      // Save the new access token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', newAccessToken);

      setState(() {
        _isLoading = false;
        _accessToken = newAccessToken;
      });

      _navigateToDashboard();
    } else {
      setState(() {
        _isLoading = false;
        _isTokenExpired = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to refresh token: ${response.body}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDashboard() {
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const DashboardPage()),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
 
    if (_isTokenExpired) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: Text('Token expired. Please log in again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}
