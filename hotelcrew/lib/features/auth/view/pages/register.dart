import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view/pages/login_page.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'otpview.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool checkBoxValue = false;
  final FocusNode passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool validEmail = true;
  final confirmpassword = TextEditingController(text: "");
final password = TextEditingController(text: "");
final username = TextEditingController(text: "");
final emailController = TextEditingController(text: ""); // Fixed variable name to match usage
bool _isLoading = false;
bool _isVisible = false;
bool isPasswordValid(String password, String username, String email) {
  // Check for length
  if (password.length < 8) return false;

  // Check if the password is entirely numeric
  if (RegExp(r'^\d+$').hasMatch(password)) return false;

  // Add more checks for similarity to username or email
  if (password.toLowerCase().contains(username.toLowerCase()) ||
      password.toLowerCase().contains(email.toLowerCase().split('@')[0])) {
    return false;
  }

  // Check against commonly used passwords (example list)
  const commonPasswords = [
    'password', '12345678', 'qwerty', 'abc123', 'letmein', 'iloveyou'
  ];
  if (commonPasswords.contains(password.toLowerCase())) return false;

  return true;
}
void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        validEmail = EmailValidator.validate(emailController.text);
        // Reset invalid credentials when the email is changed
      });
    });
    password.addListener(() {
    setState(() {}); // Trigger rebuild to check button state
  });
  }

  @override
  void dispose() {
    emailController.dispose();
    password.dispose(); // Fixed to dispose of the correct controller
    confirmpassword.dispose(); // Added disposal for confirm password controller
    username.dispose(); // Added disposal for username controller
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
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                ),
              ),
              Container(
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 22),
                    child: TextFormField(
                      controller: emailController,
                      maxLength: 320,
                      validator: (value) {
                        if (EmailValidator.validate(value ?? '')) {
                          return null;
                        } else {
                          return "Enter a valid email.";
                        }
                      },
                      style: const TextStyle(fontSize: 20, color: Color(0xFF5B6C78)),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: validEmail
                            ? null
                            : OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                        suffixIcon: validEmail
                            ? null
                            : const Icon(
                                Icons.error,
                                color: Color(0xFFC80D0D),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 22),
                  child: TextFormField(
                    controller: password,
                    maxLength: 25,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      counterText: "",
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
                    obscureText: _obscurePassword,
                    obscuringCharacter: '●',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF5B6C78),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 22),
                  child: TextFormField(
                    controller: confirmpassword,
                    maxLength: 25,
                    validator: (value) {
                      if (value != password.text) {
                        return "Passwords do not match.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // suffixIcon: IconButton(
                      //   icon: _obscurePassword
                      //       ? SvgPicture.asset('assets/nopassword.svg')
                      //       : SvgPicture.asset('assets/passwordvisible.svg'),
                      //   onPressed: () {
                      //     setState(() {
                      //       _obscurePassword = !_obscurePassword;
                      //     });
                      //   },
                      // ),
                    ),
                    obscureText: _obscurePassword,
                    obscuringCharacter: '●',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF5B6C78),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () async {
  if (isPasswordValid(password.text, username.text, emailController.text)) {
    if (_isLoading) return; // Prevent multiple taps while loading
    final dioClient = DioClient();
    print(username.text);
    print(emailController.text);
    print(password.text);
    print(confirmpassword.text);
    
    if (password.text == confirmpassword.text) {
      final registrationRequest = UserRegistrationRequest(
        userName: username.text,
        email: emailController.text,
        password: password.text,
        confirmPassword: confirmpassword.text,
      );
      print(registrationRequest);
      
      setState(() {
        _isLoading = true; // Start loading
      });
      
      try {
        final response = await dioClient.registerUser(registrationRequest);
        setState(() {
          _isLoading = false;
          _isVisible = false; // End loading
        });
        
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.message),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otpview(
                email: emailController.text,
                username: username.text,
                password: password.text,
                confirmpassword: confirmpassword.text,
              ),
            ),
          );
          print("#############");
        }
      } on ApiError catch (e) {
        // Handle the ApiError and show it to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
          duration: const Duration(seconds: 2),
        ));
      } catch (e) {
        // Handle any unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Passwords do not match'),
        duration: const Duration(seconds: 2),
      ));
    }
  } else {
    _showSnackbar('Password does not meet the requirements.');
    setState(() {
      _isVisible = true;
    });
  }
},



                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading // Check if loading
          ? Container(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
                color: Colors.white, // Set the indicator color
              ),
          )
          : Text(
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
    )
              ),
              SizedBox(height: 30,),
              // SizedBox(
              //   height: 34,
              //   width: 26,
              //   child: Row(
              //     children: [
              //       Container(
              //         child: Padding(
              //           padding: const EdgeInsets.only(right: 7),
              //           child: SizedBox(
              //             height: 18,
              //             width: 18,
              //             child: CheckboxTheme(
              //               data: CheckboxThemeData(
              //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              //                 side: const BorderSide(width: 0, color: Colors.transparent), // Removes outline
              //               ),
              //               child: Checkbox(
              //                 checkColor: Colors.white, // Color of the check mark
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(4),
              //                   side: const BorderSide(color: Colors.transparent),
              //                 ),
              //                 value: checkBoxValue,
              //                 splashRadius: 0,
              //                 fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              //                   if (states.contains(MaterialState.selected)) {
              //                     return const Color(0xFF5662AC); // Color when the checkbox is checked
              //                   }
              //                   return const Color(0xFFC6D6DB); // Color when unchecked
              //                 }),
              //                 onChanged: (newValue) {
              //                   setState(() {
              //                     checkBoxValue = newValue ?? false;
              //                   });
              //                 },
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width:328,
              //         height: 58,
              //         child: Row(
              //           children: [Text(
              //           'I agree to the',
              //           style: GoogleFonts.montserrat(
              //             textStyle: const TextStyle(
              //               color: Color(0xFF4D5962),
              //               fontWeight: FontWeight.w400,
              //               fontSize: 14,
              //               height: 1.5,
              //             ),
              //           ),
              //         ),
              //             Container(
              //               width: 140,
              //               height: 21,
              //               child: InkWell(
              //                 onTap: () => print('Terms and Conditions link'),
              //                 child: const Text(
              //                   "Terms & Conditions",
              //                   style: TextStyle(color: Color(0xFF5662AC)),
              //                 ),
              //               ),
              //             ),
              //             const Text(" and "),
              //             InkWell(
              //               onTap: () => print("Privacy Policy"),
              //               child: const Text(
              //                 "Privacy Policy",
              //                 style: TextStyle(color: Color(0xFF5662AC)),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              _isVisible 
  ? Container(
                height:126,
                width:328,
                child: Column(children: [
                  Text("Password must be at least 8 characters long and"),
                  Text("include"),
      Text('One Upper case character'),
      Text('One number'),
      Text("One Special Character"),
                ],),
                ) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
