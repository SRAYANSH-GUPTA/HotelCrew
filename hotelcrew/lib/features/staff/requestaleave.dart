import 'package:intl/intl.dart';
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
  final FocusNode dateFromFocusNode = FocusNode();
  final FocusNode dateToFocusNode = FocusNode();
  final FocusNode reasonFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  final bool _isLoading = false;

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

    // Show the global loader
    context.loaderOverlay.show();

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
          'leave_type': reason,
          'reason': description,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave request submitted successfully')),
        );
        context.loaderOverlay.hide();
      Navigator.pop(context);
        // GlobalNotification.showSuccessMessage("Task Updated Successfully!!");
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
    } finally {
      // Hide the loader
      context.loaderOverlay.hide();
    
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GlobalLoaderOverlay(
      child: Scaffold(
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildTextField('Reason for Leave', reasonController, reasonFocusNode),
                const SizedBox(height: 34),
                _buildDateField('Date From', dateFromController, dateFromFocusNode),
                const SizedBox(height: 34),
                _buildDateField('Date To', dateToController, dateToFocusNode),
                const SizedBox(height: 34),
                _buildTextField('Description', descriptionController, descriptionFocusNode, maxLines: 4),
                SizedBox(height: screenHeight * 0.2),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed:  _submitLeaveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.primary700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Color(0xFFFAFAFA)),
                          )
                        : Text(
                            'Request Leave',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16), // Adjusted spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode focusNode, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.neutral700,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.primary700,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder( // Add this to handle focus with error
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
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
        suffixIcon: focusNode.hasFocus && controller.text.isNotEmpty
            ? IconButton(
                icon: SvgPicture.asset(
                  'assets/removeline.svg',
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  controller.clear();
                },
              )
            : null,
      ),
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Pallete.neutral950,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
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
        suffixIcon: focusNode.hasFocus
            ? Icon(Icons.calendar_today, color: Colors.grey.shade600)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.neutral700,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.primary700,
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
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Pallete.neutral950,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }
}