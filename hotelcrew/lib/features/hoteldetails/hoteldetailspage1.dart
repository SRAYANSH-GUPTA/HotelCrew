import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          margin: EdgeInsets.only(left: 16,right: 16,top: 36),
          color: Colors.blue,
              height: 63,
              width: 328,
              child: 
              Text(
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
          
        ],
      ),
    );
  }
}