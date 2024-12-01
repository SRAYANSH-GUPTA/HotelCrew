import 'package:email_validator/email_validator.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/auth/auth_models/loginmodel.dart';
import 'package:hotelcrew/features/auth/view/pages/register.dart';
import 'package:flutter/services.dart'; // Add this import

import '../../auth_view_model/loginpageviewmodel.dart';
import '../../../resetpass/resertpasspage/resetpass.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:developer";
import 'package:flutter_dotenv/flutter_dotenv.dart';

import "../../../dashboard/dashborad.dart";
import "../../../staff/staffdash.dart";
import "../../../receptionist/receptiondash.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBoxValue = false;
  final emailController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final authViewModel = AuthViewModel();
  bool validEmail = true;
  bool _obscurePassword = true;
  final bool _isLoading = false; // Track loading state
  bool _isInvalidCredentials = false; // Track invalid credentials state
  int login = 0;
  String p = "";

  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        validEmail = emailRegex.hasMatch(emailController.text);
        _isInvalidCredentials = false;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/auth/register-device-token/';

  /// Registers the device token by sending it to the server.
  /// Requires the `fcmToken` and `authToken` (for authentication).
  Future<void> registerDeviceToken(String fcmToken, String authToken) async {
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']); // Message from the server
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to register device token');
      }
    } catch (e) {
      print('Error registering device token: $e');
      rethrow;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.05;

    return GlobalLoaderOverlay(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(top: padding),
            child: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Text(
                          'Welcome Back to HotelCrew!',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: const Color(0xFF121212),
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.06,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.07,
                        width: screenWidth * 1.2,
                        child: Text(
                          'Your personalized platform for managing hotel operations with ease.',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: const Color(0xFF4D5962),
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.033,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.07),
                      Center(
                        child: SvgPicture.asset(
                          'assets/login.svg',
                          height: screenWidth * 0.6,
                          width: screenWidth * 0.6,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.08),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: Padding(
                            padding: EdgeInsets.only(top: padding, bottom: padding),
                            child: TextFormField(
                              controller: emailController,
                              maxLength: 320,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: const Color(0xFF5B6C78),
                              ),
                              validator: (value) => emailRegex.hasMatch(value ?? '') ? null : "Enter a valid email.",
                              decoration: InputDecoration(
                                labelText: 'Email',
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: validEmail
                                    ? OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.red, width: 1.0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      )
                                    : null,
                                suffixIcon: validEmail ? null : const Icon(Icons.error, color: Color(0xFFC80D0D)),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: padding),
                          child: TextFormField(
                            onChanged: (newValue) {
                              setState(() {
                                p = newValue;
                              });
                            },
                            controller: passwordController,
                            maxLength: 50,
                            validator: (value) => _isInvalidCredentials ? "Invalid Credentials" : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              suffixIcon: IconButton(
                                icon: _obscurePassword
                                    ? SvgPicture.asset('assets/nopassword.svg')
                                    : SvgPicture.asset('assets/passwordvisible.svg'),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            obscuringCharacter: '●',
                            style: TextStyle(fontSize: screenWidth * 0.05, color: const Color(0xFF5B6C78)),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              //  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Deny spaces
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Resetpass())),
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: const Color(0xFF4D5962),
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * 0.035,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const Row(
                            children: [],
                          )
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.1),
                      SizedBox(
                        width: screenWidth,
                        child: ElevatedButton(
                          onPressed: context.loaderOverlay.visible || emailController.text.isEmpty || p.isEmpty || !validEmail
                              ? null // Disable button while loading or if email is invalid
                              : () async {
                                  setState(() {
                                    context.loaderOverlay.show(); // Start loading
                                    _isInvalidCredentials = false; // Reset invalid credentials flag
                                  });

                                  try {
                                    final loginResponse = await authViewModel.loginUser(
                                      context,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    print(loginResponse);
                                    // Only if login is successful (checking for valid response)
                                    if (loginResponse is LoginResponse) {
                                      print("########################");
                                      print("Login successful!");
                                      print("User Full Name: ${loginResponse.userData.fullName ?? "Not available"}");
                                      print("AccessToken: ${loginResponse.accessToken ?? "Not available"}");
                                      print("RefreshToken: ${loginResponse.refreshToken ?? "Not available"}");
                                      if (true) {
                                        print("hello done");
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.remove("access_token");
                                        prefs.remove("refresh_token");
                                        prefs.remove("email");
                                        // prefs.remove("password");
                                        prefs.setString('access_token', loginResponse.accessToken);
                                        prefs.setString('refresh_token', loginResponse.refreshToken);
                                        prefs.setString('email', emailController.text);
                                        prefs.setString('password', passwordController.text);
                                        prefs.setString('Role', loginResponse.role);

                                        print(prefs.getString('Role'));
                                        String role = prefs.getString('Role') ?? "";
                                        print(role);
                                        print(prefs.getString('access_token') ?? "Not Available");
                                        log(prefs.getString('access_token') ?? "Not Available");
                                        log(prefs.getString('password') ?? "Not Available");
                                        log(prefs.getString('email') ?? "Not Available");
                                        print(prefs.getString('email') ?? "Not Available");
                                        log(prefs.getString('refresh_token') ?? "Not Available");
                                        String fcm = prefs.getString('fcm') ?? "";
                                        print("%%%%%%%%%%%%%%");
                                        print(prefs.getString('email') ?? "Not Available");
                                        String access = prefs.getString('access_token') ?? "";
                                        if (fcm.isNotEmpty && access.isNotEmpty) {
                                          registerDeviceToken(fcm, access);
                                        }
                                        print(role);
                                        if (role == "Admin" || role == "Manager") {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const DashboardPage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        } else if (role == "Receptionist") {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ReceptionDashboardPage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        } else if (role == "Staff") {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const StaffDashboardPage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                          );
                                        }
                                      }
                                    } else if (loginResponse == "Server Error") {
                                      _showSnackbar("Server error, please try again later.");
                                    } else if (loginResponse == "Invalid credentials") {
                                      _showSnackbar("Invalid credentials, please try again.");
                                    } else {
                                      _showSnackbar("Connection Error");
                                    }
                                  } catch (e) {
                                    print("###################");
                                    print("Login failed: $e");
                                    _showSnackbar("An error occurred, please try again later.");
                                    emailController.clear();
                                    passwordController.clear();

                                    setState(() {
                                      _isInvalidCredentials = true; // Show invalid credentials message
                                    });

                                    // Check if the error is a DioError
                                    if (e is DioException) {
                                      // Handle DioError specifically
                                      String? errorMessage = e.message;
                                      print("**********");

                                      if (errorMessage != null) {
                                        if (errorMessage.contains("Connection timed out")) {
                                          // Connection timeout
                                          _showSnackbar("Connection timed out. Please check your internet connection.");
                                        } else if (errorMessage.contains("TimeoutException")) {
                                          // Receive timeout
                                          _showSnackbar("Server response timed out. Please try again.");
                                        } else if (errorMessage.contains("No Internet")) {
                                          // Network error
                                          _showSnackbar("No internet connection or unknown error. Please check your connection.");
                                        } else {
                                          // Handle other Dio errors here
                                          _showSnackbar("An unexpected error occurred. Please try again.");
                                        }
                                      }
                                    } else {
                                      // Handle other types of exceptions
                                      _showSnackbar("Failed to log in: An error occurred.");
                                    }
                                  } finally {
                                    setState(() {
                                      context.loaderOverlay.hide(); // Stop loading
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5662AC),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: false
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Color(0xFFFAFAFA)),
                                )
                              : Text(
                                  'Log In',
                                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not a member?",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: const Color(0xFF4D5962),
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * 0.03,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.09,
                              child: TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Register())),
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: const Color(0xFF5662AC),
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.035,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}