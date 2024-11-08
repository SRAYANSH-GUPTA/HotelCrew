import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hotelcrew/features/auth/view/pages/register.dart';
import 'package:hotelcrew/features/hoteldetails/pages/hoteldetailspage1.dart';
import '../../auth_view_model/loginpageviewmodel.dart';
import '../../../resetpass/resertpasspage/resetpass.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

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
  bool _isLoading = false; // Track loading state
  bool _isInvalidCredentials = false; // Track invalid credentials state
  int login = 0;
  String p = "";

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        validEmail = EmailValidator.validate(emailController.text);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.05;

    return Padding(
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
                            color: Color(0xFF121212),
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
                            color: Color(0xFF4D5962),
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
                    Container(
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
                              color: Color(0xFF5B6C78),
                            ),
                            validator: (value) => EmailValidator.validate(value ?? '') ? null : "Enter a valid email.",
                            decoration: InputDecoration(
                              labelText: 'Email',
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: validEmail
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                                      borderRadius: BorderRadius.circular(8.0),
                                    )
                                  : null,
                              suffixIcon: validEmail ? null : Icon(Icons.error, color: Color(0xFFC80D0D)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth* 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: padding),
                        child: TextFormField(
                          onChanged: (newValue) {
                            setState(() {
                              p = newValue;
                            });
                          },
                          controller: passwordController,
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
                          style: TextStyle(fontSize: screenWidth * 0.05, color: Color(0xFF5B6C78)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Resetpass())),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Color(0xFF4D5962),
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.035,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        Row(
  children: [
    Container(
      child: CheckboxTheme(
        data: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          side: const BorderSide(width: 0, color: Colors.transparent), // Removes outline
        ),
        child: Checkbox(
          checkColor: Colors.white, // Color of the check mark
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.transparent),
          ),
          value: checkBoxValue,
          splashRadius: 0,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF5662AC); // Color when the checkbox is checked
            }
            return const Color(0xFFC6D6DB); // Color when unchecked
          }),
          onChanged: (newValue) {
            setState(() {
              checkBoxValue = newValue ?? false;
            });
          },
        ),
      ),
    ),
    Text(
      'Remember Me',
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Color(0xFF4D5962),
          fontWeight: FontWeight.w400,
          fontSize: screenWidth * 0.035,
          height: 1.5,
        ),
      ),
    ),
  ],
)

                      ],
                    ),
                    SizedBox(height: screenWidth * 0.1),
                    SizedBox(
                      width: screenWidth,
                      child: ElevatedButton(
                        onPressed: _isLoading || emailController.text.isEmpty || p.isEmpty
    ? null // Disable button while loading
    : () async {
        setState(() {
          _isLoading = true; // Start loading
          _isInvalidCredentials = false; // Reset invalid credentials flag
        });

        try {
          final loginResponse = await authViewModel.loginUser(
            emailController.text,
            passwordController.text,
          );

          // Only if login is successful (checking for valid response)
          if (loginResponse.role != "error") {
            print("########################");
            print("Login successful!");
            print("User Full Name: ${loginResponse.userData.fullName ?? "Not available"}");
            print("AccessToken: ${loginResponse.accessToken ?? "Not available"}");
            print("RefreshToken: ${loginResponse.refreshToken ?? "Not available"}");
            if(checkBoxValue)
            {
              print("hello done");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("access_token");
              prefs.remove("refresh_token");
              prefs.remove("email");
              prefs.remove("password");
            prefs.setString('access_token', loginResponse.accessToken);
            prefs.setString('refresh_token', loginResponse.refreshToken);
            prefs.setString('email', emailController.text);
            prefs.setString('password', passwordController.text);
            print(prefs.getString('access_token') ?? "Not Available");
            log(prefs.getString('access_token') ?? "Not Available");
            log(prefs.getString('password') ?? "Not Available");
            log(prefs.getString('email') ?? "Not Available");
            log(prefs.getString('refresh_token') ?? "Not Available");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Login Successful'),
      const Text('Tokens Saved Successfully'), // Fixed the syntax error here
    ],
  ),
  duration: const Duration(seconds: 3),
  action: SnackBarAction(
    label: 'ACTION',
    onPressed: () {},
  ),
));


            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login Successful'),
                  Text('User Full Name: ${loginResponse.userData.fullName ?? "Not available"}'),
                  Text('Role: ${loginResponse.role}'),
                  Text('Access Token: ${loginResponse.accessToken}'),
                ],
              ),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'ACTION',
                onPressed: () {},
              ),
            ));

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Hoteldetailspage1()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Column(
                children: [
                  Text('Login Unsuccessful'),
                  Text('Invalid credentials, please try again.'),
                ],
              ),
              duration: const Duration(seconds: 2),
            ));
          }
        } catch (e) {
          print("###################");
          print("Login failed: $e");
          emailController.clear();
          passwordController.clear();

          setState(() {
            _isInvalidCredentials = true; // Show invalid credentials message
          });

          // Check if the error is a DioError
          if (e is DioError) {
            // Handle DioError specifically
            String? errorMessage = e.message;

            if (errorMessage != null) {
              if (errorMessage.contains("Connection timed out")) {
                // Connection timeout
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Connection timed out. Please check your internet connection.'),
                  duration: const Duration(seconds: 2),
                ));
              } else if (errorMessage.contains("TimeoutException")) {
                // Receive timeout
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Server response timed out. Please try again.'),
                  duration: const Duration(seconds: 2),
                ));
              } else if (errorMessage.contains("No Internet")) {
                // Network error
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('No internet connection or unknown error. Please check your connection.'),
                  duration: const Duration(seconds: 2),
                ));
              } else {
                // Handle other Dio errors here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('An unexpected error occurred. Please try again.'),
                  duration: const Duration(seconds: 2),
                ));
              }
            }
          } else {
            // Handle other types of exceptions
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Failed to log in: An error occurred.'),
              duration: const Duration(seconds: 2),
            ));
          }
        } finally {
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5662AC),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? SizedBox(
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
                                color: Color(0xFF4D5962),
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.03,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Container(
                            height: screenWidth * 0.09,
                            child: TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Register())),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Color(0xFF5662AC),
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
    );
  }
}
