import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'dart:developer';

class Staffdetails extends StatefulWidget {
  const Staffdetails({super.key});

  @override
  State<Staffdetails> createState() => _StaffdetailsState();
}

class _StaffdetailsState extends State<Staffdetails> {
  List<String> uploadedFiles = []; // List to store uploaded file names

Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null && result.files.isNotEmpty) {
    String? filePath = result.files.single.path;
    String fileName = result.files.single.name;

    if (filePath != null) {
      log('File path selected: $filePath');
      log('File name selected: $fileName');

      setState(() {
        uploadedFiles.add(fileName); // Store file name in the list
      });

      await uploadFile(filePath, fileName);
    } else {
      print('Error: File path is null');
    }
  } else {
    print('No file selected');
  }
}

  Future<void> uploadFile(String filePath, String fileName) async {
    try {
      log('Uploading file: $fileName at path: $filePath');

      final file = File(filePath);
      if (!file.existsSync()) {
        print('Error: File does not exist at path: $filePath');
        return;
      }

      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzMzNTEzNjI4LCJpYXQiOjE3MzA5MjE2MjgsImp0aSI6Ijk4YjNlOWIwNjAwYzQzZDNiMWMyOTVkOGFjYzAyMGVmIiwidXNlcl9pZCI6NX0.9u5z8h2ilJgUs1HWoyyFwf5Z5f77xSmmdetQFfiGHTo', // Replace with actual token
      };
      dio.options.validateStatus = (status) => true; // Allows all status codes for debugging

      FormData formData = FormData.fromMap({
        'user': '5',
        'hotel_name': 'Example Hotel',
        'legal_business_name': 'Example Business',
        'year_established': '1999',
        'license_registration_numbers': '12345678',
        'complete_address': '123 Example St, City, Country',
        'main_phone_number': '1234567890',
        'emergency_phone_number': '0987654321',
        'email_address': 'hotel@gmail.com',
        'total_number_of_rooms': '120',
        'number_of_floors': '5',
        'valet_parking_available': 'True',
        'valet_parking_capacity': '20',
        'check_in_time': '14:00:00',
        'check_out_time': '12:00:00',
        'payment_methods': 'Cash, Credit Card',
        'room_price': '150.00',
        'number_of_departments': '5',
        'department_names': 'Reception, Housekeeping, Maintenance, Kitchen, Security',
        'staff_excel_sheet': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      Response response = await dio.post(
        'https://hotelcrew-1.onrender.com/api/hoteldetails/register/',
        data: formData,
      );
     dio.options.validateStatus = (status) => true; // Allows all responses through for debugging

      if (response.statusCode == 201) {
        print('Upload successful: ${response.data['message']}');
      } else if (response.statusCode == 401) {
        print('Unauthorized: ${response.data}');
        log('Response data for 401 error: ${response.data}');
      } else {
        print('Upload failed with status code: ${response.statusCode}');
        log('Error data: ${response.data}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  void _deleteFile(int index) {
    setState(() {
      uploadedFiles.removeAt(index); // Remove file from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 44),
            height: 158,
            width: 360,
          
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14, left: 16),
                          child: Container(
                            height: 16,
                            width: 8,
                            child: SvgPicture.asset('assets/backarrow.svg'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            'Back',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF4D5962),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
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
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Upload an Excel file with staff names, emails, and departments for easy team management.',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF4D5962),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: const Color(0xFFC6D6DB),
                    height: 1,
                    width: 360,
                  ),
                ],
              ),
            
          ),
          Padding(
            padding: EdgeInsets.only(top: 38),
            child: Expanded(
              
              child: uploadedFiles.isEmpty
                  ? Center(
                      child: SvgPicture.asset(
                        'assets/cuate.svg',
                        width: 295.27,
                        height: 277.8,
                      ),
                    )
                  : ListView.builder(
                      itemCount: uploadedFiles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
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
          const SizedBox(height: 34.2),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD2E0F3),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 134,
            height: 40,
            child: TextButton(
              onPressed: _pickFile,
              child: Row(
                children: [
                  SvgPicture.asset('assets/add.svg'),
                  const SizedBox(width: 7),
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
          const SizedBox(height: 86),
          Container(
            width:331,
            height:40,
            child: ElevatedButton(
              onPressed: () async {
                if (uploadedFiles.isNotEmpty) {
                  String fileName = uploadedFiles.first;
                  await uploadFile(fileName, fileName);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupComplete()),
                  );
                } else {
                  print('No file selected for upload.');
                }
              },
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
