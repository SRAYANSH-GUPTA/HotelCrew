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
  double svgheight = 244.58;
  double svgwidth =  258.16;
  final FocusNode passwordFocusNode = FocusNode();
  bool isSvgVisible = true;
  @override
  void initState()
  {
    super.initState();
    passwordFocusNode.addListener((){
      setState(() {
        if (passwordFocusNode.hasFocus)
        {
          svgheight = 0;
          svgwidth = 0; 
          print("hassssfocus###### ${passwordFocusNode.hasFocus}");
        }
        else
        {
          svgheight = 244.58;
          svgwidth = 258.16;
        }
      });
    });
  }
  @override
  void toggleSvgSize() {
    setState(() {
      if (isSvgVisible) {
        svgheight = 0;
        svgwidth = 0;
      } else {
        svgheight = 244.58;
        svgwidth = 258.16;
      }
      isSvgVisible = !isSvgVisible;
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
                height: svgheight,
                width: svgwidth,
              ),
              const SizedBox(height: 20), // Space between the SVG and the text field
              InkWell(
                onTap: toggleSvgSize,
                child: TextFormField(
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
