import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';

class Staffdetails extends StatefulWidget {
  const Staffdetails({super.key});

  @override
  State<Staffdetails> createState() => _StaffdetailsState();
}

class _StaffdetailsState extends State<Staffdetails> {
  List<String> uploadedFiles = []; // List to store uploaded file names

  Future<void> _pickFile() async {
    // Open the file picker with specific type
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Use custom file type
      allowedExtensions: ['xlsx'], // Only allow .xlsx files
    );

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      print('File picked: $fileName at path: $filePath'); // Log the file path and name

      setState(() {
        uploadedFiles.add(fileName); // Store file name in the list
      });

      // Call the upload function with filePath and fileName
      await uploadFile(filePath, fileName);
    } else {
      print('No file selected');
    }
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    try {
      print('File picked: $fileName at path: $filePath');
      if (!File(filePath).existsSync()) {
        print('Error: File does not exist at path: $filePath');
      } else {
        print('File exists, proceeding with upload');
      }

      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzMzNDMwOTA5LCJpYXQiOjE3MzA4Mzg5MDksImp0aSI6IjNlZjk2ZDkxZDA2YjRlMDk4MzJhNDEzM2NmODEyOWQ4IiwidXNlcl9pZCI6M30.uzNMDD7QfazmUpTyyqcZa6tcH5VrQiMlSPrgBWIrQnQ', // Replace with actual token
      };

      // Create FormData for file upload
      FormData formData = FormData.fromMap({
        'user': '7',
        'hotel_name': 'Example Hotel',
        'legal_business_name': 'Example Business',
        'year_established': '1999',
        'license_registration_numbers': '1234-5678',
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

      // Make the POST request
      Response response = await dio.post(
        'https://hotelcrew.onrender.com/api/hoteldetails/register/',
        data: formData,
      );

      // Check the response status code and log the message
      if (response.statusCode == 201) {
        print('Upload successful: ${response.data['message']}');
      } else {
        print('Upload failed with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
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
            child: InkWell(
              onTap: () => {
                Navigator.pop(context),
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14, left: 16),
                        child: Container(
                          height: 16,
                          width: 8,
                          child: SvgPicture.asset(
                            'assets/backarrow.svg',
                            width: 6.32,
                            height: 11.31,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 14, left: 0),
                        child: Container(
                          width: 50,
                          height: 24,
                          child: Text(
                            'Back',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF4D5962),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    height: 32,
                    width: 328,
                    child: Text(
                      'Upload Staff Details',
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
                  const SizedBox(height: 11),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    height: 42,
                    width: 328,
                    child: Text(
                      'Upload an Excel file with staff names, emails, and departments for easy team management.',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xFF4D5962),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                        ),
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
          ),
          Expanded(
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
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD2E0F3),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 134,
            height: 40,
            child: TextButton(
              onPressed: _pickFile,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 18,
                    width: 18,
                    child: SvgPicture.asset('assets/add.svg'),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 69,
                    height: 20,
                    child: Text(
                      "Add a file",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xFF47518C),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (uploadedFiles.isNotEmpty) {
                // Get the file path if needed
                String fileName = uploadedFiles.first; // Use the first file name as an example
                uploadFile(fileName, fileName); // Upload file when Submit is clicked
              } else {
                print('No file selected for upload.');
              }

              // After uploading the file, navigate to SetupComplete screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SetupComplete(),
                ),
              );
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
              backgroundColor: const Color(0xFF47518C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
