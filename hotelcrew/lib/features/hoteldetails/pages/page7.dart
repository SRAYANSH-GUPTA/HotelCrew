import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PageFive extends StatefulWidget {
  @override
  _PageFiveState createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {
  final TextEditingController cnumberController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  bool _isDropdownVisible = false; // To control dropdown visibility
  OverlayEntry? _dropdownOverlay;

  void _addItem() {
    String item = _controller.text.trim();
    if (item.isNotEmpty) {
      setState(() {
        _items.add(item); 
        _controller.clear();
      });
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

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _items
                  .map((String item) => ListTile(
                        title: Text(item),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteItem(item);
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _controller.text = item;
                          });
                          _hideDropdown();
                        },
                      ))
                  .toList(),
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
    });
  }

  @override
  void dispose() {
    cnumberController.dispose();
    _controller.dispose();
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
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: cnumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number Of Departments',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
                              int currentValue = int.tryParse(cnumberController.text) ?? 0;
                              cnumberController.text = (currentValue + 1).toString();
                              cnumberController.selection = TextSelection.fromPosition(
                                TextPosition(offset: cnumberController.text.length),
                              );
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/minus.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              int currentValue = int.tryParse(cnumberController.text) ?? 0;
                              if (currentValue > 0) {
                                cnumberController.text = (currentValue - 1).toString();
                                cnumberController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: cnumberController.text.length),
                                );
                              }
                            },
                          ),
                        ],
                      ),
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

              // TextField with Dropdown Toggle
              GestureDetector(
                onTap: () {
                  // Show the dropdown when the TextField is tapped
                  _toggleDropdown();
                },
                child: Container(
                  height: 86,
                  width: 328,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 22),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Add Item',
                        border: OutlineInputBorder(),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _addItem,
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: _toggleDropdown,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
