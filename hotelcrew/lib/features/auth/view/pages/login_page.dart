import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hotelcrew/features/auth/view/pages/register.dart';
import '../../auth_view_model/loginpageviewmodel.dart';
import '../../../resetpass/resertpasspage/resetpass.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBoxValue = false;
  final emailController = TextEditingController(text: "");
final passwordController = TextEditingController(text: "");
  final authViewModel = AuthViewModel();
  bool validEmail = true;
  bool _obscurePassword = true;
  bool _isLoading = false; // Track loading state
  bool _isInvalidCredentials = false; // Track invalid credentials state
  int login = 0;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        validEmail = EmailValidator.validate(emailController.text);
        // Reset invalid credentials when the email is changed
        _isInvalidCredentials = false;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 328,
                    height: 63,
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Welcome Back to HotelCrew!',
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
                  const SizedBox(height: 29.26),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 52.73, right: 69.42),
                      child: SvgPicture.asset(
                        'assets/login.svg', // Ensure the path is correct
                        height: 205.85,
                        width: 202.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.69),
                  Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: emailController,
                          maxLength: 320,
                          style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF5B6C78),
                        ),
                          validator: (value) {
                            if (EmailValidator.validate(value ?? '')) {
                              return null;
                            } else {
                              return "Enter a valid email.";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: validEmail
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  )
                                : null,
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
                  const SizedBox(height: 4),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 22),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (_isInvalidCredentials) {
                            return "Invalid Credentials"; 
                          }
                          return null; // No error
                        },
                        decoration: InputDecoration(
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
                        obscureText: _obscurePassword,
                        obscuringCharacter: '●',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF5B6C78),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Resetpass(),
  ),
);

                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF4D5962),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 21,
                        width: 128,
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CheckboxTheme(
                                    data: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                      side: const BorderSide(width: 0, color: Colors.transparent),  // Removes outline
                                    ),
                                    child: Checkbox(
                                      checkColor: Colors.white, // Color of the check mark
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: const BorderSide(color: Colors.transparent),
                                      ),
                                      value: checkBoxValue,
                                      splashRadius: 0,
                                      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.selected)) {
                                          return const Color(0xFF5662AC); // Color when the checkbox is checked
                                        }
                                        return const Color(0xFFC6D6DB); // Color when unchecked
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
                            SizedBox(
                              height: 21,
                              width: 103,
                              child: Text(
                                'Remember Me',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF4D5962),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.6,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 40,
                    width: 328,
                    child: ElevatedButton(
                      onPressed: _isLoading || emailController.text.isEmpty || passwordController.text.isEmpty
                          ? null // Disable button while loading
                          : () async {
                              setState(() {
                                _isLoading = true; // Start loading
                                _isInvalidCredentials = false; // Reset invalid credentials flag
                              });
                              try {
                                final loginResponse = await authViewModel.loginUser(
                                  emailController.text,
                                  passwordController.text,
                                );

                                // Only if login is successful
                                if (loginResponse.status != 'error') {
                                  print("########################");
                                  print("Login successful!");
                                  print("User ID: ${loginResponse.user?.id ?? "Not available"}");
                                  print("AccessToken: ${loginResponse.tokens?.access ?? "Not available"}");
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Column(
                                      children: [
                                        const Text('Login Successful'),
                                        Text('User ID: ${loginResponse.user?.id ?? "Not available"}'),
                                        Text('Role of User: '), // Assuming you have a role field
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'ACTION',
                                      onPressed: () {},
                                    ),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Column(
                                      children: [
                                        Text('Login Unsuccessful'),
                                        Text('Try Again'),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              } catch (e) {
                                print("###################");
                                print("Login failed: $e");
                                emailController.clear();
                                passwordController.clear();
                                setState(() {
                                  _isInvalidCredentials = true; // Show invalid credentials message
                                });
                              } finally {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5662AC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading // Conditional loading indicator
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFAFAFA),
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xFF4D5962),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Register(),
  ),
);
 // Adjust your route here
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: const Color(0xFF5662AC),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
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
