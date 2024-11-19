import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/packages.dart';
class PageFive extends StatefulWidget {
  const PageFive({super.key});

  @override
  _PageFiveState createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {
  final TextEditingController numberofdeptController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  final FocusNode department = FocusNode();
  bool _isDropdownVisible = false; // To control dropdown visibility
  OverlayEntry? _dropdownOverlay;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the page is initialized
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      numberofdeptController.text = prefs.getString('numberOfDepartments') ?? '0';
      _items.clear();
      _items.addAll(prefs.getStringList('departmentNames') ?? []);
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('numberOfDepartments', numberofdeptController.text);
    prefs.setStringList('departmentNames', _items);
  }

  void _addItem() {
    String item = _controller.text.trim();
    if (item.isNotEmpty) {
      setState(() {
        _items.add(item);
        _controller.clear();
      });
      _saveData(); // Save data after adding an item
    }
  }

  void _toggleDropdown() {
    if (_isDropdownVisible) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Adjust this value to change the height from the top
    const dropdownHeightOffset = 370.0; // Set to your desired height offset

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: dropdownHeightOffset, // Add offset here
        child: Material(
          elevation: 4,
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            width: 328, // Set your desired width here
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _items.map((String item) {
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF47518C)), // Always show the delete icon
                    onPressed: () {
                      _deleteItem(item); // Delete item from list when pressed
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _controller.text = item; // Set selected item in the TextField
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

  void _deleteItem(String item) {
    setState(() {
      _items.remove(item);
      _hideDropdown(); // Close the dropdown after deletion
      _saveData(); // Save data after deletion
    });
  }

  @override
  void dispose() {
    numberofdeptController.dispose();
    _controller.dispose();
    department.dispose(); // Dispose of the FocusNode
    super.dispose();
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
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: numberofdeptController,
                    focusNode: department, // Corrected from Department to department
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number Of Departments',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/plus.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              int currentValue = int.tryParse(numberofdeptController.text) ?? 0;
                              numberofdeptController.text = (currentValue + 1).toString();
                              numberofdeptController.selection = TextSelection.fromPosition(
                                TextPosition(offset: numberofdeptController.text.length),
                              );
                              _saveData(); // Save data after increment
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/minus.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              int currentValue = int.tryParse(numberofdeptController.text) ?? 0;
                              if (currentValue > 0) {
                                numberofdeptController.text = (currentValue - 1).toString();
                                numberofdeptController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: numberofdeptController.text.length),
                                );
                                _saveData(); // Save data after decrement
                              }
                            },
                          ),
                        ],
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
              const SizedBox(height: 16),

              // TextField with Dropdown Toggle
              // GestureDetector(
              //   onTap: () {
              //     // Show the dropdown when the TextField is tapped
              //     _toggleDropdown();
              //   },
              //   child: SizedBox(
              //     height: 86,
              //     width: screenWidth * 0.9,
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 8, bottom: 22),
              //       child: TextField(
              //         controller: _controller,
              //         decoration: InputDecoration(
              //           labelText: 'Department Names',
              //           border: const OutlineInputBorder(),
              //           suffixIcon: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               IconButton(
              //                  icon: SvgPicture.asset(
              //                 'assets/plus.svg',
              //                 height: 24,
              //                 width: 24,
              //               ),
              //                 onPressed: _addItem,
              //                 color: Colors.black,
              //               ),
              //               IconButton(
              //                 icon: const Icon(Icons.arrow_drop_down),
              //                 onPressed: _toggleDropdown,
              //               ),
              //             ],
              //           ),
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
