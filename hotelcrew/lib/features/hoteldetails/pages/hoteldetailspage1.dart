import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hoteldetailspage2.dart';


class Hoteldetailspage1 extends StatefulWidget {
  const Hoteldetailspage1({super.key});

  @override
  State<Hoteldetailspage1> createState() => _Hoteldetailspage1State();
}

class _Hoteldetailspage1State extends State<Hoteldetailspage1> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.1,
            ),
            height: screenHeight * 0.1,
            width: screenWidth * 0.9,
            child: Text(
              textAlign: TextAlign.center,
              'Let’s Set Up Your Hotel Profile',
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
          SizedBox(height: screenHeight * 0.015),
          SizedBox(
            height: screenHeight * 0.066,
            width: screenWidth * 0.9,
            child: Text(
              textAlign: TextAlign.center,
              'Help us get to know your hotel better',
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
          SizedBox(height: screenHeight * 0.1),
          SvgPicture.asset(
            'assets/hoteldetailspage.svg', // Ensure the path is correct
            height: screenHeight * 0.35,
            width: screenWidth * 0.8,
          ),
          SizedBox(height: screenHeight * 0.15),
          SizedBox(
            height: screenHeight * 0.06,
            width: screenWidth * 0.9,
            child: ElevatedButton(
              onPressed: () {
                print("Next!");
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ProgressPageView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF47518C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Next',
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
    );
  }
}
