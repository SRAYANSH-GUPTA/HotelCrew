import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode businessFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();
  final FocusNode licenseFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();  // Load data when the page is initialized

    nameFocusNode.addListener(() => setState(() {}));
    businessFocusNode.addListener(() => setState(() {}));
    yearFocusNode.addListener(() => setState(() {}));
    licenseFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    saveData();  // Save data when the page is disposed (before navigating)
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

    List<int> years = List.generate(101, (index) => currentYear - index); // Last 100 years

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

    if (selectedYear != null) {
      setState(() {
        yearController.text = selectedYear.toString(); // Update year in TextFormField
      });
    }
  }

  // Method to save data
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hotel_name', nameController.text);
    await prefs.setString('legal_business_name', businessController.text);
    await prefs.setString('year_established', yearController.text);
    await prefs.setString('license_number', licenseController.text);
  }

  // Method to load saved data
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedHotelName = prefs.getString('hotel_name');
    String? savedBusinessName = prefs.getString('legal_business_name');
    String? savedYear = prefs.getString('year_established');
    String? savedLicense = prefs.getString('license_number');

    // If saved data exists, populate the fields
    if (savedHotelName != null) {
      nameController.text = savedHotelName;
    }
    if (savedBusinessName != null) {
      businessController.text = savedBusinessName;
    }
    if (savedYear != null) {
      yearController.text = savedYear;
    }
    if (savedLicense != null) {
      licenseController.text = savedLicense;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 24, left: screenWidth * 0.045, right: screenWidth * 0.045),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Hotel Name TextFormField
            Container(
              height: 86,
              width: screenWidth * 0.91,
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
            // Legal Business Name TextFormField
            Container(
              height: 86,
              width: screenWidth * 0.9,
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
            SizedBox(height: screenWidth * 0.023),
            // Year Established TextFormField
            Container(
              height: 86,
              width: screenWidth * 0.9,
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
              width: screenWidth * 0.9,
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
