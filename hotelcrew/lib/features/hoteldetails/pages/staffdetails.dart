import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

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
    // Add the selected file to the list
    setState(() {
      uploadedFiles.add(result.files.single.name); // Store file name
      // You can handle the upload logic here as well
    });
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
            margin: EdgeInsets.only(top: 44),
            height: 158,
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14, left: 16),
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
                    SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.only(top: 14, left: 0),
                      child: Container(
                        width: 50,
                        height: 24,
                        child: Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
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
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  height: 32,
                  width: 328,
                  child: Text(
                    'Upload Staff Details',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Color(0xFF121212),
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 11),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  height: 42,
                  width: 328,
                  child: Text(
                    'Upload an Excel file with staff names, emails, and departments for easy team management.',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Color(0xFF4D5962),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  color: Color(0xFF4D5962),
                  height: 1,
                  width: 360,
                ),
              ],
            ),
          ),
          // Display the list of uploaded files or an SVG if empty
          Expanded(
            child: uploadedFiles.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                'assets/cuate.svg', // Your empty state SVG file
                      width: 100, // Set width or height as needed
                      height: 100,
                    ),
                  )
                : ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(uploadedFiles[index]),
                        trailing: IconButton(
                          icon: SvgPicture.asset('assets/remove.svg'),
                          onPressed: () => _deleteFile(index), // Delete file on press
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 20), // Additional spacing
          Container(
            margin: EdgeInsets.only(left: 113, right: 113),
            decoration: BoxDecoration(
              color: Color(0xFFD2E0F3),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 134,
            height: 40,
            child: TextButton(
              onPressed: _pickFile, // Call the file picker on button press
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.only(top: 11, left: 16),
                    height: 18,
                    width: 18,
                    child: SvgPicture.asset('assets/add.svg'), // Fixed asset path
                  ),
                  SizedBox(width: 7),
                  Container(
                    width: 69,
                    height: 20,
                    child: Text(
                      "Add a file",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Color(0xFF47518C2),
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
          SizedBox(height: 20), // Additional spacing
        ],
      ),
    );
  }
}
