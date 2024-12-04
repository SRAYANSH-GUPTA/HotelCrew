import 'package:email_validator/email_validator.dart';
import 'otpview.dart';
import '../../models/register.dart';
import '../../auth_view_model/registerviewmodel.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/passwordvalidation.dart';
import '../../../../core/packages.dart';
import 'package:flutter/services.dart';
import "login_page.dart";
// Add this import


class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
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
  final FocusNode _focusNode = FocusNode();
  bool _showValidationCard = false;
  final _formKey = GlobalKey<FormState>();

  final RegExp upperCaseRegExp = RegExp(r'[A-Z]');
  final RegExp lowerCaseRegExp = RegExp(r'[a-z]');
  final RegExp digitRegExp = RegExp(r'\d');
  final RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final int minLength = 8;

  void _validatePassword() {
    ref.read(passwordValidationProvider.notifier).validatePassword(password.text);

    // Show validation card if password field is focused and has input
    setState(() {
      _showValidationCard = _focusNode.hasFocus && password.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        // Update the validation card visibility based on focus and input text
        _showValidationCard = _focusNode.hasFocus && password.text.isNotEmpty;
      });
    });
    password.addListener(_validatePassword);
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

    // List of common passwords to reject
    const commonPasswords = [
      // 'password', '12345678', 'qwerty', 'abc123', 'letmein', 'iloveyou'
    ];
    return !commonPasswords.contains(password.toLowerCase());
  }

  @override
  void dispose() {
    emailController.dispose();
    password.dispose();
    _focusNode.dispose();
    confirmpassword.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validationState = ref.watch(passwordValidationProvider);
    const tooltipContent = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Password must be at least 8 characters and include:"),
        Text('• One Uppercase letter'),
        Text('• One Number'),
        Text('• One Special Character'),
      ],
    );

    final isVisible = context.loaderOverlay.visible;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double responsiveWidth = screenWidth * 0.9;

    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                child: Form(
                  key: _formKey,
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
                             inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                               FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Deny spaces
                            ],
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Pallete.primary700,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: const Color(0xFF5B6C78),
                            ),
                            // inputFormatters: [
                              //
                            // ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
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
                             inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Deny spaces
                            ],
                            maxLength: 320,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Pallete.primary700,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              suffixIcon: validEmail
                                  ? null
                                  : const Icon(
                                      Icons.error,
                                      color: Color(0xFFC80D0D),
                                    ),
                            ),
                            // inputFormatters: [
                            //   
                            // ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                        child: SizedBox(
                          width: responsiveWidth,
                          child: ElTooltip(
                            position: ElTooltipPosition.bottomStart,
                            content: tooltipContent,
                            color: const Color(0XFFEA4747),
                            child: TextFormField(
                              controller: password,
                               inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                               FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Deny spaces
                            ],
                              focusNode: _focusNode,
                              
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
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Pallete.primary700,
                                    width: 2.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                // <-- Add this line to validate the password as user types
                              },
                            //   inputFormatters: [
                            //  
                            // ],
                              obscureText: _obscurePassword,
                              obscuringCharacter: '●',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: const Color(0xFF5B6C78),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      if (_showValidationCard)
                        PasswordValidationCard(validationState: validationState),
                      SizedBox(height: screenWidth * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                        child: SizedBox(
                          width: responsiveWidth,
                          child: TextFormField(
                            controller: confirmpassword,
                             inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')), // Deny spaces
                            ],
                            maxLength: 25,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Pallete.primary700,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            // inputFormatters: [
                            //   
                            // ],
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
                            // Checkbox Container
                            Container(
                              height: 18,
                              width: 18,
                              padding: const EdgeInsets.only(top: 8),
                              margin: EdgeInsets.zero,
                              child: CheckboxTheme(
                                data: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    width: 1,
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
                                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.selected)) {
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
                            SizedBox(width: screenWidth * 0.022),
                            // Text with RichText Widget
                            Flexible(
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF121212),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Color(0xFF5662AC),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                        color: Color(0xFF5662AC),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print("Privacy Policy tapped");
                                        },
                                    ),
                                  ],
                                ),
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
                              hideKeyboard(context);
                              if (_isLoading || isVisible) return;
                              if (!checkBoxValue) {
                                _showSnackbar('Accept Terms and Conditions');
                                return; // Exit if terms are not accepted
                              }
                              if (!_formKey.currentState!.validate()) {
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
                                _isLoading = true;
                                context.loaderOverlay.show(); // Start loading
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

                                  if (response != null && response is UserRegistrationResponse) {
                                    if (response.message == 'OTP sent successfully') {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(response.message),
                                      ));
                                      context.loaderOverlay.hide();
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
                                    context.loaderOverlay.hide();
                                  } else if (response == "Server Error") {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(response),
                                    ));
                                    context.loaderOverlay.hide();
                                  }
                                  else if (response == "User with this email already exists.") {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(response),
                                    ));
                                    context.loaderOverlay.hide();}
                                  
                                   else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(response ?? "Unexpected Error"),
                                    ));
                                    context.loaderOverlay.hide();
                                  }
                                } on ApiError {
                                  setState(() => _isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Unexpected error"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  context.loaderOverlay.hide();
                                } catch (e) {
                                  setState(() => _isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('An unecxpcted error'),
                                  ));
                                  context.loaderOverlay.hide();
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                  context.loaderOverlay.hide();
                                });
                                _showSnackbar('Passwords do not match');
                              }
                              context.loaderOverlay.hide();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF47518C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: false
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
                      Container(
                        width: screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already a member?",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: const Color(0xFF4D5962),
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * 0.03,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.088,
                              child: TextButton(
                                
                                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                                child: Text(
                                  "Log In",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: const Color(0xFF5662AC),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      height: 1.3,
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
            ),
          ),
        ),
      ),
    );
  }
}