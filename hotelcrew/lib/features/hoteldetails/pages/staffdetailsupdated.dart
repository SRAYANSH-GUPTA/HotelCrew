import 'dart:io';
// Import for ByteData
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching files

class Staffdetailsupdated extends StatefulWidget {
  const Staffdetailsupdated({super.key});

  @override
  State<Staffdetailsupdated> createState() => _StaffdetailsupdatedState();
}

class _StaffdetailsupdatedState extends State<Staffdetailsupdated> {
  List<String> uploadedFiles = []; // List to store uploaded file names

  bool uploadsuccess = false;

  @override
  void initState() {
    super.initState();
    _loadSavedFile(); // Load saved file information from SharedPreferences
  }

  Future<void> _loadSavedFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fileName = prefs.getString('filename');
    if (fileName != null && fileName.isNotEmpty) {
      setState(() {
        uploadedFiles.add(fileName);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      print(filePath);
      print("&" * 100);
      String? fileName = result.files.single.name;
      if (filePath != null) {
        print('File path selected: $filePath');
        print('File name selected: $fileName');

        setState(() {
          uploadedFiles.add(fileName);
           // Store file name in the list
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('filepath', filePath);
        print("*" * 100);
        print(prefs.getString("filepath"));
        prefs.setString('filename', fileName);
        prefs.setString('fileupload', "1");
      } else {
        print('Error: File path is null');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('fileupload', "0");
      }
    } else {
      print('No file selected');
    }
  }

  Future<void> _launchFile() async {
    const url = 'https://example.com/format.xlsx'; // Replace with your URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

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

  Future<void> uploadFile(String filePath, String fileName) async {
    try {
      log('Uploading file: $fileName at path: $filePath');

      final file = File(filePath);
      if (!file.existsSync()) {
        print('Error: File does not exist at path: $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File does not exist at the specified path."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? "";

      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $accessToken',
      };
      dio.options.validateStatus = (status) => true; // Allows all responses for debugging

      FormData formData = FormData.fromMap({
        'user': prefs.getString('userid'),
        'hotel_name': prefs.getString('hotel_name'),
        'legal_business_name': prefs.getString('legal_business_name'),
        'year_established': prefs.getString('year_established'),
        'license_registration_numbers': prefs.getString('license_number'),
        'complete_address': prefs.getString('address'),
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
        'number_of_departments': prefs.getString('numberOfDepartments'),
        'department_names': 'Reception, Housekeeping, Maintenance, Kitchen, Security',
        'staff_excel_sheet': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      Response response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/hoteldetails/register/',
        data: formData,
      );
      print("response: ${response.data}");

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
            content: Text(response.data['message'] ?? "Unauthorized. Check your credentials."),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.data}');
        log('Response data for 400 error: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? "All Fields are necessary"),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An unexpected error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteFile(int index) async {
    setState(() {
      uploadedFiles.removeAt(index); // Remove file from the list
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('filepath');
    prefs.remove('filename');
    prefs.remove('fileaddress');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            // margin: const EdgeInsets.only(top: 44),
            // height: 158,
            // width: screenWidth,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   margin: EdgeInsets.only(left: screenWidth * 0.044),
                //   child: Text(
                //     'Upload an Excel file with staff names, emails, and departments for easy team management.',
                //     style: GoogleFonts.montserrat(
                //       color: const Color(0xFF4D5962),
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Container(
                //   color: const Color(0xFFC6D6DB),
                //   height: 1,
                //   width: screenWidth,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          if (uploadedFiles.isEmpty)
            Container(
              margin: EdgeInsets.only(left: screenWidth * 0.044),
              child: Text(
                'Upload an Excel file with staff names, emails, salary and departments for easy team management.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF4D5962),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          if (uploadedFiles.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SVG image
                  SvgPicture.asset(
                    'assets/pdficon.svg',
                    width: 20,
                    height: 20,
                  ),

                  // Space between SVG and link
                  const SizedBox(width: 9),

                  // Link to open the Excel file
                  TextButton(
                    onPressed: _launchFile,
                    child: const Text('Click here to see the format.'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: uploadedFiles.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 38),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/staffdetails.svg',
                        width: screenWidth * 0.5263,
                        height: screenWidth * 0.587,
                      ),
                    ),
                  )
                : SizedBox(
                    width: screenWidth,
                    height: screenWidth * 1.2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ListView.builder(
                        itemCount: uploadedFiles.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SvgPicture.asset(
                              'assets/tick.svg',
                              width: 20,
                              height: 20,
                            ),
                            title: Text(uploadedFiles[index]),
                            trailing: IconButton(
                              icon: SvgPicture.asset('assets/remove.svg'),
                              onPressed: () async {
                                _deleteFile(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          !uploadedFiles.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 34.2), // Display space when files are not empty
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2E0F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: screenWidth * 0.37,
                      height: 40,
                      child: TextButton(
                        onPressed: _pickFile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the row horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, // Centers the row vertically
                          children: [
                            SvgPicture.asset(
                              'assets/add.svg',
                              width: 18, // Adjust size of the SVG as needed
                              height: 18, // Adjust size of the SVG as needed
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "Add a file",
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF47518C),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(), // Empty container if uploadedFiles is empty
        ],
      ),
    );
  }
}