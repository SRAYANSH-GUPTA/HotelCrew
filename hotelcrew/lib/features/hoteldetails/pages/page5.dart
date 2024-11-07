import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  final TextEditingController numberofroomsController = TextEditingController();
  final TextEditingController enumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController addressController = TextEditingController(); 
  final TextEditingController parkingCapacityController = TextEditingController();

  final FocusNode cnumberFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode(); 
  final FocusNode addressFocusNode = FocusNode(); 
  final FocusNode parkingCapacityFocusNode = FocusNode(); // Added focus node for parking capacity

  String? _selectedAvailability; 
  String _selectedCountryCode = '+1'; // Default selected code

  @override
  void initState() {
    super.initState();
    
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
    parkingCapacityFocusNode.addListener(() => setState(() {})); // Listen to parking capacity focus
  }

  @override
  void dispose() {
    numberofroomsController.dispose();
    enumberController.dispose();
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
                    controller: numberofroomsController,
                    focusNode: cnumberFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Number Of Rooms',
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
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/plus.svg', // Path to your + icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Increase the number
                                  int currentValue = int.tryParse(numberofroomsController.text) ?? 0;
                                  numberofroomsController.text = (currentValue + 1).toString();
                                  numberofroomsController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: numberofroomsController.text.length),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/minus.svg', // Path to your - icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Decrease the number
                                  int currentValue = int.tryParse(numberofroomsController.text) ?? 0;
                                  if (currentValue > 0) { // Prevent negative numbers
                                    numberofroomsController.text = (currentValue - 1).toString();
                                    numberofroomsController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: numberofroomsController.text.length),
                                    );
                                  }
                                },
                              ),
                            ],
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
              SizedBox(height: 16),

              // Emergency Contact Number
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: enumberController,
                    focusNode: enumberFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Types Of Rooms Available',
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
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/plus.svg', // Path to your + icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Increase the number
                                  int currentValue = int.tryParse(enumberController.text) ?? 0;
                                  enumberController.text = (currentValue + 1).toString();
                                  enumberController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: enumberController.text.length),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/minus.svg', // Path to your - icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Decrease the number
                                  int currentValue = int.tryParse(numberofroomsController.text) ?? 0;
                                  if (currentValue > 0) { // Prevent negative numbers
                                    enumberController.text = (currentValue - 1).toString();
                                    enumberController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: enumberController.text.length),
                                    );
                                  }
                                },
                              ),
                            ],
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
                    controller: emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Number Of Rooms',
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
                      suffixIcon: emailFocusNode.hasFocus 
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/plus.svg', // Path to your + icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Increase the number
                                  int currentValue = int.tryParse(emailController.text) ?? 0;
                                  emailController.text = (currentValue + 1).toString();
                                  emailController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: emailController.text.length),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/minus.svg', // Path to your - icon
                                  height: 24,
                                  width: 24,
                                ),
                                onPressed: () {
                                  // Decrease the number
                                  int currentValue = int.tryParse(emailController.text) ?? 0;
                                  if (currentValue > 0) { // Prevent negative numbers
                                    emailController.text = (currentValue - 1).toString();
                                    emailController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: emailController.text.length),
                                    );
                                  }
                                },
                              ),
                            ],
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

              // Complete Address TextFormField
              Column(
                children: [
                  // Dropdown for Availability
                  Container(
                    height: 86,
                    width: 328,
                    padding: const EdgeInsets.only(top: 8, bottom: 22),
                    child: DropdownButtonFormField<String>(
                      value: _selectedAvailability,
                      hint: Text('Select Availability'),
                      items: [
                        DropdownMenuItem(value: 'Available', child: Text('Available')),
                        DropdownMenuItem(value: 'Not Available', child: Text('Not Available')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAvailability = value; // Update the selected availability
                          if (value == 'Available') {
                            // Show Parking Capacity when Available is selected
                          } else {
                            parkingCapacityController.clear(); // Clear parking capacity when Not Available is selected
                          }
                        });
                      },
                      decoration: InputDecoration(
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
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Parking Capacity TextFormField
                  if (_selectedAvailability == 'Available') // Only show if Available is selected
                    Container(
                      height: 86,
                      width: 328,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: parkingCapacityController,
                          focusNode: parkingCapacityFocusNode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Parking Capacity',
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
                            suffixIcon: parkingCapacityFocusNode.hasFocus
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/plus.svg', // Path to your + icon
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {
                                        // Increase the parking capacity
                                        int currentValue = int.tryParse(parkingCapacityController.text) ?? 0;
                                        parkingCapacityController.text = (currentValue + 1).toString();
                                        parkingCapacityController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: parkingCapacityController.text.length),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/minus.svg', // Path to your - icon
                                        height: 24,
                                        width: 24,
                                      ),
                                      onPressed: () {
                                        // Decrease the parking capacity
                                        int currentValue = int.tryParse(parkingCapacityController.text) ?? 0;
                                        if (currentValue > 0) { // Prevent negative numbers
                                          parkingCapacityController.text = (currentValue - 1).toString();
                                          parkingCapacityController.selection = TextSelection.fromPosition(
                                            TextPosition(offset: parkingCapacityController.text.length),
                                          );
                                        }
                                      },
                                    ),
                                  ],
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

