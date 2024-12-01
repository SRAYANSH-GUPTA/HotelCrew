import 'package:flutter/material.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';
import 'page6.dart';
import 'page7.dart';
import 'staffdetailsupdated.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressPageView extends StatefulWidget {
  const ProgressPageView({super.key});

  @override
  _ProgressPageViewState createState() => _ProgressPageViewState();
}

class _ProgressPageViewState extends State<ProgressPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6; // Total number of pages

  final List<Widget> _pages = [
    const PageOne(),
    const PageTwo(),
    const PageThree(),
    const PageFour(),
    const PageFive(),
    const Staffdetailsupdated(),
  ];

  final List<String> _hotelInfo = [
    'Basic Hotel Information',
    'Contact & Location',
    'Property Details',
    'Operational Information',
    'Staff Management',
    'Upload Staff Details',
  ];

  void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hotel_name', "");
    await prefs.setString('legal_business_name', "");
    await prefs.setString('year_established', "");
    await prefs.setString('license_number', "");
    await prefs.setString('primary_contact', "");
    await prefs.setString('emergency_contact', "");
    await prefs.setString('email', "");
    await prefs.setString('address', "");
    await prefs.setString('country_code', "");
    await prefs.setString('numberofrooms', "");
    await prefs.setString('typesofroom', "");
    await prefs.setString('numberoffloors', "");
    await prefs.setString('address', "");
    await prefs.setString('parkingCapacity', "");
    await prefs.setString('checkin_time', "");
    await prefs.setString('checkout_time', "");
    await prefs.setString('payment_method', "");
    await prefs.setString('parking_capacity', "");
    await prefs.setString('numberOfDepartments', "");
  }

  Future<void> uploadData({String? filePath, String? fileName}) async {
    try {
      log('Uploading data');
      print("daya");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? "";

      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $accessToken',
      };
      dio.options.validateStatus = (status) => true; // Allows all responses for debugging

      Map<String, dynamic> formDataMap = {
        'user': prefs.getString('userid'),
        'hotel_name': prefs.getString('hotel_name'),
        'legal_business_name': prefs.getString('legal_business_name'),
        'year_established': prefs.getString('year_established'),
        'license_registration_numbers': prefs.getString('license_number'),
        'complete_address': "ghaziabad",
        'main_phone_number': prefs.getString('primary_contact'),
        'emergency_phone_number': prefs.getString('emergency_contact'),
        'email_address': prefs.getString('email'),
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
      };

      if (filePath != null && fileName != null && filePath.isNotEmpty && fileName.isNotEmpty) {
        formDataMap['staff_excel_sheet'] = await MultipartFile.fromFile(filePath, filename: fileName);
      }

      FormData formData = FormData.fromMap(formDataMap);

      Response response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/hoteldetails/register/',
        data: formData,
      );
      print('Response: ${response.data}');
      // Handle responses based on status code
      if (response.statusCode == 201) {
        print('Upload successful: ${response.data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hotel Registered Successfully"),
            backgroundColor: Colors.green,
          ),
        );
        clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetupComplete()),
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
        String r = response.data.toString();
        log('Response data for 400 error: ${response.data}');
        print(response.data['status']);
        print('Error data: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fill all the fields correctly"),
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
          content: Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
        ),
      );
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
    return Scaffold(
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
    );
  }
}
