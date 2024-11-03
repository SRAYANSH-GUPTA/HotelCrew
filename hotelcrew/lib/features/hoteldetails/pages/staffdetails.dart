import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
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
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Navigates back to the previous screen
        },
        child: Row(
          children: [
            Container(
              
              height: 24, // Adjusted height to fit the icon better
              width: 24,
              child: SvgPicture.asset(
                'assets/backarrow.svg',
                width: 6.32,
                height: 11.31,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Back',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Color(0xFF4D5962),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
)

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
                  color: Color(0xFFC6D6DB),
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
                      width: 295.27, // Set width or height as needed
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
                          onPressed: () => _deleteFile(index), // Delete file on press
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 20), // Additional spacing
          Container(
            //margin: EdgeInsets.only(left: 113, right: 113),
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
                  //SizedBox(width: 16),
                  Container(
                    margin: EdgeInsets.only(left: 16,top: 11),
                    height: 18,
                    width: 18,
                    child: SvgPicture.asset('assets/add.svg'), // Fixed asset path
                  ),
                  SizedBox(width: 8),
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
          SizedBox(height: 86), // Additional spacing
        
        SizedBox(
                height: 40,
                width: 328,
                child: ElevatedButton(
                  onPressed: () {
                    print("Next!!!!!!!!");
                    Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => SetupComplete(),
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
                    backgroundColor: Color(0xFF47518C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 46,)],
      ),
    );
  }
}
