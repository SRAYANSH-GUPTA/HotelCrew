import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hoteldetailspage2.dart';

class SetupComplete extends StatefulWidget {
  const SetupComplete({super.key});

  @override
  State<SetupComplete> createState() => _SetupCompleteState();
}

class _SetupCompleteState extends State<SetupComplete> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 100),
            height: 32,
            width: screenWidth * 0.9, // Make the width responsive
            child: Text(
              'Setup Complete',
              textAlign: TextAlign.center,
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
          SizedBox(height: 16),
          Container(
            height: 72,
            width: screenWidth * 0.9, // Make the width responsive
            child: Text(
              'Hotel and staff details are set up. You can view or edit them anytime from the dashboard.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Color(0xFF5B6C78),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.3,
                ),
              ),
            ),
          ),
          SizedBox(height: 58.2),
          SvgPicture.asset(
            'assets/setupcomplete.svg', // Ensure the path is correct
            height: 241.56,
            width: screenWidth * 0.85, // Make the width responsive
          ),
          SizedBox(height: 158.24),
          SizedBox(
            height: 40,
            width: screenWidth * 0.9, // Make the width responsive
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ProgressPageView(),
                  ),
                );
              },
              child: Text(
                'Go to Dashboard',
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
    );
  }
}
