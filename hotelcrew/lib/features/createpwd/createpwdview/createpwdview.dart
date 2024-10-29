import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

final confirmpassword = TextEditingController(text: "");
final password = TextEditingController(text: "");

class createpwd extends StatefulWidget {
  const createpwd({super.key});

  @override
  _createpwdState createState() => _createpwdState();
}

class _createpwdState extends State<createpwd> {
  bool checkBoxValue = false;
  bool svghide = false;
  final FocusNode passwordFocusNode = FocusNode();
  @override
  void initState()
  {
    super.initState();
    password.addListener((){
      setState(() {
        if (passwordFocusNode.hasFocus)
        {
          svghide = true; 
        }
        else
        {
          svghide = false;
        }
      });
    });
  }
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
                height: 32,
                margin: const EdgeInsets.only(top: 58),
                child: Text(
                  'Create a New Password',
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
                  'Please set a new password for your HotelCrew account.',
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
                'assets/createpwd.svg', // Ensure the path is correct
                height: 258.16,
                width: 244.58,
                excludeFromSemantics: svghide,
              ),
              const SizedBox(height: 20), // Space between the SVG and the text field
              TextFormField(
                controller: password,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                focusNode: passwordFocusNode,
                obscuringCharacter: '●',
                style: TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
              ),
              const SizedBox(height: 20), // Space between the text fields
              TextFormField(
                controller: confirmpassword,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                obscuringCharacter: '●',
                style: TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
              ),
              const SizedBox(height: 20), // Space between the text fields
              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () {
                    print("Password: ${password.text}");
                    print("Confirm Password: ${confirmpassword.text}");
                    
                  },
                  child: Text(
                    'Save Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
