import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

final resetpassemail = TextEditingController(text: "");

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Reset Your Password',
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
                  'Enter your email address to receive a password reset link.',
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
              SvgPicture.asset(
                'assets/resetpass.svg', 
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
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      width: 328,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Email: ${resetpassemail.text}");
                        },
                        child: Text(
                          'Send Reset Link',
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
                        InkWell(
                          onTap: () {
                            // Add your onTap functionality here
                          },
                          child: Text(
                            'Remember Password?',
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
                        const SizedBox(width: 8), 
                        Container(
                          width: 61,
                          height: 28,
                          child: TextButton(
                            onPressed: () {
                              // Add your onPressed functionality here
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.white, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Container(
                              height: 20,
                              width: 45,
                              child: Text(
                                'Log In',
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
    );
  }
}
