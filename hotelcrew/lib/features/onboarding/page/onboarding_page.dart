import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelcrew/features/auth/view/pages/login_page.dart';
import 'package:hotelcrew/features/auth/view/pages/register.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildOnboarding(index);
                  },
                ),
              ),
              Positioned(
                top: 42,
                right: 16,
                child: (_currentPage < _onboardingData.length - 1 && _currentPage != 0)
                    ? TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(_onboardingData.length - 1);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF5662AC),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Dot Indicators
              Positioned(
                top: 634,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 122,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: _currentPage < _onboardingData.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF47518C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF47518C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF47518C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Log In',
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
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboarding(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 544,
        width: 328,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 98),
            Text(
              _onboardingData[index]["title"]!,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _onboardingData[index]["description"]!,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/onboarding${index + 1}.svg',
              height: 300.08,
              width: 309.96,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8, // Oval for active, circle for others
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF5662AC) : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  void _handleLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
