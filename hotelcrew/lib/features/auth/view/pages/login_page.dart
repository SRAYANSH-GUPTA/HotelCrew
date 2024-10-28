import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';


final email = TextEditingController(text: "");
final password = TextEditingController(text: "");
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Allows scrolling when content is larger than the screen
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 328,
                height: 63,
                margin: const EdgeInsets.only(top: 58),
                child: Text(
                  'Welcome Back to HotelCrew!',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
                  'Your personalized platform for managing hotel operations with ease.',
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
                'assets/cuate.svg', // Ensure the path is correct
                height: 205.85,
                width: 202.05,
              ),
              const SizedBox(height: 20), // Space between the SVG and the text field
              Form(
  autovalidateMode: AutovalidateMode.always,
  child: TextFormField(
    controller: email,
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
              const SizedBox(height: 20), // Space between the text fields
              TextFormField(
                controller: password,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: 'Password',

                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                obscuringCharacter: '●',
  style: TextStyle(fontSize: 20,
  color: Color(0xFF5B6C78))
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Add your onTap functionality here
                    },
                    child: Text(
                      'Forgot Password?',
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
                  Checkbox(
                    value: checkBoxValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkBoxValue = newValue ?? false; // Ensure newValue is not null
                      });
                    },
                  ),
                  const Text("Remember me"),
                ],
              ),
              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () {
                    print("Email: ${email.text}");
                    print("Password: ${password.text}");
                  },
                  child: Text(
                    'Log In',
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
              const SizedBox(height: 20), // Added space for better layout
              Container(
                height: 28,
                width: 328,
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      height: 18,
                      child: Text(
                        'Already a member?',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Color(0xFF121212),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
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
                           // Button width and height
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

