import 'package:flutter/material.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'page7.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import "dart:convert";
import "staffdetails.dart";

class ProgressPageView extends StatefulWidget {
  const ProgressPageView({super.key});

  @override
  _ProgressPageViewState createState() => _ProgressPageViewState();
}

class _ProgressPageViewState extends State<ProgressPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5; // Total number of pages

  final List<Widget> _pages = [
    const PageOne(),
    const PageTwo(),
    const PageThree(),
    const PageFour(),
    const PageFive(),
    // const Staffdetailsupdated(),
  ];

  final List<String> _hotelInfo = [
    'Basic Hotel Information',
    'Contact & Location',
    'Property Details',
    'Operational Information',
    'Room Details',
    'Upload Staff Details',
  ];

  @override
  void initState() {
    super.initState();
    clearPreferences(); // Clear specific keys from SharedPreferences
  }

  void clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('hotel_name');
    await prefs.remove('legal_business_name');
    await prefs.remove('year_established');
    await prefs.remove('license_number');
    await prefs.remove('primary_contact');
    await prefs.remove('emergency_contact');
    await prefs.remove('emails');
    await prefs.remove('address');
    await prefs.remove('country_code');
    await prefs.remove('numberofrooms');
    await prefs.remove('typesofroom');
    await prefs.remove('numberoffloors');
    await prefs.remove('parkingCapacity');
    await prefs.remove('checkin_time');
    await prefs.remove('checkout_time');
    await prefs.remove('payment_method');
    await prefs.remove('parking_capacity');
    await prefs.remove('numberOfDepartments');
    await prefs.remove('rooms');
     await prefs.remove('filepath');
    await prefs.remove('filename'); 
    await prefs.remove('types'); // Clear room details
  }

Future<void> uploadData({String? filePath, String? fileName}) async {
  try {
    log('Uploading data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token') ?? "";
    print(accessToken);
    if (accessToken.isEmpty) {
      log("Access token is missing.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token is missing."), backgroundColor: Colors.red),
      );
      return;
    }

    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json', // Set Content-Type to JSON
      'Authorization': 'Bearer $accessToken',
    };
     dio.options.validateStatus = (status) => true; // Allows all responses for debugging

    // Retrieve room details from SharedPreferences
    String? roomsJson = prefs.getString('room_types');
    List<Map<String, dynamic>> rooms = roomsJson != null ? List<Map<String, dynamic>>.from(jsonDecode(roomsJson)) : [];

    // Prepare raw JSON body
    Map<String, dynamic> rawData = {
       'user': prefs.getString('userid'),
        'hotel_name': prefs.getString('hotel_name'),
        'legal_business_name': prefs.getString('legal_business_name'),
        'year_established': prefs.getString('year_established'),
        'license_registration_numbers': prefs.getString('license_number'),
        'complete_address': prefs.getString("address"),
        'main_phone_number': prefs.getString('primary_contact'),
        'emergency_phone_number': prefs.getString('emergency_contact'),
        'email_address': prefs.getString('emails'),
        'total_number_of_rooms': prefs.getString('numberofrooms'),
        'number_of_floors': prefs.getString('numberoffloors'),
        'valet_parking_available': prefs.getString('availability'),
        'valet_parking_capacity': prefs.getString('parkingCapacity'),
        'check_in_time': "${prefs.getString('checkin_time') ?? "00:00"}:00",
        'check_out_time': "${prefs.getString('checkout_time') ?? "00:00"}:00",
        'payment_methods': prefs.getString('payment_method'),
        'room_price': prefs.getString('price') ?? '',
        'number_of_departments': 2,
        'department_names': 'Reception, Housekeeping, Maintenance, Kitchen, Security',
      "room_types": rooms, // Use the room types list
    };

    log("Raw Data: $rawData");
    print("Raw Data: $rawData");
    print("&"*100);

    // Send POST request
    Response response = await dio.post(
      'https://hotelcrew-1.onrender.com/api/hoteldetails/register/',
      data: jsonEncode(rawData), // Encode raw data as JSON
    );

    print("^"*100);
  print(response.statusCode);
  print(response.data);
    // Handle response
   if (response.statusCode == 201) {
        print('Upload successful: ${response.data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hotel Registered Successfully"),
            backgroundColor: Colors.green,
          ),
        );
        prefs.setString("Role", "Admin");
        clearPreferences();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Staffdetails()),
        );
      } else if (response.statusCode == 401) {
        print('Unauthorized: ${response.data}');
        log('Response data for 401 error: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['name'] ?? "Unauthorized. Check your credentials."),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.data}');
        String errorMessage;

        // Check if the error response contains a 'message' field
        if (response.data is Map && response.data.containsKey('message')) {
          errorMessage = response.data['message']; // Extract the message
        } else {
          // Fallback to a default error message
          errorMessage = response.data.toString() ?? "Bad request. Please check your data and try again.";
        }

        log('Response data for 400 error: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 500) {
        print('Server Error: ${response.data}');
        log('Response data for 500 error: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server Error. Please try again later."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('Unexpected Error: ${response.statusCode}');
        log('Error data: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? "Unexpected error occurred."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } on DioException catch (e) {
      log('Dio Exception: $e');
      String errorMessage = "An error occurred";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your network and try again.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server response timeout. Please try again later.";
      } else if (e.type == DioExceptionType.badResponse) {
        print(e.response?.data);
        errorMessage = e.response?.data['message'] ?? "Invalid response from server.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      log('Unexpected Error: $e');
      print('Unexpected Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File Path not found"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      context.loaderOverlay.hide(); // Hide the loader overlay
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      print("Finished");
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
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
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return GlobalLoaderOverlay(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.2),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05),
              child: SizedBox(
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
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                                backgroundColor: Colors.transparent,
                                value: (_currentPage + 1) / _totalPages,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                          height: screenHeight * 0.03,
                          child: Text(
                            '${_currentPage + 1}/$_totalPages',
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
                    const SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.05),
                      child: InkWell(
                        onTap: _goToPreviousPage,
                        child: SizedBox(
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
                    const SizedBox(height:24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Text(
                        _hotelInfo[_currentPage],
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
              color: const Color(0xFFC6D6DB),
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
            Visibility(
              visible: !isKeyboardVisible,
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.06),
                height: screenHeight * 0.06,
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if (_currentPage != _totalPages - 1) {
                      _goToNextPage();
                    } else {
                      print(prefs.getString("filepath"));
                      print("!!!"*100);
                      context.loaderOverlay.show(); // Show the loader overlay
                      await uploadData(
                        filePath: prefs.getString('filepath'),
                      
                        fileName: prefs.getString('filename'),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _currentPage < _totalPages - 1 ? 'Next' : 'Save Information',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontWeight: FontWeight.w600,
                        fontSize: screenHeight * 0.018,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}