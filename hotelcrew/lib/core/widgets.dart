import 'package:hotelcrew/core/packages.dart';
import 'package:intl/intl.dart';
import "passwordvalidation.dart";
import 'package:fl_chart/fl_chart.dart';
// buildMainButton(
//   context: context,
//   screenHeight: screenHeight,
//   screenWidth: screenWidth,
//   buttonText: 'Submit',
//   onPressed: () {
//     // Submit action
//   },
// );
//hide keyboard
void hideKeyboard(BuildContext context) {
  // Unfocus the current focus node (dismisses the keyboard)
  FocusScope.of(context).requestFocus(FocusNode());
}
//show keyboard


Widget buildMainButton({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: screenHeight * 0.06,
    width: screenWidth * 0.9,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF47518C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Color(0xFFFAFAFA),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    ),
  );
}


// FloorInputField(
//   controller: numberoffloorsController,
//   focusNode: emailFocusNode,
//   labelText: 'Total Number Of Floors',
//   plusIconPath: 'assets/plus.svg',
//   minusIconPath: 'assets/minus.svg',
//   width: screenWidth * 0.9,
// );

class FloorInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final String plusIconPath;
  final String minusIconPath;
  final double width;

  const FloorInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.plusIconPath,
    required this.minusIconPath,
    required this.width,
  });

  @override
  _FloorInputFieldState createState() => _FloorInputFieldState();
}

class _FloorInputFieldState extends State<FloorInputField> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        _errorText = 'This field cannot be empty';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 22),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: _errorText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
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
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            suffixIcon: widget.focusNode.hasFocus
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          widget.plusIconPath,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          int currentValue = int.tryParse(widget.controller.text) ?? 0;
                          widget.controller.text = (currentValue + 1).toString();
                          widget.controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: widget.controller.text.length),
                          );
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          widget.minusIconPath,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {
                          int currentValue = int.tryParse(widget.controller.text) ?? 0;
                          if (currentValue > 0) {
                            widget.controller.text = (currentValue - 1).toString();
                            widget.controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: widget.controller.text.length),
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
    );
  }
}


// ContactNumberField(
//   controller: cnumberController,
//   focusNode: cnumberFocusNode,
//   width: screenWidth * 0.9,
//   labelText: 'Primary Contact Number',
//   selectedCountryCode: '+1',
//   onCountryCodeChanged: (value) {
//     print('Country code changed to $value');
//   },
// );


class ContactNumberField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double width;
  final String labelText;
  final String? selectedCountryCode;
  final Function(String?)? onCountryCodeChanged;

  const ContactNumberField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.width,
    required this.labelText,
    this.selectedCountryCode,
    this.onCountryCodeChanged,
  });

  @override
  _ContactNumberFieldState createState() => _ContactNumberFieldState();
}

class _ContactNumberFieldState extends State<ContactNumberField> {
  String? _errorText;
  String _selectedCountryCode = '+1';
  String _flagPath = 'assets/flags/us.svg'; // Default flag

  final Map<String, String> _countryFlags = {
    '+1': 'assets/flags/us.svg',
    '+44': 'assets/flags/uk.svg',
    '+91': 'assets/flags/in.svg',
  };

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.selectedCountryCode ?? '+1';
    _flagPath = _countryFlags[_selectedCountryCode] ?? 'assets/flags/us.svg';
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _errorText = widget.controller.text.isEmpty ? 'This field is required' : null;
    });
  }

  void _updateFlag(String countryCode) {
    setState(() {
      _flagPath = _countryFlags[countryCode] ?? 'assets/flags/us.svg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 22),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    _flagPath,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      items: _countryFlags.keys.map((code) {
                        return DropdownMenuItem(
                          value: code,
                          child: Text(code),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountryCode = value!;
                          _updateFlag(_selectedCountryCode);
                          if (widget.onCountryCodeChanged != null) {
                            widget.onCountryCodeChanged!(value);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
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
            errorText: _errorText,
            suffixIcon: widget.focusNode.hasFocus && widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/removeline.svg',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      widget.controller.clear();
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
    );
  }
}

// CheckInTimeField(
//   controller: checkintimeController,
//   focusNode: cnumberFocusNode,
//   width: screenWidth * 0.9,
//   labelText: 'Check-in Time',
// );


class CheckInTimeField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double width;
  final String labelText;

  const CheckInTimeField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.width,
    required this.labelText,
  });

  @override
  CheckInTimeFieldState createState() => CheckInTimeFieldState();
}

