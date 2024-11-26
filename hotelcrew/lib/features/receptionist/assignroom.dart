import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/packages.dart';

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

  // Placeholder bottom sheets
 Future<void> _selectStatus() async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    isScrollControlled: true, // Ensures proper behavior for smaller height
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
            // Title Row
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

            // Status Options
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
    isScrollControlled: true, // Ensures height adjusts based on content
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
            // Title Row
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

            // Room Type Options
            ...['Single', 'Double', 'Suite'].map((roomOption) {
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
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Scaffold(
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
          // Expanded list view for scrolling content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 32,),
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
                    _buildTextField('Check-Out', checkOutController),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: SizedBox(
              width: screenWidth * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                  }
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
            ),
          ),
        ],
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
            color: Colors.indigo,
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

  Widget _buildBottomSheetField(String label, String? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: value == null ? Colors.grey.shade400 : Colors.indigo,
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
                color: value == null ? Colors.grey.shade600 : Colors.black,
              ),
            ),
            // Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
