import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:intl/intl.dart';
import "passwordvalidation.dart";
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
  _CheckInTimeFieldState createState() => _CheckInTimeFieldState();
}

class _CheckInTimeFieldState extends State<CheckInTimeField> {
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

