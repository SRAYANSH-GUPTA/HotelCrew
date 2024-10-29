import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

final otp = TextEditingController(text: "");

class Otpview extends StatefulWidget {
  const Otpview({super.key});

  @override
  State<Otpview> createState() => _OtpviewState();
}

class _OtpviewState extends State<Otpview> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool checkBoxValue = false;
  double svgHeight = 363;
  double svgWidth = 293.06;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {
        if (emailFocusNode.hasFocus) {
          svgHeight = 117.22;
          svgWidth = 145.2;
        } else {
          svgHeight = 363;
          svgWidth = 293.06;
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
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 328,
                  height: 32,
                  margin: const EdgeInsets.only(top: 58),
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
                Container(
                  height: 42,
                  width: 328,
                  child: Text(
                    "We've sent a 4-digit verification code to your email. Please enter it below to complete your sign-up.",
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
                OtpPinField(
                  key: _otpPinFieldController,
                  autoFillEnable: false,
                  textInputAction: TextInputAction.done,
                  onSubmit: (text) {
                    debugPrint('Entered pin is $text');
                  },
                  onChange: (text) {
                    debugPrint('Enter on change pin is $text');
                  },
                  onCodeChanged: (code) {
                    debugPrint('onCodeChanged  is $code');
                  },
                  otpPinFieldStyle: const OtpPinFieldStyle(
                    showHintText: true,
                    activeFieldBorderGradient:
                        LinearGradient(colors: [Colors.black, Colors.redAccent]),
                    filledFieldBorderGradient:
                        LinearGradient(colors: [Colors.green, Colors.tealAccent]),
                    defaultFieldBorderGradient:
                        LinearGradient(colors: [Colors.orange, Colors.brown]),
                    fieldBorderWidth: 3,
                  ),
                  maxLength: 4,
                  showCursor: true,
                  cursorColor: Colors.indigo,
                  cursorWidth: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,
                ),
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/otp.svg',
                  height: svgHeight,
                  width: svgWidth,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 190,
                  width: 328,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: 328,
                        child: ElevatedButton(
                          onPressed: () {
                            print("otp: ${otp.text}");
                          },
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF47518C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Back To',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Color(0xFF4D5962),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 61,
                            height: 28,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF4D5962),
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
    );
  }
}
