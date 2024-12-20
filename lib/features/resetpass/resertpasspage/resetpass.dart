import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import '../models/resetpassemailmode.dart';
import '../viewmodel/resetpassviewmodel.dart';
import 'otpreset.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

final resetpassemail = TextEditingController(text: "");

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  bool checkBoxValue = false;
  double svgHeight = 228.88;
  double svgWidth = 322.88;
  final FocusNode emailFocusNode = FocusNode();
  final ForgetPasswordViewModel viewModel = ForgetPasswordViewModel();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {
        svgHeight = emailFocusNode.hasFocus ? 0 : 228.88;
        svgWidth = emailFocusNode.hasFocus ? 0 : 322.88;
      });
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  void _unfocusTextField() {
    emailFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: _unfocusTextField,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                children: [
                  // Title with responsive font size
                  Container(
                    width: screenWidth * 0.9,
                    height: 32,
                    margin: const EdgeInsets.only(top: 58),
                    child: Text(
                      'Reset Your Password',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: const Color(0xFF121212),
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.07, // Responsive font size
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    width: screenWidth * 0.9,
                    child: Text(
                      'Enter your email address to receive a verification code.',
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
                  Container(
                    height: !emailFocusNode.hasFocus ? 85.72 : 0,
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/otpsentreset.svg',
                      height: svgHeight,
                      width: svgWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    height: !emailFocusNode.hasFocus ? 85.4 : 48,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: TextFormField(
                            controller: resetpassemail,
                            focusNode: emailFocusNode,
                            maxLength: 320,
                            validator: (value) => EmailValidator.validate(value ?? '')
                                ? null
                                : "Enter a valid email.",
                            decoration: InputDecoration(
                              counterText: "",
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                            ],
                          ),
                        ),
                        Container(
                          height: !emailFocusNode.hasFocus ? 48 : 137,
                        ),
                        SizedBox(
                          height: 40,
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (EmailValidator.validate(resetpassemail.text) && resetpassemail.text.isNotEmpty) {
                                context.loaderOverlay.show(); // Start loading
                                final response = await viewModel
                                    .sendForgetPasswordRequest(resetpassemail.text);
                                context.loaderOverlay.hide(); // Stop loading
                                if (response is ForgetPasswordSuccessResponse) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Password Reset Otp sent successfully.")),
                                  );
                                  resetpassemail.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Otpreset(email: resetpassemail.text),
                                    ),
                                  );
                                } else if (response is ForgetPasswordErrorResponse) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.errors.join())),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Enter a valid email address.")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF47518C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Send Verification Code',
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
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'Remember Password?',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: const Color(0xFF4D5962),
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth * 0.03, // Responsive font size
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
                                  padding: const EdgeInsets.all(0),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 20,
                                  width: 45,
                                  child: Text(
                                    'Log In',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Color(0xFF4D5962),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
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