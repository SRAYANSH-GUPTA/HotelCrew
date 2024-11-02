import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hotelcrew/features/auth/view/pages/otpview.dart';
import 'package:hotelcrew/features/createpwd/createpwdview/createpwdview.dart';
import '../../../resetpass/resertpasspage/resetpass.dart';


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
      body: SingleChildScrollView(
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
              SizedBox(
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
                'assets/cuate.svg',
                height: 205.85,
                width: 202.05,
              ),
              const SizedBox(height: 20),
              Form(
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  controller: email,
                  maxLength: 320,
                  validator: (value) => EmailValidator.validate(value ?? '') ? null : "Enter a valid email.",
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password,
                maxLength: 12,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                obscuringCharacter: '●',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF5B6C78),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Otpview(),
                        ),
                      );
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
                        checkBoxValue = newValue ?? false;
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
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
                    SizedBox(
                      width: 61,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          // Add your onPressed functionality here
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
