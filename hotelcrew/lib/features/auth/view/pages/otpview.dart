import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:hotelcrew/features/hoteldetails/pages/hoteldetailspage1.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'otpviewmodel.dart';
import 'otpmodel.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart' as reg;


class Otpview extends StatefulWidget {
  final String email;
  final String password;
  final String confirmpassword;
  final String username;
   // Assuming you pass the email to this page

  Otpview({required this.email,required this.password,required this.confirmpassword,required this.username});


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
   bool _isLoading = false; 
  final FocusNode emailFocusNode = FocusNode();
  final OtpTimerButtonController otp = OtpTimerButtonController();
  String enteredOtp = ""; // Variable to store the OTP entered by the user
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
    return GestureDetector(
      onTap: () => _hideKeyboard(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 64),
            child: SizedBox(
              width: 328,
              height: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 328,
                    height: 32,
                    child: Text(
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
                  ),
                  SizedBox(
                    height: 42,
                    width: 328,
                    child: Text(
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
                  ),
                  const SizedBox(height: 48),
                  Focus(
                    focusNode: emailFocusNode,
                    child: SizedBox(
                      width: 328,
                      height: 45,
                      child: OtpPinField(
                        autoFocus: false,
                        key: _otpPinFieldController,
                        autoFillEnable: false,
                        textInputAction: TextInputAction.done,
                        onSubmit: (text) {
                          enteredOtp = text; // Update enteredOtp when OTP is submitted
                          debugPrint('Entered pin is $enteredOtp');
                        },
                        onChange: (text) {
                          enteredOtp = text; // Update enteredOtp on change
                          debugPrint('Enter on change pin is $enteredOtp');
                        },
                        onCodeChanged: (code) {
                          enteredOtp = code; // Update enteredOtp when code changes
                          debugPrint('onCodeChanged is $enteredOtp');
                        },
                        otpPinFieldStyle: const OtpPinFieldStyle(
                          activeFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF4CAF50)]),
                          filledFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFFBA4872), Color(0xFFBA4872)]),
                          defaultFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFF6F8393), Color(0xFF6F8393)]),
                          fieldBorderWidth: 2,
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
                  const SizedBox(height: 57),
                  // Conditional error message when svgHeight is 0
                  if (svgHeight == 0 && otperror)
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SizedBox(
                        width: 326,
                        height: 39,
                        child: Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(
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
                          ),]
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.98, right: 45.98),
                    child: SvgPicture.asset(
                      'assets/otp.svg',
                      height: svgHeight,
                      width: svgWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 190,
                    width: 328,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn’t receive the code?"),
                            SizedBox(
                              width: 97,
                              height: 30,
                              child: OtpTimerButton(
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
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                duration: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          width: 328,
                          child: ElevatedButton(
 onPressed: isLoading
    ? null
    : () async {
        await viewModel.sendOtp(widget.email, enteredOtp); // Ensure to replace `email` and `otp` with actual values or inputs
        setState(() {
        isLoading = true;
      });
        if (viewModel.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Hoteldetailspage1()),
  );
          setState(() {
        isLoading = false;
      });
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
          setState(() {
        isLoading = false;
      });
        }
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
            color: Colors.white, // Change color as needed
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 104),
                              child: Text(
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
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 61,
                              height: 28,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 0),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
    );
  }
}
