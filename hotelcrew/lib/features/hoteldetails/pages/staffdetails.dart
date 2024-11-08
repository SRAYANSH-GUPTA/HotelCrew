import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/features/hoteldetails/pages/setupcomplete.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
class Staffdetails extends StatefulWidget {
  const Staffdetails({super.key});

  @override
  State<Staffdetails> createState() => _StaffdetailsState();
}

class _StaffdetailsState extends State<Staffdetails> {
  List<String> uploadedFiles = []; // List to store uploaded file names

bool uploadsuccess = false;
Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null && result.files.isNotEmpty) {
     String? filePath = result.files.single.path;
    String ?fileName = result.files.single.name;
    if (filePath != null) {
      print('File path selected: $filePath');
      print('File name selected: $fileName');

      setState(() {
        uploadedFiles.add(result.files.single.name); // Store file name in the list
      });

      await uploadFile(filePath, fileName);
    } else {
      print('Error: File path is null');
    }
  } else {
    print('No file selected');
  }
}

void clear() async
{
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
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
  final access = prefs.getString('access_token') ?? "";
      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ' + access, // Replace with actual token
      };
      print("here starts");
      dio.options.validateStatus = (status) => true; // Allows all status codes for debugging
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      print("##########");
      print(prefs.getString('userid'));
      FormData formData = FormData.fromMap({
        'user': prefs.getString('userid'),
        'hotel_name': prefs.getString('hotel_name'),
        'legal_business_name': prefs.getString('legal_business_name'),
        'year_established': prefs.getString('year_established'),
        'license_registration_numbers': prefs.getString('license_number'),
        'complete_address': "fbjhsebjh",
        'main_phone_number': prefs.getString('primary_contact'),
        'emergency_phone_number': prefs.getString('emergency_contact'),
        'email_address': prefs.getString('email'),
        'total_number_of_rooms': prefs.getString('numberofrooms'),
        'number_of_floors': prefs.getString('numberoffloors'),
        'valet_parking_available': prefs.getString('availability'),
        'valet_parking_capacity': prefs.getString('parkingCapacity'),
        'check_in_time': (prefs.getString('checkin_time') ?? "00:00") + ":00",
        'check_out_time': (prefs.getString('checkout_time') ?? "00:00") + ":00",

        'payment_methods': prefs.getString('payment_method'),
        'room_price': '150.00',
        'number_of_departments': prefs.getString('numberOfDepartments'),
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
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Hotel Registered Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            uploadsuccess = true;
          });
          clear();
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SetupComplete()),
          );//response.statusCode == 400
      } else if (response.statusCode == 401) {
        print('Unauthorized: ${response.data}');
        log('Response data for 401 error: ${response.data}');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Not Found or file data already exist"),
              backgroundColor: Colors.red,
            ),
          );
         
      } 
      else if (response.statusCode == 400) {
        print('Unauthorized: ${response.data}');
        log('Response data for 400 error: ${response.data}');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Users In file Already Exist"),
              backgroundColor: Colors.red,
            ),
          );
         
      }
       else if (response.statusCode == 500) {
        print('Unauthorized: ${response.data}');
        log('Response data for 500 error: ${response.data}');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Server Error"),
              backgroundColor: Colors.red,
            ),
          );
         
      }
      else {
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
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 44),
            height: 158,
            width: screenWidth,
          
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: screenWidth * 0.2,
                      margin: EdgeInsets.only(left: screenWidth * 0.0444),
                      child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                        
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 14),
                            child: Container(
                              height: 16,
                              // width: screenWidth * 0.23,
                              child: SvgPicture.asset('assets/backarrow.svg'),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.023),
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
                  ),
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
  padding: EdgeInsets.only(top: 0),
  child: uploadedFiles.isEmpty
      ? Padding(
         padding: EdgeInsets.only(top: 38),
        child: Center(
            child: SvgPicture.asset(
              'assets/cuate.svg',
              width: screenWidth * 0.815,
              height: screenWidth * 0.771,
            ),
          ),
      )
      : Container(
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

          const SizedBox(height: 34.2),
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
                children: [Container(width: screenWidth * 0.038,),
                  SvgPicture.asset('assets/add.svg'),
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
          const SizedBox(height: 86),
          Container(
            width:screenWidth * 0.9,
            height:40,
            child: ElevatedButton(
              onPressed: () async {
                if (uploadedFiles.isNotEmpty) {
                  if(uploadsuccess){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupComplete()),
                  );}
                  else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Changes Not Done"),
              backgroundColor: Colors.red,
            ),
          );
                  }
                } else {
                  print('No file selected for upload.');
                  ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Upload file first"),
              backgroundColor: Colors.red,
            ),
          );
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
