import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password_strength_indicator/password_strength_indicator.dart';
import '../../auth/view/pages/login_page.dart';
import 'createpwdviewmodel.dart';

final confirmpassword = TextEditingController(text: "");
final password = TextEditingController(text: "");

class createpwd extends StatefulWidget {
  final String email; // Assuming you pass the email to this page

  createpwd({required this.email});
  @override
  _createpwdState createState() => _createpwdState();
}

class _createpwdState extends State<createpwd> {
  bool checkBoxValue = false;
  late CreatePwdViewModel viewModel;
  double svgheight = 244.58;
  bool isLoading = false;
  double svgwidth =  258.16;
  bool _obscurePassword = true;
  bool _obscureconfirmPassword = true;
  bool notequal = false;
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmFocusNode = FocusNode();
  bool isSvgVisible = true;
  double _calculateStrength(String password1) {
    int score = 0;
 

    // Check the length
    if (password1.length >= 8) {
      score++;
    }

    // Check for uppercase letters
    if (password1.contains(RegExp(r'[A-Z]'))) {
      score++;
    }

    // Check for numbers
    if (password1.contains(RegExp(r'\d'))) {
      score++;
    }

    // Check for special characters
    if (password1.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    }

    // Convert the score to a strength value between 0.0 and 1.0
    return score / 4; // Since we have 4 criteria
  }
  @override
  void initState()
  {
    super.initState();
    viewModel = CreatePwdViewModel();
    passwordFocusNode.addListener((){
      setState(() {
        if (passwordFocusNode.hasFocus || confirmFocusNode.hasFocus)
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
              if(!isSvgVisible)
              SizedBox(height: 26),
              Padding(
                padding: EdgeInsets.only(left:34,bottom: 36.42),
                child: SvgPicture.asset(
                  'assets/createpwd.svg', // Ensure the path is correct
                  height: svgheight,
                  width: svgwidth,
                ),
              ),
              if(!isSvgVisible)
              const SizedBox(height: 20), // Space between the SVG and the text field
              InkWell(
                onTap: toggleSvgSize,
                child: TextFormField(
                  controller: password,
                  maxLength: 25,
                  onChanged: (value) {
              setState(() {
                if(password.text != confirmpassword.text && confirmFocusNode.hasFocus)
                {
                  notequal = true;
                }
                else
                {
                  notequal = false;
                }
              }); // Rebuild to update strength indicator
            },
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                            icon: _obscurePassword
                                ? SvgPicture.asset('assets/nopassword.svg')
                                : SvgPicture.asset('assets/passwordvisible.svg'),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;

                              });
                            },
                          ),
                  ),
                  buildCounter: null,
                  
                  obscureText: _obscurePassword,
                  focusNode: passwordFocusNode,
                  obscuringCharacter: '●',
                  style: TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              SizedBox(height: 22,),
              if(passwordFocusNode.hasFocus)
              PasswordStrengthIndicator(
                password: password.text,
  width: 150, // Change the width of the strength bar
  thickness: 3, // Change the thickness of the strength bar
  backgroundColor: Color(0xFFC6D6DB), // Change the background color of the strength bar
  radius: 8, // Change the radius of the strength bar
  colors: StrengthColors(
    // Customize the colors of the strength bar
    weak: Color(0xFFA0365A),
    medium: Color(0xFFEF7A07),
    strong: Color(0xFF6BBD6E),
  ),
  duration: Duration(milliseconds: 300), // Set the animation duration
  curve: Curves.easeOut, // Set the animation curve
  callback: (double strength) {
    // Receive the strength value of the password
    print('Password Strength: $strength');
  },
  strengthBuilder: (String password) {
            // Calculate and return the strength value
            return _calculateStrength(password);
          },
  style: StrengthBarStyle.dashed, // Choose a style for the strength bar
),
              const SizedBox(height: 22), // Space between the text fields
              TextFormField(
                controller: confirmpassword,
                maxLength: 25,
                validator: (value) {
              // Check if the passwords match
              if (value != password.text) {
                return 'Passwords do not match';
              }
              return null; // Return null if validation is successful
            },
            onChanged: (value) {
              setState(() {
                if(password.text.isNotEmpty && confirmpassword.text.isNotEmpty)
                {
                  notequal = true;
                }
              }); // Rebuild to update strength indicator
            },
                buildCounter: null,
                focusNode: confirmFocusNode,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                            icon: _obscurePassword
                                ? SvgPicture.asset('assets/nopassword.svg')
                                : SvgPicture.asset('assets/passwordvisible.svg'),
                            onPressed: () {
                              setState(() {
                                _obscureconfirmPassword = !_obscureconfirmPassword;

                              });
                            },
                          ),
                  errorBorder: notequal
                                ? OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  )
                                : null,
                  counterText: "",
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: _obscureconfirmPassword,
                obscuringCharacter: '●',
                style: TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
              ),
              const SizedBox(height: 20),
              if(passwordFocusNode.hasFocus || confirmFocusNode.hasFocus)
              SizedBox(
                    height: 42,
                    width: 328,
                    child: Text(
                      'Use 8-25 characters with at least one uppercase letter, number, and special character.',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xFF4D5962),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,), // Space between the text fields
              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: isLoading
    ? null
    : () async {
        if(_calculateStrength(password.text) == 1)
        {
          setState(() {
          // Start loading state
          isLoading = true; // Directly access the ViewModel's loading state
        });

        await viewModel.sendOtp(widget.email, password.text, confirmpassword.text);

        // Check for success or error messages from the ViewModel
        if (viewModel.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const LoginPage(),
    ),
  );
        } else if (viewModel.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Comply with the rules of password."),
              backgroundColor: Colors.red,
            ),
          );
        }

        setState(() {
          // End loading state
          isLoading = false; // Update the loading state in the ViewModel
        });
        }
        else
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Comply with the rules of password."),
              backgroundColor: Colors.red,
            ),
          );
        }
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