import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:hotelcrew/features/resetpass/resertpasspage/otpreset.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/onboarding/page/onboarding_page.dart';
// Assume this is your dashboard page import

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // Initialize shared preferences and check for access token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasToken = prefs.containsKey('access_token');

    // Remove the splash screen and navigate based on token presence
    FlutterNativeSplash.remove();
    if (hasToken) {
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Already exist Routing to Dashboard \n access Token ${prefs.getString('access_token')}"),
              backgroundColor: Colors.green,
            ),
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Otpreset(email: "sr.gupta621@gmail.com",)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Otpreset(email: "sr.gupta621@gmail.com",)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Text('Initializing...'),
      ),
    );
  }
}
