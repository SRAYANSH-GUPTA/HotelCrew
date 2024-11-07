import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  final TextEditingController numberofroomsController = TextEditingController();
  final TextEditingController typesofroomController = TextEditingController();
  final TextEditingController numberoffloorsController = TextEditingController(); 
  final TextEditingController addressController = TextEditingController(); 
  final TextEditingController parkingCapacityController = TextEditingController();
  bool parking = false;
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
    _loadSavedData();  // Load data from SharedPreferences
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
    parkingCapacityFocusNode.addListener(() => setState(() {})); 
  }
void _loadSavedData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  setState(() {
    numberofroomsController.text = prefs.getString('numberofrooms') ?? '';
    typesofroomController.text = prefs.getString('typesofroom') ?? '';
    numberoffloorsController.text = prefs.getString('numberoffloors') ?? '';
    addressController.text = prefs.getString('address') ?? '';
    parkingCapacityController.text = prefs.getString('parkingCapacity') ?? '';

    // Retrieve availability as "True" or "False" and set the availability state accordingly
    String? availability = prefs.getString('availability') ?? 'False';
    if (availability == 'True') {
      _selectedAvailability = 'Available';
      parking = true;
    } else {
      _selectedAvailability = 'Not Available';
      parking = false;
    }
  });
}

   @override
  void dispose() {
    _saveData();  // Save data to SharedPreferences
    numberofroomsController.dispose();
    typesofroomController.dispose();
    numberoffloorsController.dispose();
    addressController.dispose();
    parkingCapacityController.dispose(); 
    cnumberFocusNode.dispose();
    enumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    parkingCapacityFocusNode.dispose(); 
    super.dispose();
  }

  // Save the data to SharedPreferences
  void _saveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('numberofrooms', numberofroomsController.text);
  prefs.setString('typesofroom', typesofroomController.text);
  prefs.setString('numberoffloors', numberoffloorsController.text);
  prefs.setString('address', addressController.text);
  prefs.setString('parkingCapacity', parkingCapacityController.text);

  // Save availability as "True" or "False" based on the parking state
  prefs.setString('availability', parking ? "True" : "False");
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
                    controller: typesofroomController,
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
                                  int currentValue = int.tryParse(typesofroomController.text) ?? 0;
                                  typesofroomController.text = (currentValue + 1).toString();
                                  typesofroomController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: typesofroomController.text.length),
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
                                    typesofroomController.text = (currentValue - 1).toString();
                                    typesofroomController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: typesofroomController.text.length),
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
                    controller: numberoffloorsController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Number Of Floors',
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
                                  int currentValue = int.tryParse(numberoffloorsController.text) ?? 0;
                                  numberoffloorsController.text = (currentValue + 1).toString();
                                  numberoffloorsController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: numberoffloorsController.text.length),
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
                                  int currentValue = int.tryParse(numberoffloorsController.text) ?? 0;
                                  if (currentValue > 0) { // Prevent negative numbers
                                    numberoffloorsController.text = (currentValue - 1).toString();
                                    numberoffloorsController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: numberoffloorsController.text.length),
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
      _selectedAvailability = value;
      parking = value == 'Available'; // Update parking based on selection
      if (!parking) {
        parkingCapacityController.clear(); // Clear parking capacity if not available
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

