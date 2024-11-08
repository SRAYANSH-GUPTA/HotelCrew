import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'otpview.dart';
import '../../view/pages/login_page.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool checkBoxValue = false;
  bool _obscurePassword = true;
  bool _obscureconfirmPassword = true;
  bool validEmail = true;
  final confirmpassword = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final emailController = TextEditingController();
  bool _isLoading = false;
  bool _isVisible = false;
  

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        validEmail = EmailValidator.validate(emailController.text);
      });
    });
  }
void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
bool isPasswordValid(String password, String username, String email) {
  // Check for at least 8 characters
  if (password.length < 8) return false;
  
  // Check for at least one uppercase letter, one number, and one special character
  if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
  if (!RegExp(r'[0-9]').hasMatch(password)) return false;
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
  
  // Check if the password contains only digits (to prevent weak numeric passwords)
  if (RegExp(r'^\d+$').hasMatch(password)) return false;
  // Check if the password contains the username or email prefix
  // The email prefix is taken up to the first '@'
  
  // List of common passwords to reject
  const commonPasswords = [
    'password', '12345678', 'qwerty', 'abc123', 'letmein', 'iloveyou'
  ];
  return !commonPasswords.contains(password.toLowerCase());
}

  @override
  void dispose() {
    emailController.dispose();
    password.dispose();
    confirmpassword.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.04,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: responsiveWidth,
                    margin: EdgeInsets.only(top: screenWidth * 0.05),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: responsiveWidth,
                    padding: EdgeInsets.only(top: screenWidth * 0.02),
                    child: Text(
                      'Join us to enhance your hotel operations.',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: const Color(0xFF4D5962),
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: SizedBox(
                      width: responsiveWidth,
                      child: TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color(0xFF5B6C78),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: SizedBox(
                      width: responsiveWidth,
                      child: TextFormField(
                        controller: emailController,
                        maxLength: 320,
                        validator: (value) => EmailValidator.validate(value ?? '')
                            ? null
                            : "Enter a valid email.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color(0xFF5B6C78),
                        ),
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
                  SizedBox(height: screenWidth * 0.07),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: SizedBox(
                      width: responsiveWidth,
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color(0xFF5B6C78),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: SizedBox(
                      width: responsiveWidth,
                      child: TextFormField(
                        controller: confirmpassword,
                        maxLength: 25,
                        validator: (value) {
                          if (value != password.text) return "Passwords do not match.";
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: _obscureconfirmPassword
                                ? SvgPicture.asset('assets/nopassword.svg')
                                : SvgPicture.asset('assets/passwordvisible.svg'),
                            onPressed: () {
                              setState(() {
                                _obscureconfirmPassword = !_obscureconfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureconfirmPassword,
                        obscuringCharacter: '●',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color(0xFF5B6C78),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  SizedBox(
                    width: responsiveWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(padding: EdgeInsets.only(top: 0),
  
  child: Padding(
    padding: EdgeInsets.only(top: 0,
      right: screenWidth * 0.02,
    ),
    child: Container(
      margin: EdgeInsets.only(top: 0), // Adjust top margin here
      child: CheckboxTheme(
        data: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          side: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        child: Checkbox(
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          value: checkBoxValue,
          splashRadius: 0,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF5662AC);
            }
            return const Color(0xFFC6D6DB);
          }),
          onChanged: (newValue) {
            setState(() {
              checkBoxValue = newValue ?? false;
            });
          },
        ),
      ),
    ),
  ),
),

                        Flexible(
                          child: Wrap(
                            spacing: 4,
                            children: [
                              Text(
                                'I agree to the',
                                 style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Color(0xFF121212),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                              Text(
                                ' Terms and Conditions',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: const Color(0xFF5662AC),
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                              const Text("and"),
                InkWell(
                  onTap: () => print("Privacy Policy"),
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Color(0xFF5662AC),
                     fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.5,
                  ),),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.17),
                  Padding(
                    padding: EdgeInsets.only(top: screenWidth * 0.04),
                    child: SizedBox(
                      width: responsiveWidth,
                      height: screenWidth * 0.12,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_isLoading) return;
  if (!checkBoxValue) {
    _showSnackbar('Accept Terms and Conditions');
    return; // Exit if terms are not accepted
  }
  if (!password.text.isNotEmpty || !username.text.isNotEmpty || !emailController.text.isNotEmpty) {
    _showSnackbar('Fill All the Fields First.');
    return;
  }
  if (!isPasswordValid(password.text, username.text, emailController.text)) {
    _showSnackbar('Password does not meet the requirements.');
    setState(() {
      _isVisible = true;
    });
    return;
  }
   // Prevent multiple taps
  setState(() {
    _isLoading = true; // Start loading
    _isVisible = false; // Hide password requirements
  });
  if (password.text == confirmpassword.text) {
    final registrationRequest = UserRegistrationRequest(
      userName: username.text,
      email: emailController.text,
      password: password.text,
      confirmPassword: confirmpassword.text,
    );
    final dioClient = DioClient();
    try {
      final response = await dioClient.registerUser(registrationRequest);
      setState(() => _isLoading = false);

      if (response != null) {
        if (response.message == 'OTP sent successfully') {
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
        } 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: User already exists or another issue'),
        ));
      }
    } on ApiError catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Already Exist or Invalid Email"),
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An unexpected error occurred. Please try again.'),
      ));
    }
  } else {
    setState(() => _isLoading = false);
    _showSnackbar('Passwords do not match');
  }
},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF47518C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Create Account',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: const Color(0xFFFAFAFA),
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (_isVisible)
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.04),
                      child: Column(
                        children: [
                          Text("Password must be at least 8 characters and include:"),
                          Text('• One Uppercase letter'),
                          Text('• One Number'),
                          Text('• One Special Character'),
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
