import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../../../core/packages.dart';
class PageFour extends StatefulWidget {
  const PageFour({super.key});

  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  final TextEditingController checkintimeController = TextEditingController();
  final TextEditingController checkouttimeController = TextEditingController();
 List<Map<String, dynamic>> roomData = [];


  final TextEditingController parkingCapacityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
 final TextEditingController paymentController = TextEditingController();
  final List<String> paymentMethods = ['Cash', 'Debit Card', 'Credit Card', 'Digital Card'];
  final FocusNode cnumberFocusNode = FocusNode();
   final FocusNode priceFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();

  final FocusNode parkingCapacityFocusNode = FocusNode();
  final List<String> roomTypes = ['Deluxe', 'Suites', 'Standard', 'Economy'];
  final Map<String, TextEditingController> priceControllers = {}; // Added focus node for parking capacity
final bool _showClock = false; 
  String? _selectedAvailability; 



  
  
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

 Future<void> _showRoomDetailsDialog() async {
    String roomType = '';
    int count = 0;
    double price = 0.0;

    // Show dialog box for input
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Room Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Room type input
                TextField(
                  decoration: InputDecoration(labelText: 'Room Type'),
                  onChanged: (value) {
                    roomType = value;
                  },
                ),
                SizedBox(height: 10),
                // Room count input
                TextField(
                  decoration: InputDecoration(labelText: 'Count'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    count = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 10),
                // Room price input
                TextField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Cancel button
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Save button
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // If valid data is provided, add the room to the list
                if (roomType.isNotEmpty && count > 0 && price > 0) {
                  setState(() {
                    roomData.add({
                      "room_type": roomType,
                      "count": count,
                      "price": price.toStringAsFixed(2),
                    });
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Optionally, show a message if the data is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid data')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }







//  void _showRoomDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Room Types and Prices'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: roomTypes.map((roomType) {
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: Text(roomType), // Room Type
//                     ),
//                     const SizedBox(width: 8), // Space between text and text field
//                     SizedBox(
//                       width: 80, // Fixed width for price text field
//                       child: TextField(
//                         controller: priceControllers[roomType],
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           hintText: 'Price',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 // You can do further actions with the prices here if needed
//               },
//             ),
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

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
  }
  @override
  void dispose() {
    _saveData(); // Save data when the page is disposed
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
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('checkin_time', checkintimeController.text);
    prefs.setString('checkout_time', checkouttimeController.text);
    prefs.setString('payment_method', paymentController.text);
    prefs.setString('parking_capacity', parkingCapacityController.text);
    prefs.setString('price', priceController.text);

    // Save price controllers for room types
    for (var roomType in roomTypes) {
      prefs.setString('price_$roomType', priceControllers[roomType]?.text ?? '');
    }
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
              // Primary Contact Number
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: checkintimeController, // Check-in time controller
                    focusNode: cnumberFocusNode,
                    keyboardType: TextInputType.number,
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
                                    checkintimeController.text = timeString; // Store the selected time in the text box
                                  }
                                });
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
                  ),
                ),
              ),

              // Emergency Contact Number
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: checkouttimeController, // Check-out time controller
                    focusNode: enumberFocusNode,
                    keyboardType: TextInputType.number,
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
                                    checkouttimeController.text = timeString; // Store the selected time in the text box
                                  }
                                });
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
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Email TextFormField
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

              // Complete Address TextFormField
              Column(
                children: [
                  // Dropdown for Availability
                   SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: priceController,
                    focusNode: priceFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price Of Each Room',
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
class Clock24Example extends StatelessWidget {
  final Function(String) onTimeSelected; // Callback for selected time

  const Clock24Example({super.key, required this.onTimeSelected}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('24 hour clock'),
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