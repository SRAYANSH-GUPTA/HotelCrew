import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class PageFour extends StatefulWidget {
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  final TextEditingController cnumberController = TextEditingController();
  final TextEditingController enumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController addressController = TextEditingController(); 
  final TextEditingController parkingCapacityController = TextEditingController();
 final TextEditingController paymentController = TextEditingController();
  final List<String> paymentMethods = ['Cash', 'Debit Card', 'Credit Card', 'Digital Card'];
  final FocusNode cnumberFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode(); 
  final FocusNode addressFocusNode = FocusNode(); 
  final FocusNode parkingCapacityFocusNode = FocusNode();
  final List<String> roomTypes = ['Deluxe', 'Suites', 'Standard', 'Economy'];
  final Map<String, TextEditingController> priceControllers = {}; // Added focus node for parking capacity
bool _showClock = false; 
  String? _selectedAvailability; 
  
 void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: SingleChildScrollView(
            child: ListBody(
              children: paymentMethods.map((method) {
                return ListTile(
                  title: Text(method),
                  onTap: () {
                    paymentController.text = method; // Set the selected payment method
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


 void _showRoomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Room Types and Prices'),
          content: SingleChildScrollView(
            child: Column(
              children: roomTypes.map((roomType) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(roomType), // Room Type
                    ),
                    SizedBox(width: 8), // Space between text and text field
                    Container(
                      width: 80, // Fixed width for price text field
                      child: TextField(
                        controller: priceControllers[roomType],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can do further actions with the prices here if needed
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    for (String roomType in roomTypes) {
      priceControllers[roomType] = TextEditingController();
    }
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
    parkingCapacityFocusNode.addListener(() => setState(() {})); // Listen to parking capacity focus
  }

  @override
  void dispose() {
    for (TextEditingController controller in priceControllers.values) {
      controller.dispose();
    }
    cnumberController.dispose();
    enumberController.dispose();
    paymentController.dispose(); 
    emailController.dispose();
    addressController.dispose();
    parkingCapacityController.dispose(); // Dispose of the parking capacity controller
    cnumberFocusNode.dispose();
    enumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    parkingCapacityFocusNode.dispose(); // Dispose of the parking capacity focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Container(
        height: 392,
        width: 328,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Primary Contact Number
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: cnumberController, // Check-in time controller
                    focusNode: cnumberFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Check-in Time',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: cnumberFocusNode.hasFocus 
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/clock.svg', // Path to your clock icon
                                height: 24,
                                width: 24,
                              ),
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                ).then((time) {
                                  if (time != null) {
                                    final timeString = DateFormat("HH:mm").format(DateTimeField.convert(time)!);
                                    cnumberController.text = timeString; // Store the selected time in the text box
                                  }
                                });
                              },
                            )
                          : null,
                    ),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFF4D5962),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Emergency Contact Number
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: enumberController, // Check-out time controller
                    focusNode: enumberFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Check-Out Time',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: enumberFocusNode.hasFocus 
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/clock.svg', // Path to your clock icon
                                height: 24,
                                width: 24,
                              ),
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                ).then((time) {
                                  if (time != null) {
                                    final timeString = DateFormat("HH:mm").format(DateTimeField.convert(time)!);
                                    enumberController.text = timeString; // Store the selected time in the text box
                                  }
                                });
                              },
                            )
                          : null,
                    ),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFF4D5962),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // Email TextFormField
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
              controller: paymentController,
              readOnly: true, // Make it read-only to avoid keyboard popping up
              decoration: InputDecoration(
                labelText: 'Payment Method',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down), // Dropdown arrow
              ),
              onTap: _showPaymentDialog, // Show dialog on tap
            ),
                ),
              ),
              SizedBox(height: 8),

              // Complete Address TextFormField
              Column(
                children: [
                  // Dropdown for Availability
                  Container(
                    height: 86,
                    width: 328,
                    padding: const EdgeInsets.only(top: 8, bottom: 22),
                    child: TextFormField(
              readOnly: true, // Make it read-only to avoid keyboard popping up
              decoration: InputDecoration(
                labelText: 'Price Of Each Room',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down), // Dropdown arrow
              ),
              onTap: _showRoomDialog, // Show dialog on tap
            ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Clock24Example extends StatelessWidget {
  final Function(String) onTimeSelected; // Callback for selected time

  Clock24Example({required this.onTimeSelected}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('24 hour clock'),
        // No button, just the DateTimeField to select time
        DateTimeField(
          format: DateFormat("HH:mm"),
          onShowPicker: (context, currentValue) async {
            // Show the time picker directly
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              builder: (context, child) =>
                  MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
            );
            if (time != null) {
              final timeString = DateFormat("HH:mm").format(DateTimeField.convert(time)!);
              onTimeSelected(timeString); // Pass the selected time back
            }
            return DateTimeField.convert(time);
          },
        ),
      ],
    );
  }
}