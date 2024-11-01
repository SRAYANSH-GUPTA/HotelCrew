import 'package:flutter/material.dart';
import 'package:hotelcrew/features/auth/view/pages/register.dart';



class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to the LoginPage when OnboardingPage is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const Register(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      // Add some content to the OnboardingPage
      body: Center(
        child: Text('Onboarding Page'),
      ),
    );
  }
}
