import 'package:flutter/material.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'page7.dart';
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
  ];

  // List of strings to display based on the page number
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
      // Handle finish action
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
      Navigator.pop(context); // Navigate back to the previous screen if on the first page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 185,
        
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
            width: 328,
            height: 141,
            child: Column(
              children: [
                Row(
          
                  children: [
                    Container(
                      child: Container(
                        width: 288,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // Set the border radius
                          color: Colors.grey[300], // Set the background color
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8), // Apply the same radius to the indicator
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                            backgroundColor: Colors.transparent, // Use transparent for the background
                            value: (_currentPage + 1) / _totalPages,
                          ),
                        ),
                      ),
                    ),
                    
                    Container(
                      width: 24,
                      height: 21,
                      
                      margin: const EdgeInsets.only(left: 10, right: 4),
                      child: Text(
                        textAlign: TextAlign.left,
                        '${_currentPage + 1}'+'/'+'${_totalPages}',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Added space between row and button
                // Container(
                //   color: Colors.black,
                //   height: 24,
                //   width: 56,
                //   child: TextButton(
                //     style: ButtonStyle(
                //       backgroundColor: WidgetStateProperty.all(Colors.blue),
                //     ),
                //     onPressed: () {
                //       _goToPreviousPage(); // Call the method to go back
                //     },
                //     child: Row(mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Container(
                //           width: 8,
                //           height: 16,
                //           child: Text('<'),
                //         ),
                //         SizedBox(width: 8),
                //         Text(
                //           'Back',
                //           style: GoogleFonts.montserrat(
                //             textStyle: const TextStyle(
                //               color: Color(0xFF4D5962),
                //               fontWeight: FontWeight.w600,
                //               fontSize: 16,
                //               height: 1.5,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
               Container(
  width: 328,
  height: 32,
  margin: const EdgeInsets.only(top: 24),
  alignment: Alignment.centerLeft, // Align the container's content to the left
  child: Text(
    _hotelInfo[_currentPage], // Your text goes here
    textAlign: TextAlign.left, // Aligns text to the left
    style: GoogleFonts.montserrat(
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.3,
      ),
    ),
  ),
),
SizedBox(
  height: 10,
),
Container(
          width: 360,
          height: 1,
          color: Colors.black,
        ),

              ],
            ),
          ),
          
        ),
        
      ),
      body: Column(
        children: [Container(
          width: 360,
          height: 1,
          color: Colors.black,
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
            margin: EdgeInsets.only(bottom: 46),
            height: 40,
            width: 328,
            child: ElevatedButton(
              onPressed: () {
                _goToNextPage();
              },
              child: Text(
                _currentPage < _totalPages - 1 ? 'Next' : 'Finish',
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
