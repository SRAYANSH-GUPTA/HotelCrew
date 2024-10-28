import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

final resetpassemail = TextEditingController(text: "");

class Resetpasslink extends StatefulWidget {
  const Resetpasslink({super.key});

  @override
  State<Resetpasslink> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpasslink> {
 

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
                height: 84,
                width: 328,
                child: Text(
                  'An email with password reset instructions has been sent to your inbox. Please check your email and follow the link to reset your password.',
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
                'assets/email-campaign.svg', 
                height: 349,
                width: 324,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20), 
              Container(
                height: 190,
                width: 328,
                child: Column(
                  children: [
                    InkWell(
                          onTap: () {
                            // Add your onTap functionality here
                          },
                          child: Text(
                            "Didn't Receive Email?",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                    
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      width: 328,
                      child: ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text(
                          'Resend Link',
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
