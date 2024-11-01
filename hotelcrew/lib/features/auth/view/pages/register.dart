import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view/pages/login_page.dart';

final confirmpassword = TextEditingController(text: "");
final password = TextEditingController(text: "");
final username = TextEditingController(text: "");
final email = TextEditingController(text: "");

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool checkBoxValue = false;
  final FocusNode passwordFocusNode = FocusNode();

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
                  'Create Account',
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
                  'Join us to enhance your hotel operations.',
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
              SizedBox(
                height: 86,
                width: 328,
                child: TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              SizedBox(
                height: 86,
                width: 328,
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              SizedBox(
                height: 86,
                width: 328,
                child: TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  obscuringCharacter: '●',
                  style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              SizedBox(
                height: 86,
                width: 328,
                child: TextFormField(
                  controller: confirmpassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  obscuringCharacter: '●',
                  style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () {
                    print("Password: ${password.text}");
                    print("Confirm Password: ${confirmpassword.text}");
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Create Account',
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
              SizedBox(
                height: 58,
                width: 328,
                child: CheckboxListTile(
                  title: const Text("I agree to the"),
                  value: checkBoxValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkBoxValue = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => print('Terms and Conditions link'),
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(color: Color(0xFF5662AC)),
                    ),
                  ),
                  const Text(" and "),
                  InkWell(
                    onTap: () => print("Privacy Policy"),
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(color: Color(0xFF5662AC)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
