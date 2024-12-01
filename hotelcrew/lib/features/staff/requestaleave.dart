import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "../../core/packages.dart";

class RequestALeavePage extends StatefulWidget {
  const RequestALeavePage({super.key});

  @override
  _RequestALeavePageState createState() => _RequestALeavePageState();
}

class _RequestALeavePageState extends State<RequestALeavePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedFile;

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }
  String access_token = "";

  Future<void> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null || token.isEmpty) {
    print('Token is null or empty');
  } else {
    setState(() {
      access_token = token;
    });
    print('Token retrieved: $access_token');
  }
}

  Future<void> _submitLeaveRequest() async {
    await getToken(); // Wait for the token to be retrieved
  if (access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }
    if (_formKey.currentState!.validate()) {
      final String fromDate = dateFromController.text;
      final String toDate = dateToController.text;
      final String reason = reasonController.text;
      final String description = descriptionController.text;

      try {
        final response = await http.post(
          Uri.parse('https://hotelcrew-1.onrender.com/api/attendance/apply_leave/'),
          headers: {
            'Authorization': 'Bearer $access_token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'from_date': fromDate,
            'to_date': toDate,
            'leave_type': description,
            'reason': reason,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Leave request submitted successfully')),
          );
          GlobalNotification.showSuccessMessage("Task Updated Successfully!!");
        } else {
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit leave request: ${responseData['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Pallete.neutral900,
          ),
        ),
        title: Text(
          "Request a Leave",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral1000,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildTextField('Reason for Leave', reasonController),
                    const SizedBox(height: 34),
                    _buildDateField('Date From', dateFromController),
                    const SizedBox(height: 34),
                    _buildDateField('Date To', dateToController),
                    const SizedBox(height: 34),
                    _buildTextField('Description', descriptionController, maxLines: 4),
                    const SizedBox(height: 34),
                    _buildFilePickerField(),
                    SizedBox(height: isKeyboardVisible ? 16 : 34),
                    if (!isKeyboardVisible)
            SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: _submitLeaveRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Assign Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
                  ],
                ),
              ),
            ),
          ),
          
            
        ],
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFilePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attachments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: selectedFile == null ? Colors.grey.shade400 : Colors.blue,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedFile == null ? 'Add files' : selectedFile!.path.split('/').last,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: selectedFile == null ? Colors.grey.shade600 : Colors.black,
                  ),
                ),
                Icon(Icons.attach_file, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
