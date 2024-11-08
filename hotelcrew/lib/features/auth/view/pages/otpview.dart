import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'otpviewmodel.dart';
import 'otpmodel.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart' as reg;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Otpview extends StatefulWidget {
  final String email;
  final String password;
  final String confirmpassword;
  final String username;

  Otpview({required this.email, required this.password, required this.confirmpassword, required this.username});

  @override
  State<Otpview> createState() => _OtpviewState();
}

class _OtpviewState extends State<Otpview> {
  late OtpViewModel viewModel;
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool checkBoxValue = false;
  double svgHeight = 236.03;
  double svgWidth = 232.28;
  bool otperror = false;
  final storage = FlutterSecureStorage();
  bool _isLoading = false;
  final FocusNode emailFocusNode = FocusNode();
  final OtpTimerButtonController otp = OtpTimerButtonController();
  String enteredOtp = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    viewModel = OtpViewModel();
    emailFocusNode.addListener(() {
      setState(() {
        if (emailFocusNode.hasFocus) {
          svgHeight = 0;
          svgWidth = 0;
        } else {
          svgHeight = 218.78;
          svgWidth = 231.87;
        }
      });
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingHorizontal = screenWidth * 0.05; // 5% padding on each side
    double topPadding = screenHeight * 0.07; // 10% padding at the top
    double otpFieldSize = screenWidth * 0.127; // 20% of the screen width for each OTP field

    return GestureDetector(
      onTap: () => _hideKeyboard(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: topPadding),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify Your Account',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xFF121212),
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "We've sent a 4-digit verification code to your email ${widget.email}",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xFF4D5962),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Focus(
                      focusNode: emailFocusNode,
                      child: Container(
                        width: screenWidth * 0.9,
                        child: OtpPinField(
                          fieldHeight: otpFieldSize,
                          fieldWidth: otpFieldSize,
                          autoFocus: false,
                          key: _otpPinFieldController,
                          autoFillEnable: false,
                          textInputAction: TextInputAction.done,
                          onSubmit: (text) {
                            enteredOtp = text;
                            debugPrint('Entered pin is $enteredOtp');
                          },
                          onChange: (text) {
                            enteredOtp = text;
                            debugPrint('Enter on change pin is $enteredOtp');
                          },
                          otpPinFieldStyle: const OtpPinFieldStyle(
                            activeFieldBackgroundColor: Color(0xFFF4F8F9),
                            filledFieldBackgroundColor: Color(0xFFF4F8F9),
                            fieldBorderWidth: 0,
                            fieldPadding: 25.33,
                            activeFieldBorderGradient:
                                LinearGradient(colors: [Color(0xFF6F8393), Color(0xFF6F8393)]),
                          ),
                          maxLength: 4,
                          showCursor: true,
                          cursorColor: Colors.indigo,
                          cursorWidth: 3,
                          mainAxisAlignment: MainAxisAlignment.center,
                          otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),
                    if (svgHeight == 0 && otperror)
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Incorrect code or Invalid User.",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFFBA4872),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Check and try again",
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFFBA4872),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: SvgPicture.asset(
                          'assets/otp.svg',
                          height: svgHeight,
                          width: svgWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Didn’t receive the code?"),
                              OtpTimerButton(
                                buttonType: ButtonType.text_button,
                                backgroundColor: Colors.black,
                                controller: otp,
                                onPressed: () async {
                    if (_isLoading) return; // Prevent multiple taps while loading
  final dioClient = reg.DioClient();
  print(widget.username);
  print(widget.email);
  print(widget.password);
  print(widget.confirmpassword);
  if (widget.password == widget.confirmpassword) {
    final registrationRequest = UserRegistrationRequest(
      userName: widget.username,
      email: widget.email,
      password: widget.password,
      confirmPassword: widget.confirmpassword,
    );
    print(registrationRequest);
setState(() {
            _isLoading = true; // Start loading
          });
    try {
      final response = await dioClient.registerUser(registrationRequest);
      setState(() {
            _isLoading = false; // Start loading
          });
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
        ));
        print("#############");

      }
    } on ApiError catch (e) {
      // Handle the ApiError and show it to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An unexpected error occurred. Please try again.'),
      ));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Passwords do not match'),
      duration: const Duration(seconds: 2),
    ));
  }
},

                                text: Text(
                                  'Resend',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF5662AC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                duration: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            width: screenWidth * 0.9,
                            child: ElevatedButton(
                               onPressed: isLoading
    ? null
    : () async {
        setState(() {
          isLoading = true;
        });

        // Call the view model's sendOtp method
        await viewModel.sendOtp(widget.email, enteredOtp);

        if (viewModel.successMessage != null) {
          print('Access Token: ${viewModel.accessToken}');
          print('Refresh Token: ${viewModel.refreshToken}');
          print('User ID: ${viewModel.userId}');
           // Access us print("hello done");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("access_token");
              prefs.remove("refresh_token");
              prefs.remove("userid");
            prefs.setString('access_token',viewModel.accessToken ?? "");
            prefs.setString('refresh_token', viewModel.refreshToken ?? "");
            prefs.setString('userid', viewModel.userId.toString());
            print(prefs.getString('access_token') ?? "Not Available");

            print("#############");
            print(prefs.getString('userid'));
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else if (viewModel.errorMessage != null) {
          setState(() {
            otperror = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        setState(() {
          isLoading = false;
        });
      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF47518C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Verify',
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Color(0xFFFAFAFA),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Back To',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF121212),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF5662AC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
