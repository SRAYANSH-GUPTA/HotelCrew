import 'package:flutter/material.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'page7.dart';
import 'page8.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'setupcomplete.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressPageView extends StatefulWidget {
  @override
  _ProgressPageViewState createState() => _ProgressPageViewState();
}

class _ProgressPageViewState extends State<ProgressPageView> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6; // Total number of pages

  final List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
    PageFour(),
    PageFive(),
    Document(),
  ];

  final List<String> _hotelInfo = [
    'Basic Hotel Information',
    'Contact & Location',
    'Property Details',
    'Operational Information',
    'Staff Management',
    'Documents Upload',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      print("Finished");
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.2),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.05),
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.01,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                              backgroundColor: Colors.transparent,
                              value: (_currentPage + 1) / _totalPages,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.08,
                        height: screenHeight * 0.03,
                        child: Text(
                          '${_currentPage + 1}' + '/' + '$_totalPages',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: screenHeight * 0.018,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.05),
                    child: InkWell(
                      onTap: _goToPreviousPage,
                      child: Container(
                        width: screenWidth * 0.2,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/backarrow.svg',
                              height: screenHeight * 0.02,
                              width: screenWidth * 0.02,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Back',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF4D5962),
                                fontWeight: FontWeight.w400,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Text(
                      _hotelInfo[_currentPage],
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: screenHeight * 0.03,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.0015,
            color: Color(0xFFC6D6DB),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.06),
            height: screenHeight * 0.06,
            width: screenWidth * 0.9,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage != _totalPages - 1) {
                  _goToNextPage();
                } else {
                  // Handle save action
                }
              },
              child: Text(
                _currentPage < _totalPages - 1 ? 'Next' : 'Save Information',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Color(0xFFFAFAFA),
                    fontWeight: FontWeight.w600,
                    fontSize: screenHeight * 0.018,
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
