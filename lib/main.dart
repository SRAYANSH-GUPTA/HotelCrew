import 'dart:convert';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hotelcrew/features/onboarding/page/onboarding_page.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/dashboard/dashborad.dart';
import 'package:provider/provider.dart' as provider;
import 'features/dashboard/viewmodel/getannouncement.dart';
import 'features/staff/staffdash.dart';
import 'features/receptionist/receptiondash.dart';
import "features/auth/view/pages/login_page.dart";
import 'core/packages.dart';

void main() async {
  await dotenv.load();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp();
  print("Firebase initialized successfully!");
  
  runApp(
    ProviderScope(
      child: provider.ChangeNotifierProvider(
        create: (_) => AnnouncementViewModel(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalNotification.navigatorKey,
      title: 'Loading access tokens and refresh tokens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
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

  @override
  void initState() {
    super.initState();
    initialization();
    logFcmToken();
  }

  void logFcmToken() async {
    // Get the FCM token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken() ?? "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcm', token);
    
    print("FCM Token: $token");
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

  void initialization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasToken = prefs.containsKey('access_token');
    String role = prefs.getString('Role') ?? "";
    // String role = "Staff";
    // prefs.setString("Role", "Staff");
    String? refreshToken = prefs.getString('refresh_token');
    print("^^^^^^^^^^^^");

    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token, navigate to onboarding
      FlutterNativeSplash.remove();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
      return;
    }

    FlutterNativeSplash.remove();
    if (hasToken) {
      String accessToken = prefs.getString('access_token') ?? "";
      int expirationTime = _getExpirationTimeFromToken(accessToken);

      // Check if the token is expired
      if (_checkIfTokenExpired(expirationTime)) {
        await _refreshAccessToken(refreshToken, role, context);
      } else {
        setState(() {
          _isLoading = false;
          _accessToken = accessToken;
        });
        _navigateToDashboard(role);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    }
  }

  int _getExpirationTimeFromToken(String token) {
    try {
      // Decode JWT token and extract the exp field
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

  Future<void> _refreshAccessToken(String refreshToken, String role, BuildContext context) async {
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

      _navigateToDashboard(role);
    } else {
      setState(() {
        _isLoading = false;
        _isTokenExpired = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    }
  }

  void _navigateToDashboard(String role) async {
    if (role == "Admin" || role == "Manager") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else if (role == "Receptionist") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ReceptionDashboardPage()),
      );
    } else if (role == "Staff") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StaffDashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
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
      appBar: AppBar(),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}