class CheckInTimeFieldState extends State<CheckInTimeField> {
  String? _errorText;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }
void setError(String? error) {
    setState(() {
      _errorText = error;
    });
  }
  void _validateInput() {
    setState(() {
      _errorText = widget.controller.text.isEmpty ? 'This field is required' : null;
    });
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      final timeString = DateFormat("HH:mm").format(selectedDateTime);
      widget.controller.text = timeString;
      _validateInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 86,
      width: widget.width,
      child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.labelText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.grey,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            errorText: _errorText,
            suffixIcon: widget.focusNode.hasFocus
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/clock.svg', // Path to your clock icon
                      height: 24,
                      width: 24,
                    ),
                    onPressed: _pickTime,
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
      
    );
  }
}

// overlay

// DropdownTextField(
//   controller: _controller,
//   labelText: 'Department Names',
//   width: screenWidth * 0.9,
//   addIconPath: 'assets/plus.svg',
//   initialItems: ['Item1', 'Item2'], // Starting list items
//   onSave: (List<String> items) {
//     // Handle save logic here
//     print("Saved items: $items");
//   },
// );



class DropdownTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double width;
  final String addIconPath;
  final List<String> initialItems;
  final Function(List<String>) onSave;

  const DropdownTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.width,
    required this.addIconPath,
    required this.initialItems,
    required this.onSave,
  });

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  late List<String> _items;
  OverlayEntry? _dropdownOverlay;
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _items = List<String>.from(widget.initialItems);
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    const dropdownHeightOffset = 370.0;

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: dropdownHeightOffset,
        child: Material(
          elevation: 4,
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _items.map((String item) {
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF47518C)),
                    onPressed: () {
                      _deleteItem(item);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      widget.controller.text = item;
                    });
                    _hideDropdown();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_dropdownOverlay!);
    setState(() => _isDropdownVisible = true);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    setState(() => _isDropdownVisible = false);
  }

  void _toggleDropdown() {
    if (_isDropdownVisible) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _addItem() {
    String item = widget.controller.text.trim();
    if (item.isNotEmpty) {
      setState(() {
        _items.add(item);
        widget.controller.clear();
      });
      widget.onSave(_items); // Save data after adding an item
    }
  }

  void _deleteItem(String item) {
    setState(() {
      _items.remove(item);
      _hideDropdown();
    });
    widget.onSave(_items); // Save data after deletion
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 22),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    widget.addIconPath,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: _addItem,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: _toggleDropdown,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ParkingAvailabilityDropdown(
//   selectedAvailability: _selectedAvailability,  // e.g., 'Available'
//   onChanged: (value) {
//     setState(() {
//       _selectedAvailability = value;
//       parking = value == 'Available';
//       if (!parking) {
//         parkingCapacityController.clear();  // Clear parking capacity if not available
//       }
//     });
//   },
//   parking: parking,  // Your boolean state for parking
//   parkingCapacityController: parkingCapacityController,  // The controller for the parking capacity
// )

//pariking
class ParkingAvailabilityDropdown extends StatelessWidget {
  final String? selectedAvailability;
  final Function(String?) onChanged;
  final bool parking;
  final TextEditingController parkingCapacityController;

  const ParkingAvailabilityDropdown({super.key, 
    required this.selectedAvailability,
    required this.onChanged,
    required this.parking,
    required this.parkingCapacityController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: MediaQuery.of(context).size.width * 0.9,  // Use the screen width
      padding: const EdgeInsets.only(top: 8, bottom: 22),
      child: DropdownButtonFormField<String>(
        value: selectedAvailability,
        hint: const Text('Valet Parking'),
        items: const [
          DropdownMenuItem(value: 'Available', child: Text('Available')),
          DropdownMenuItem(value: 'Not Available', child: Text('Not Available')),
        ],
        onChanged: (value) {
          onChanged(value);
        },
        decoration: InputDecoration(
          labelText: "Valet Parking",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
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
        ),
      ),
    );
  }
}

// password validation
class PasswordValidationCard extends StatelessWidget {
  final PasswordValidationState validationState;

  const PasswordValidationCard({super.key, required this.validationState});

  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.911,
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Pallete.accent100, // Light pink background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must be at least 8 characters long and include:',
             style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.blue950,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 1.5,
                            ),
          ),),
          const SizedBox(height: 10),
          _buildValidationRow(
              validationState.hasUppercase, 'One uppercase letter'),
          _buildValidationRow(
              validationState.hasLowercase, 'One lowercase letter'),
          _buildValidationRow(validationState.hasDigits, 'One number'),
          _buildValidationRow(validationState.hasSpecialCharacters,
              'One special character (&@% etc.)'),
        ],
      ),
    );
  }

  Widget _buildValidationRow(bool isValid, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style:  GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.blue950,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 1.5,
                            ),
          ),),
        ],
      ),
    );
  }
}
//email





