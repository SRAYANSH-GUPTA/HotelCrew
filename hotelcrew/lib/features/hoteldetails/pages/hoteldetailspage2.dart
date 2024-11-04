import 'package:flutter/material.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'page7.dart';
import 'page8.dart';
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
//final double appBarHeight = 141 + MediaQuery.of(context).padding.top;
  final List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
    PageFour(),
    PageFive(),
    Document(),
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
      appBar: PreferredSize(
        
  preferredSize: Size.fromHeight(147.0),
  child: AppBar(
    automaticallyImplyLeading: false,
    flexibleSpace: Padding(
      padding: const EdgeInsets.only(top: 44.0, bottom: 0),
      child: Container(
        width: double.infinity, // Occupy full width
        height: 141,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10,left: 16,right: 0,bottom:16),
                  child: Container(
                    width: 288,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set the border radius
                      color: Colors.grey[300], // Set the background color
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Apply the same radius to the indicator
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        backgroundColor: Colors.transparent,
                        value: (_currentPage + 1) / _totalPages,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 21,
                  margin: const EdgeInsets.only(left: 10, right: 4,top: 0),
                  child: Text(
                    textAlign: TextAlign.left,
                    '${_currentPage + 1}' + '/' + '${_totalPages}',
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
            
            const SizedBox(height: 24), // Space between row and text
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
              child: Container(
                width: 328,
                height: 32,
                margin: const EdgeInsets.only(top: 24, bottom: 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  _hotelInfo[_currentPage], // Your text goes here
                  textAlign: TextAlign.left,
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
            ),
           
          ],
        ),
      ),
    ),
  ),
),

      body: Column(
        children: [Container(
          width: 360,
          height: 1,
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
            margin: EdgeInsets.only(bottom: 46),
            height: 40,
            width: 328,
            child: ElevatedButton(
              onPressed: () {
                if(_currentPage != _totalPages-1){_goToNextPage();}
                else{
                  Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => SetupComplete(),
        ),
      );
                }
              },
              child: Text(
                _currentPage < _totalPages - 1 ? 'Next' : 'Save Information',
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
