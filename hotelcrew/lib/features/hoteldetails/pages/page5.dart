import '../../../core/packages.dart';
import 'package:flutter/services.dart';

class PageThree extends StatefulWidget {
  const PageThree({super.key});

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
  final String _selectedCountryCode = '+1'; // Default selected code

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load data from SharedPreferences
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
    parkingCapacityFocusNode.addListener(() => setState(() {}));

    // Add listener to save parking capacity as it changes
    parkingCapacityController.addListener(() {
      _saveData('parkingCapacity', parkingCapacityController.text);
    });
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
    _saveAllData(); // Save all data to SharedPreferences
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

  // Save a single data field to SharedPreferences
  void _saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Save all data to SharedPreferences
  void _saveAllData() async {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 24, left: screenWidth * 0.045, right: screenWidth * 0.045),
      child: SizedBox(
        height: 392,
        width: screenWidth * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Total Number Of Rooms
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: numberofroomsController,
                    focusNode: cnumberFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 5, // Set max length to 5
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
                    decoration: InputDecoration(
                      labelText: 'Total Number Of Rooms',
                      counterText: '', // Remove the max length counter
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
                        color: Pallete.neutral950,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Total Number Of Floors
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: numberoffloorsController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 5, // Set max length to 5
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
                    decoration: InputDecoration(
                      labelText: 'Total Number Of Floors',
                      counterText: '', // Remove the max length counter
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
                        color: Pallete.neutral950,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Complete Address TextFormField
              Column(
                children: [
                  // Dropdown for Availability
                  Container(
                    height: 86,
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.only(top: 8, bottom: 22),
                    child: DropdownButtonFormField<String>(
                      value: _selectedAvailability,
                      hint: const Text('Valet Parking'),
                      items: const [
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
                        labelText: "Valet Parking",
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Parking Capacity TextFormField
                  if (_selectedAvailability == 'Available') // Only show if Available is selected
                    SizedBox(
                      height: 86,
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: parkingCapacityController,
                          focusNode: parkingCapacityFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6, // Set max length to 6
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
                          decoration: InputDecoration(
                            labelText: 'Parking Capacity',
                            counterText: '', // Remove the max length counter
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
                              color: Pallete.neutral950,
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