// GeneralListDisplay<Map<String, String>>(
//         items: leaveRequests,
//         title: 'Pending Requests',
//         onViewAll: () {
//           // Navigate to the full list view
//           print('View All clicked');
//         },

class GeneralListDisplay<T> extends StatelessWidget {
  final List<T> items; // List of items to display
  final String title; // Section title
  final VoidCallback onViewAll; // Callback for "View All" button
  final String Function(T) getTitle; // Function to extract title from an item
  final String Function(T) getSubtitle; // Function to extract subtitle from an item
  final Function(T)? onApprove; // Optional callback for approve button
  final Function(T)? onReject; // Optional callback for reject button

  const GeneralListDisplay({
    required this.items,
    required this.title,
    required this.onViewAll,
    required this.getTitle,
    required this.getSubtitle,
    this.onApprove,
    this.onReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and "View All"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  textStyle:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral1000,
                ),),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Row(
                  children: [Text(
                    'View All',
                     style: GoogleFonts.montserrat(
                    textStyle:const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral900,
                  ),),
                  ),
                  const SizedBox(width: 4,),
                  SvgPicture.asset('assets/dasharrow.svg', height: 12, width: 6),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        // Display the top 2 items
        ...items.take(2).map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Pallete.pagecolor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Pallete.primary200,width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTitle(item),
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral1000,
                          height: 1.5,
                        ),),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getSubtitle(item),
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Pallete.neutral900,
                        ),),
                      ),
                    ],
                  ),
                  // Approve and Reject buttons (optional)
                  Row(
                    children: [
                      if (onApprove != null)
                        GestureDetector(
                          onTap: () => onApprove!(item),
                          child: SvgPicture.asset(
                            'assets/tickdash.svg', // Path to the tick SVG
                            height: 32,
                            width: 32,
                          ),
                        ),
                      if (onApprove != null && onReject != null) const SizedBox(width: 16),
                      if (onReject != null)
                        GestureDetector(
                          onTap: () => onReject!(item),
                          child: SvgPicture.asset(
                            'assets/crossdash.svg', // Path to the cross SVG
                            height: 32,
                            width: 32,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Graphs
class LineChartWidget extends StatelessWidget {
  final List<double> data;

  const LineChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            color: Pallete.primary800,
            barWidth: 2,
            spots: data
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
            isCurved: true,
            dotData: const FlDotData(
              show: false, // Remove dots
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: const LinearGradient(
                colors: [Colors.transparent, Pallete.primary600],
                stops: [0.1, 1],  // Adjust stop values for the gradient transition
                begin: Alignment.bottomCenter,  // Gradient starts from the bottom
                end: Alignment.topCenter,  // Gradient ends at the top
                transform: GradientRotation(0),  // No rotation for vertical gradient
              ),
            ),
            gradient: const LinearGradient(
              colors: [Pallete.primary400, Pallete.primary800],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shadow: Shadow(
              color: Pallete.primary800.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide top x-axis labels
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide right y-axis labels
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Text(
                  days[value.toInt()],
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: Pallete.neutral900,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 25.0,
              showTitles: true,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          verticalInterval: 1,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Pallete.neutral200,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Pallete.neutral200,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(
              width: 1,
              color: Pallete.primary500,
              style: BorderStyle.solid,
            ),
            left: BorderSide(
              width: 1,
              color: Pallete.primary500,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final String title; // Title of the chart
  final Map<String, double> data; // Data categories with their values
  final Map<String, Color> colors; // Colors corresponding to each category

  const PieChartWidget({
    required this.title,
    required this.data,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Chart Title
        Text(
          title,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Pallete.neutral900,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Pie Chart
        SizedBox(
          height: 108,
          width: 108,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0, // Add spacing between sections
              centerSpaceRadius: 0,
              sections: data.entries
                  .map((entry) => PieChartSectionData(
                        showTitle: false,
                        radius: 50,
                        value: entry.value,
                        color: colors[entry.key] ?? Colors.grey,
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Dynamic Legend
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: colors[entry.key] ?? Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${entry.key}: ${entry.value.toStringAsFixed(1)}%',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Pallete.neutral950,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 9),
      ],
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<int> data; // Data for the bar chart

  const BarChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Explicit height constraint
      child: BarChart(
        BarChartData(
          // Border settings for the chart
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Pallete.primary500,
                style: BorderStyle.solid,
              ),
              left: BorderSide.none,
            ),
          ),
          backgroundColor: Pallete.primary50,
          
          // Grid line settings
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              // Dashed horizontal lines
              return const FlLine(
                color: Pallete.primary500,
                strokeWidth: 0.5,
                dashArray: [2, 2], // Creates a dashed effect
              );
            },
            checkToShowHorizontalLine: (value) => true,
            getDrawingVerticalLine: (value) {
              // Dashed vertical lines
              return const FlLine(
                color: Pallete.primary500,
                strokeWidth: 0.5,
                dashArray: [2,2], // Creates a dashed effect
              );
            },
            checkToShowVerticalLine: (value) => true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
          ),

          // Align bars with some spacing
          alignment: BarChartAlignment.spaceAround,
          barGroups: data
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  barsSpace: 24.0,
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      toY: entry.value.toDouble(),
                      color: Pallete.primary500,
                      width: 16,
                    ),
                  ],
                ),
              )
              .toList(),
              
          // Axis titles settings
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Pallete.neutral900,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//Home Button
class HomeButtonWidget extends StatelessWidget {
  final String title; // The title to display on the button
  final VoidCallback onPressed; // The callback to trigger on button press
  final String icon; // The path to the SVG icon
  final double screenWidth; // The screen width (if needed for layout)
  final Color color; // The background color of the button

  const HomeButtonWidget({
    required this.title,
    required this.onPressed,
    required this.icon,
    required this.screenWidth,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 24, width: 24),
            const SizedBox(width: 1.5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Pallete.neutral00,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//manager and receptionist button
class QuickActionButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onPressed;

  const QuickActionButton({super.key, 
    required this.title,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50, // Background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        elevation: 0, // No shadow
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding inside the button
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min, // Let the button size fit the content
        children: [
          SvgPicture.asset(
            iconPath, 
            width: 24, // Adjust size of the icon
            height: 24, // Adjust size of the icon
          ),
          const SizedBox(width: 12), // Space between icon and text
          Text(
            title,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252941), // Text color
              ),
            ),
           
          ),
        ],
      ),
    );
  }
}


//Attendance card
class AttendanceCard extends StatelessWidget {
  final String date;
  final String status;

  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'P': // Present
          return Pallete.success600;
        case 'A': // Absent
          return Pallete.error700;
        case 'L': // Leave
          return Pallete.warning600;
        default: // Default color for unexpected status
          return Colors.grey;
      }
    }

    return Card(
      elevation: 0,
    
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Pallete.neutral100, // Light background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date Text
            Text(
              date,
              style: GoogleFonts.montserrat(textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Pallete.neutral1000,
              ),
            ),),
            // Status Text
           Text(
              status,
              style: GoogleFonts.montserrat(textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: getStatusColor(status),
                height: 1.5,
              ),
            ),),
          ],
        ),
      ),
    );
  }
}


class OverviewCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const OverviewCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(horizontal:0,vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


class LeaveRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;

  const LeaveRequestCard({
    required this.request,
    super.key,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Pallete.warning700;
      case "Approved":
        return Pallete.success600;
      case "Rejected":
        return Pallete.error700;
      default:
        return Pallete.neutral700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.pagecolor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.neutral300, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leave Type
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Leave Type: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["type"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Duration
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Duration: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["duration"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Dates
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Dates: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["dates"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            // Status
            Container(
              height: 36,
              width: 94,
              decoration: BoxDecoration(
                color: _getStatusColor(request["status"]).withOpacity(0.1),
                border: Border.all(color: _getStatusColor(request["status"])),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  request["status"],
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(request["status"]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class GlobalNotification {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static void showSuccessMessage(String message) {
    final overlay = _navigatorKey.currentState!.overlay!;
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: _SuccessNotification(message: message),
        ),
      ),
    );

    // Insert the overlay entry and remove it after a delay
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class _SuccessNotification extends StatelessWidget {
  final String message;

  const _SuccessNotification({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}