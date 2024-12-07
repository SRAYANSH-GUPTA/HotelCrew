import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../../../core/packages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class PageFour extends StatefulWidget {
  const PageFour({super.key});

  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  final TextEditingController checkintimeController = TextEditingController();
  final TextEditingController checkouttimeController = TextEditingController();
  final TextEditingController parkingCapacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final List<String> paymentMethods = ['Cash', 'Debit Card', 'Credit Card', 'Digital Card'];
  final FocusNode cnumberFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();
  final FocusNode parkingCapacityFocusNode = FocusNode();
  final List<String> roomTypes = ['Deluxe', 'Suites', 'Standard', 'Economy'];
  final Map<String, TextEditingController> priceControllers = {};
  final bool _showClock = false;
  String? _selectedAvailability;

  @override
  void initState() {
    super.initState();
    for (String roomType in roomTypes) {
      priceControllers[roomType] = TextEditingController();
    }
    _loadData(); // Load saved data when the page is initialized
    cnumberFocusNode.addListener(() => setState(() {}));
    priceFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    parkingCapacityFocusNode.addListener(() => setState(() {}));

    // Add listeners to save data as it changes
    checkintimeController.addListener(() => _saveData('checkin_time', checkintimeController.text));
    checkouttimeController.addListener(() => _saveData('checkout_time', checkouttimeController.text));
    paymentController.addListener(() => _saveData('payment_method', paymentController.text));
    parkingCapacityController.addListener(() => _saveData('parking_capacity', parkingCapacityController.text));
    priceController.addListener(() => _saveData('price', priceController.text));

    // Add listeners for room prices
    for (String roomType in roomTypes) {
      priceControllers[roomType]?.addListener(() {
        _saveData('price_$roomType', priceControllers[roomType]?.text ?? '');
      });
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in priceControllers.values) {
      controller.dispose();
    }
    checkintimeController.dispose();
    checkouttimeController.dispose();
    paymentController.dispose();
    parkingCapacityController.dispose();
    cnumberFocusNode.dispose();
    priceFocusNode.dispose();
    enumberFocusNode.dispose();
    parkingCapacityFocusNode.dispose();
    super.dispose();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkintimeController.text = prefs.getString('checkin_time') ?? '';
      checkouttimeController.text = prefs.getString('checkout_time') ?? '';
      paymentController.text = prefs.getString('payment_method') ?? '';
      parkingCapacityController.text = prefs.getString('parking_capacity') ?? '';
      priceController.text = prefs.getString('price') ?? '';

      // Load price controllers for room types
      for (var roomType in roomTypes) {
        priceControllers[roomType]?.text = prefs.getString('price_$roomType') ?? '';
      }
    });
  }

  // Method to save data to SharedPreferences
  Future<void> _saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showTimePicker(TextEditingController controller) {
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
        controller.text = timeString; // Store the selected time in the text box
      }
    });
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
              // Check-in Time
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: checkintimeController, // Check-in time controller
                    focusNode: cnumberFocusNode,
                    readOnly: true, // Make it read-only to avoid keyboard popping up
                    decoration: InputDecoration(
                      labelText: 'Check-in Time',
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
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          'assets/clock.svg', // Path to your clock icon
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          _showTimePicker(checkintimeController);
                        },
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
                    onTap: () {
                      _showTimePicker(checkintimeController);
                    },
                  ),
                ),
              ),

              // Check-out Time
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: checkouttimeController, // Check-out time controller
                    focusNode: enumberFocusNode,
                    readOnly: true, // Make it read-only to avoid keyboard popping up
                    decoration: InputDecoration(
                      labelText: 'Check-Out Time',
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
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          'assets/clock.svg', // Path to your clock icon
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          _showTimePicker(checkouttimeController);
                        },
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
                    onTap: () {
                      _showTimePicker(checkouttimeController);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Payment Method
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: paymentController,
                    readOnly: true, // Make it read-only to avoid keyboard popping up
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.primary700),
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down), // Dropdown arrow
                    ),
                    onTap: _showPaymentDialog, // Show dialog on tap
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Price Of Each Room
              // SizedBox(
              //   height: 86,
              //   width: screenWidth * 0.9,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 8, bottom: 22),
              //     child: TextFormField(
              //       controller: priceController,
              //       focusNode: priceFocusNode,
              //       keyboardType: TextInputType.number,
              //       inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
              //       decoration: InputDecoration(
              //         labelText: 'Price Of Each Room',
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8.0),
              //           borderSide: const BorderSide(
              //             color: Pallete.neutral700,
              //             width: 1.0,
              //           ),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8.0),
              //           borderSide: const BorderSide(
              //             color: Pallete.primary700,
              //             width: 2.0,
              //           ),
              //         ),
              //       ),
              //       style: GoogleFonts.montserrat(
              //         textStyle: const TextStyle(
              //           color: Pallete.neutral950,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 16,
              //           height: 1.5,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}