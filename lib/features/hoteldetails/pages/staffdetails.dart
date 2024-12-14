import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import "../../dashboard/dashborad.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class Staffdetails extends StatefulWidget {
  const Staffdetails({super.key});

  @override
  State<Staffdetails> createState() => _StaffdetailsState();
}

class _StaffdetailsState extends State<Staffdetails> {
  List<String> uploadedFiles = []; // List to store uploaded file names

  @override
  void initState() {
    super.initState();
    _loadSavedFile(); // Load saved file information from SharedPreferences
  }
Future<void> registerDeviceToken(String fcmToken, String authToken) async {
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/auth/register-device-token/';
    
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("^"*100);
        print(data['message']); // Message from the server
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to register device token');
      }
    } catch (e) {
      print('Error registering device token: $e');
      rethrow;
    }
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
      String? fileName = result.files.single.name;
      if (filePath != null) {
        print('File path selected: $filePath');
        print('File name selected: $fileName');
        setState(() {
          fileaddress = filePath;
          filename = fileName;
        });

        setState(() {
          uploadedFiles.clear(); // Clear previous files
          uploadedFiles.add(fileName); // Store file name in the list
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('filepath', filePath);
        prefs.setString('filename', fileName);
        prefs.setString('fileupload', "1");
        print("fkwbfjerfbrejfberjkfbkjerfjkf");
      } else {
        print('Error: File path is null');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('fileupload', "0");
      
      }
    } else {
      print('No file selected');
    }
  }
  String fileaddress = ""?? "";
  String filename = ""?? "";

  Future<void> _uploadFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   
    String? accessToken = prefs.getString('access_token');
    print(accessToken);

    if (fileaddress == "" || filename == "" || accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No file uploaded or access token missing."),
          backgroundColor: Colors.red,
        ),
      );
      context.loaderOverlay.hide(); 
      return;
    }

    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $accessToken',
      };

      FormData formData = FormData.fromMap({
        'staff_excel_sheet': await MultipartFile.fromFile(fileaddress, filename: filename),
      });
      print("^^^^^"* 100);
      Response response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/hoteldetails/excel/', // Replace with your API endpoint
        data: formData,
      );
      print(response.data);
      if (response.statusCode == 201) {
        String access = prefs.getString('access_token') ?? "";
        String fcm = prefs.getString('fcm') ?? "";
         if (fcm.isNotEmpty && access.isNotEmpty) {
                                    registerDeviceToken(fcm, access);
                                    print("Fcm registered successfully");
                                  }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Staff details uploaded successfully."),
            backgroundColor: Colors.green,
          ),
        );
         Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SetupComplete()),
                                      (Route<dynamic> route) => false,
                                    );
      
      } else {
        // _deleteFile(0); // Automatically remove the file if upload fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? "Unexpected error occurred."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      _deleteFile(0); // Automatically remove the file if upload fails
      String errorMessage = "An error occurred";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your network and try again.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server response timeout. Please try again later.";
      } else if (e.type == DioExceptionType.badResponse) {
        print(e.response?.data);
        print("*"*100);
        errorMessage =  e.response?.data['message'] ?? "Failed to upload file";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      _deleteFile(0); // Automatically remove the file if upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      context.loaderOverlay.hide(); // Hide the loader overlay
    }
  }

  void _deleteFile(int index) async {
    setState(() {
      uploadedFiles.removeAt(index); // Remove file from the list
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('filepath');
    prefs.remove('filename');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Pallete.pagecolor,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 44),
              height: 120,
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.044),
                    child: Text(
                      'Upload Staff Details',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.044),
                    child: Text(
                      'Upload an Excel file with staff names, emails, and departments for easy team management.',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF4D5962),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: const Color(0xFFC6D6DB),
                    height: 1,
                    width: screenWidth,
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
                  : Padding(
                      padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                        width: screenWidth,
                        height: screenWidth * 0.777,
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
                                onPressed: () => _deleteFile(index),
                              ),
                            );
                          },
                        ),
                      ),
                  ),
            ),
            const SizedBox(height: 34.2),
            if (uploadedFiles.isEmpty)
            const SizedBox(height: 50,),
            if (uploadedFiles.isEmpty)
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
            const SizedBox(height: 140),
            if (uploadedFiles.isNotEmpty)
            const SizedBox(height: 48,),
            SizedBox(
              width: screenWidth * 0.9,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (uploadedFiles.isNotEmpty) {
                    context.loaderOverlay.show(); // Show the loader overlay
                    _uploadFile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Upload file first"),
                        backgroundColor: Colors.red,
                      ),
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
                  'Submit',
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
      ),
    );
  }
}