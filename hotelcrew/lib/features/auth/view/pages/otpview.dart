import 'package:flutter/services.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'otpviewmodel.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart' as reg;
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../../../hoteldetails/pages/hoteldetailspage1.dart";

class Otpview extends StatefulWidget {
  final String email;
  final String password;
  final String confirmpassword;
  final String username;

  const Otpview({super.key, required this.email, required this.password, required this.confirmpassword, required this.username});

  @override
  State<Otpview> createState() => _OtpviewState();
}

class _OtpviewState extends State<Otpview> {
  late OtpViewModel viewModel;
  bool checkBoxValue = false;
  double svgHeight = 236.03;
  double svgWidth = 232.28;
  bool otperror = false;
  final storage = const FlutterSecureStorage();
  final OtpTimerButtonController otp = OtpTimerButtonController();
  String enteredOtp = "";

  @override
  void initState() {
    super.initState();
    viewModel = OtpViewModel();
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

    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 26,),
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          SystemChannels.textInput.invokeMethod('TextInput.show');
                        });
                      },
                      child: Center(
                        child: SizedBox(
                          width: 256,
                          child: Pinput(
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                            length: 4,
                            onChanged: (text) {
                              enteredOtp = text;
                              debugPrint('Enter on change pin is $enteredOtp');
                            },
                            onCompleted: (text) {
                              enteredOtp = text;
                              debugPrint('Entered pin is $enteredOtp');
                            },
                            defaultPinTheme: PinTheme(
                              width: otpFieldSize,
                              height: otpFieldSize,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F8F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF6F8393)),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: otpFieldSize,
                              height: otpFieldSize,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F8F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF6F8393)),
                              ),
                            ),
                          ),
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
                    SizedBox(
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
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Didn’t receive the code?"),
                              OtpTimerButton(
                                duration: 30,
                                buttonType: ButtonType.text_button,
                                backgroundColor: Colors.black,
                                controller: otp,
                                onPressed: () async {
                                  if (context.loaderOverlay.visible) return;
                                  context.loaderOverlay.show();
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
                                    context.loaderOverlay.show(); // Start loading
                                    try {
                                      final response = await dioClient.registerUser(registrationRequest);
                                      context.loaderOverlay.hide(); // Stop loading
                                      if (response != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(response.message),
                                        ));
                                        print("#############");
                                        otp.startTimer();
                                        context.loaderOverlay.hide();
                                      }
                                    } on ApiError catch (e) {
                                      // Handle the ApiError and show it to the user
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(e.message),
                                        duration: const Duration(seconds: 2),
                                      ));
                                      context.loaderOverlay.hide();
                                    } catch (e) {
                                      // Handle any unexpected errors
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('An unexpected error occurred. Please try again.'),
                                      ));
                                      context.loaderOverlay.hide();
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Passwords do not match'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                  context.loaderOverlay.hide();
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
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: screenWidth * 0.9,
                            child: ElevatedButton(
                              onPressed: context.loaderOverlay.visible
                                  ? null
                                  : () async {
                                      if (enteredOtp.isEmpty || enteredOtp.length < 4) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Please fill in the complete OTP."),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      context.loaderOverlay.show();
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
                                        prefs.setString('access_token', viewModel.accessToken ?? "");
                                        prefs.setString('refresh_token', viewModel.refreshToken ?? "");
                                        prefs.setString('userid', viewModel.userId.toString());
                                        prefs.setString('username', widget.username);
                                        print(prefs.getString('access_token') ?? "Not Available");

                                        print("#############");
                                        print(prefs.getString('userid'));
                                        print("User id");
                                        log(prefs.getString('access_token') ?? "Not Available");
                                        log(prefs.getString('password') ?? "Not Available");
                                        log(prefs.getString('email') ?? "Not Available");
                                        log(prefs.getString('refresh_token') ?? "Not Available");

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Login Successful'),
                                              Text('Tokens Saved Successfully'), // Fixed the syntax error here
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

                                        context.loaderOverlay.hide(); // Hide the loader overlay before navigation
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Hoteldetailspage1()),
                                        );
                                      } else if (viewModel.errorMessage != null) {
                                        setState(() {
                                          otperror = true;
                                          // _otpTextEditingController.clear();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(viewModel.errorMessage!),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      context.loaderOverlay.hide();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF47518C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
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
                          const SizedBox(height: 8,),
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
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 0), // Set left padding to 0
                                  minimumSize: Size.zero, // Removes any minimum size constraints
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks the button's tap area
                                ),
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