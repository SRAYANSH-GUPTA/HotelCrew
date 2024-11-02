import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Define the onboarding content
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to HotelCrew!",
      "description": "Manage tasks, track performance, and communicate seamlessly across teams.",
    },
    {
      "title": "Manage Your Team with Ease",
      "description": "Assign tasks, track attendance, and streamline shift scheduling all in one place.",
    },
    {
      "title": "Stay Connected Across Departments",
      "description": "Send messages, make announcements, and keep everyone updated.",
    },
     {
      "title": "Monitor and Optimize",
      "description": "View staff performance and track hotel operations in real time.",
    },
     {
      "title": "Ready to Get Started?",
      "description": "Sign up to create a new account or log in to access your existing account.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(index);
                  },
                ),
              ),
              Positioned(
                top: 54,
                right: 16,
                child: _currentPage < _onboardingData.length - 1
                    ? TextButton(
                        onPressed: () {
                          // Skip to the last page
                          _pageController.jumpToPage(_onboardingData.length - 1);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: _currentPage < _onboardingData.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          _currentPage == 0 ? 'Getting Started' : 'Next',
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
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle sign-up action
                                _handleSignUp();
                              },
                              child: Text('Sign Up',
                              style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFFFAFAFA),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),),
                              style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                            ),
                          ),
                          SizedBox(width: 16), // Space between the buttons
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle log-in action
                                _handleLogin();
                              },
                              child: Text('Log In',
                              style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFFFAFAFA),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),),
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
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildOnboardingPage(int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      height: 544,
      width: 328,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the top
        children: [
          SizedBox(height: 98), // Optional space from the top
          Text(
            _onboardingData[index]["title"]!,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            _onboardingData[index]["description"]!,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Space between description and SVG
          SvgPicture.asset(
            'assets/onboarding${index + 1}.svg', // Ensure the path is correct
            height: 298.96,
            width: 301.96,
          ),
        ],
      ),
    ),
  );
}


  void _handleSignUp() {
    // Implement your sign-up logic here
    print("Sign Up pressed");
  }

  void _handleLogin() {
    // Implement your log-in logic here
    print("Log In pressed");
  }
}
