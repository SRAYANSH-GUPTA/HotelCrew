import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Hoteldetailspage1 extends StatefulWidget {
  const Hoteldetailspage1({super.key});

  @override
  State<Hoteldetailspage1> createState() => _Hoteldetailspage1State();
}

class _Hoteldetailspage1State extends State<Hoteldetailspage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Container(
          margin: EdgeInsets.only(left: 16,right: 16,top: 74),
          
              height: 63,
              width: 328,
              child: 
              Text(textAlign: TextAlign.center,
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
          SizedBox(height: 11),
          Container(
            height: 24,
            width: 328,
            child: 
            Text(
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
          SizedBox(height: 76),
          SvgPicture.asset(
                'assets/hoteldetailspage.svg', // Ensure the path is correct
                height: 298.96,
                width: 301.96,
              ),
              SizedBox(height: 128.04,),

              SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () {
                    print("Next!!!!!!!!");
                   
                  },
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