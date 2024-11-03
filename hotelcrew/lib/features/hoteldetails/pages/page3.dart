import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController yearController = TextEditingController(); // Controller for Year Established
  final TextEditingController licenseController = TextEditingController(); // Controller for License/Registration Number
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode businessFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode(); // FocusNode for Year Established
  final FocusNode licenseFocusNode = FocusNode(); // FocusNode for License/Registration Number

  @override
  void initState() {
    super.initState();
    
    // Listen for focus changes to update the UI
    nameFocusNode.addListener(() => setState(() {}));
    businessFocusNode.addListener(() => setState(() {}));
    yearFocusNode.addListener(() => setState(() {}));
    licenseFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    businessController.dispose();
    yearController.dispose();
    licenseController.dispose();
    nameFocusNode.dispose();
    businessFocusNode.dispose();
    yearFocusNode.dispose();
    licenseFocusNode.dispose();
    super.dispose();
  }

  // Method to pick year
  Future<void> _pickYear() async {
    int? selectedYear;
    int currentYear = DateTime.now().year;

    // Create a list of years to display
    List<int> years = List.generate(101, (index) => currentYear - index); // Last 100 years

    // Show the dialog for year selection
    selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Year'),
          children: years.map((year) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, year);
              },
              child: Text(year.toString()),
            );
          }).toList(),
        );
      },
    );

    setState(() {
      yearController.text = selectedYear.toString(); // Update year in TextFormField
    });
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 86,
              width: 328,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Hotel Name',
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
                    suffixIcon: nameFocusNode.hasFocus && nameController.text.isNotEmpty
                        ? IconButton(
                            icon: SvgPicture.asset(
                              'assets/removeline.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              nameController.clear();
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
            Container(
              height: 86,
              width: 328,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  controller: businessController,
                  focusNode: businessFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Legal Business Name',
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
                    suffixIcon: businessFocusNode.hasFocus && businessController.text.isNotEmpty
                        ? IconButton(
                            icon: SvgPicture.asset(
                              'assets/removeline.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              businessController.clear();
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
            // Year Established TextFormField
            Container(
              height: 86,
              width: 328,
              padding: const EdgeInsets.only(top: 8, bottom: 22),
              child: TextFormField(
                controller: yearController,
                focusNode: yearFocusNode,
                readOnly: true, // Make it readonly so users must use the year picker
                decoration: InputDecoration(
                  labelText: 'Year Established',
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
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/calender.svg',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: _pickYear,
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
            SizedBox(height: 8),
            // License/Registration Number TextFormField
            Container(
              height: 86,
              width: 328,
              padding: const EdgeInsets.only(top: 8, bottom: 22),
              child: TextFormField(
                controller: licenseController,
                focusNode: licenseFocusNode,
                decoration: InputDecoration(
                  labelText: 'License/Registration Number',
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
                  suffixIcon: licenseFocusNode.hasFocus && licenseController.text.isNotEmpty
                      ? IconButton(
                          icon: SvgPicture.asset(
                            'assets/removeline.svg',
                            height: 24,
                            width: 24,
                          ),
                          onPressed: () {
                            licenseController.clear();
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
          ],
        ),
      ),
    );
  }
}
