import '../../core/packages.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AssignRoomPage extends StatefulWidget {
  const AssignRoomPage({super.key});

  @override
  _AssignRoomPageState createState() => _AssignRoomPageState();
}

class _AssignRoomPageState extends State<AssignRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  String? status;
  String? roomType;

List<String> room = [];


void fetchRoomTypes() async {
  try {
    // Get the access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('Access token not found.');
    }

    // API endpoint
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/hoteldetails/room/details/';

    // Make the GET request
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    // Check response status
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract room names from the API response
      if (data['status'] == 'success') {
        final roomList = data['data'] as List;
        print("^"*100);
        print(roomList);
        print(roomList.map<String>((room) => room['room_type'] as String).toList());
        setState(() {
          room = roomList.map<String>((room) => room['room_type'] as String).toList();
        });
      } else {
        throw Exception('Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch room details. Status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
    
  }
}



  final Dio _dio = Dio();

  Future<void> _selectStatus() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ...['VIP', 'Regular'].map((statusOption) {
                return ListTile(
                  title: Text(
                    statusOption,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      status = statusOption;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectRoomType() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room Type',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ...room
              .map((roomOption) {
                return ListTile(
                  title: Text(
                    roomOption,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      roomType = roomOption;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

 @override
  void initState() {
    super.initState();
    fetchRoomTypes();
  }




  Future<void> _selectCheckOutDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final String formattedDateTime =
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(finalDateTime);

        setState(() {
          checkOutController.text = formattedDateTime;
        });
      }
    }
  }

 

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
String access_token = "";
  Future<void> _assignRoom() async {
    await getToken();
  if (_formKey.currentState!.validate()) {
    await getToken(); // Wait for the token to be retrieved
  if (access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }
      final String name = nameController.text;
      final String email = emailController.text;
      final String contact = contactController.text;
      final String checkOut = checkOutController.text;

    try {
      final response = await http.post(
        Uri.parse('https://hotelcrew-1.onrender.com/api/hoteldetails/book/'),
        headers: {
          'Authorization':
              'Bearer $access_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone_number': contact,
          'status':  status, // Replace with actual status
          'room_type': roomType, // Replace with actual roomType
          'check_out_time': checkOut,
        }),
      );
      print(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room assigned successfully')),
        );
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign room: ${responseData['message']}')),
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
    return GlobalLoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
          ),
          titleSpacing: 0,
          title: Text(
            'Assign Room',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral1000,
              ),
            ),
          ),
          backgroundColor: Pallete.pagecolor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 32),
                        _buildTextField('Name', nameController),
                        const SizedBox(height: 30),
                        _buildTextField('Email', emailController),
                        const SizedBox(height: 30),
                        _buildBottomSheetField('Status', status, _selectStatus),
                        const SizedBox(height: 30),
                        _buildTextField('Contact', contactController),
                        const SizedBox(height: 30),
                        _buildBottomSheetField('Room Type', roomType, _selectRoomType),
                        const SizedBox(height: 30),
                        _buildCheckOutField('Check-Out', checkOutController, _selectCheckOutDateTime),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: MediaQuery.of(context).viewInsets.bottom == 0 // Check if the keyboard is hidden
        ? SizedBox(
            width: screenWidth * 0.9,
            child: ElevatedButton(
              onPressed:() async{ 
                context.loaderOverlay.show();
                await _assignRoom();
                context.loaderOverlay.hide();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.primary800,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Assign Room',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral00,
                ),
              ),
            ),
          )
        : const SizedBox(), // Hide the button when the keyboard is visible
      ),
      
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
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
            color: Pallete.primary800,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.error700,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetField(String label, String? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: value == null ? Pallete.neutral700 : Pallete.neutral700,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value == null ? Pallete.neutral950 : Pallete.neutral950,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckOutField(String label, TextEditingController controller, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.access_time, color: Colors.grey.shade600),
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
            color: Colors.indigo,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Pallete.error700,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
