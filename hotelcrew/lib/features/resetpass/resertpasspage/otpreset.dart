import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:hotelcrew/features/createpwd/createpwdview/createpwdview.dart';
import 'package:hotelcrew/features/hoteldetails/pages/hoteldetailspage1.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import '../models/otpresetmodel.dart';
import '../viewmodel/otpresetviewmodel.dart';
import '../models/resetpassemailmode.dart';
import '../viewmodel/resetpassviewmodel.dart' as reset;

class Otpreset extends StatefulWidget {
  final String email; // Assuming you pass the email to this page

  Otpreset({required this.email});


  @override
  State<Otpreset> createState() => _OtpresetState();
}

class _OtpresetState extends State<Otpreset> {
  late OtpresetModel viewModel;

  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool checkBoxValue = false;
  double svgHeight = 236.03;
  double svgWidth = 232.28;
  bool otperror = false;
  bool _isLoading = false;
  
   final reset.ForgetPasswordViewModel resetviewModel = reset.ForgetPasswordViewModel();
  final FocusNode emailFocusNode = FocusNode();
  final OtpTimerButtonController otp = OtpTimerButtonController();
  String enteredOtp = ""; // Variable to store the OTP entered by the user
bool isLoading = false;

  @override
  void initState() {
    super.initState();
    viewModel = OtpresetModel(); 
    emailFocusNode.addListener(() {
      setState(() {
        if (emailFocusNode.hasFocus) {
          svgHeight = 0;
          svgWidth = 0;
        } else {
          svgHeight = 218.78;
          svgWidth = 231.87;
        }
      });
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 64),
            child: SizedBox(
              width: 328,
              height: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 328,
                    height: 32,
                    child: Text(
                      'Verify Your Account',
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
                      "We've sent a 4-digit verification code to your email ${widget.email}",
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
                  const SizedBox(height: 48),
                  Focus(
                    focusNode: emailFocusNode,
                    child: SizedBox(
                      width: 328,
                      height: 45,
                      child: OtpPinField(
                        fieldHeight: 45,
                          fieldWidth: 45,
                        autoFocus: false,
                        key: _otpPinFieldController,
                        autoFillEnable: false,
                        textInputAction: TextInputAction.done,
                        onSubmit: (text) {
                          enteredOtp = text; // Update enteredOtp when OTP is submitted
                          debugPrint('Entered pin is $enteredOtp');
                        },
                        onChange: (text) {
                          enteredOtp = text; // Update enteredOtp on change
                          debugPrint('Enter on change pin is $enteredOtp');
                        },
                        onCodeChanged: (code) {
                          enteredOtp = code; // Update enteredOtp when code changes
                          debugPrint('onCodeChanged is $enteredOtp');
                        },
                        otpPinFieldStyle: const OtpPinFieldStyle(
                            activeFieldBackgroundColor: Color(0xFFF4F8F9),
                            filledFieldBackgroundColor: Color(0xFFF4F8F9),
                            fieldBorderWidth: 0,
                            fieldBorderRadius: 8,

                            fieldPadding: 25.33,
                          activeFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF4CAF50)]),
                          filledFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFFBA4872), Color(0xFFBA4872)]),
                          defaultFieldBorderGradient:
                              LinearGradient(colors: [Color(0xFF6F8393), Color(0xFF6F8393)]),
                      
                        ),
                        maxLength: 4,
                        showCursor: true,
                        cursorColor: Colors.indigo,
                        cursorWidth: 3,
                        mainAxisAlignment: MainAxisAlignment.center,
                        otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Conditional error message when svgHeight is 0
                  if (svgHeight == 0 && otperror)
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Container(
                        width: 326,
                        height: 39,
                        child: Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(
                              "Incorrect code.",
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFFBA4872),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                            "Check and try again",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFFBA4872),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),]
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.98, right: 45.98),
                    child: SvgPicture.asset(
                      'assets/otp.svg',
                      height: svgHeight,
                      width: svgWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 190,
                    width: 328,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn’t receive the code?"),
                            SizedBox(
                              width: 108,
                              height: 40,
                              child: OtpTimerButton(
                                buttonType: ButtonType.text_button,
                                backgroundColor: Colors.black,
                                controller: otp,
                               onPressed: isLoading ? null :() async {
  
     setState(() {
      isLoading = true; // Start loading
    });
    final response = await reset.ForgetPasswordViewModel().sendForgetPasswordRequest(widget.email);
setState(() {
      isLoading = false; // Stop loading
    });
    if (response is ForgetPasswordSuccessResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Reset Otp sent successfully.")),
      );
      
    } else if (response is ForgetPasswordErrorResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User doesn't exist.")),
      );
    }
  
},

                                text: Text(
                                  'Resend',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF5662AC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                duration: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          width: 328,
                          child: ElevatedButton(
 onPressed: _isLoading
    ? null
    : () async {
       setState(() {
        _isLoading = true;
      });
        await viewModel.sendOtp(widget.email, enteredOtp); // Ensure to replace `email` and `otp` with actual values or inputs
       
        if (viewModel.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => createpwd(email: widget.email,)),
  );
          setState(() {
        _isLoading = false;
      });
        } else if (viewModel.errorMessage != null) {
          setState(() {
            otperror = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
        _isLoading = false;
      });
        }
      },

   style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF47518C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: _isLoading
      ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.white, // Change color as needed
            strokeWidth: 2,
          ),
        )
      : Text(
          'Verify',
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 104),
                              child: Text(
                                'Back To',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF121212),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 61,
                              height: 28,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 0),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF5662AC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
