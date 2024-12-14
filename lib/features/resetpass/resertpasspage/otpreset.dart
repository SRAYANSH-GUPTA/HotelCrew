import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hotelcrew/features/createpwd/createpwdview/createpwdview.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../viewmodel/otpresetviewmodel.dart';
import '../models/resetpassemailmode.dart';
import '../viewmodel/resetpassviewmodel.dart' as reset;

class Otpreset extends StatefulWidget {
  final String email; // Assuming you pass the email to this page

  const Otpreset({super.key, required this.email});

  @override
  State<Otpreset> createState() => _OtpresetState();
}

class _OtpresetState extends State<Otpreset> {
  late OtpresetModel viewModel;
  bool checkBoxValue = false;
  double svgHeight = 236.03;
  double svgWidth = 232.28;
  bool otperror = false;
  final reset.ForgetPasswordViewModel resetviewModel = reset.ForgetPasswordViewModel();
  final OtpTimerButtonController otp = OtpTimerButtonController();
  String enteredOtp = ""; // Variable to store the OTP entered by the user

  @override
  void initState() {
    super.initState();
    viewModel = OtpresetModel();
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double otpFieldSize = screenWidth * 0.127; // 20% of the screen width for each OTP field

    return GlobalLoaderOverlay(
      child: 
        Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: screenHeight * 0.08,
                ),
                child: SizedBox(
                  width: screenWidth * 0.9,
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
                      SizedBox(
                        height: screenWidth * 0.13,
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
                      const SizedBox(height: 24),
                      if (svgHeight == 0 && otperror)
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            height: 39,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Incorrect code.",
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
                        child: SvgPicture.asset(
                          'assets/otp.svg',
                          height: svgHeight,
                          width: svgWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.13),
                      SizedBox(
                        // height: 190,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Didn’t receive the code?"),
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  height: 40,
                                  child: OtpTimerButton(
                                    buttonType: ButtonType.text_button,
                                    backgroundColor: Colors.black,
                                    controller: otp,
                                    onPressed: () async {
                                      // await Future.delayed(Duration(seconds: 2));
                                      context.loaderOverlay.show();
                                      final response = await reset.ForgetPasswordViewModel()
                                          .sendForgetPasswordRequest(widget.email);
                                      context.loaderOverlay.hide();
                                      if (response is ForgetPasswordSuccessResponse) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Password Reset Otp sent successfully.")),
                                        );
                                      } else if (response is ForgetPasswordErrorResponse) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("User doesn't exist.")),
                                        );
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
                            SizedBox(
                              // height: 40,
                              width: screenWidth * 0.9,
                              child: ElevatedButton(
                                onPressed: () async {
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
                                  await viewModel.sendOtp(widget.email, enteredOtp);
      
                                  if (viewModel.successMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.successMessage!),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => createpwd(
                                                email: widget.email,
                                              )),
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
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(
                                    'Remember Password?',
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
                                      'Log In',
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