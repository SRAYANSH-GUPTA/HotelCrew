import '../../../core/packages.dart';
import 'package:flutter/services.dart';

class PageOne extends StatefulWidget {
  const PageOne({super.key});

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

    // Add listeners to save data as it changes
    nameController.addListener(() {
      final trimmedName = nameController.text.trim();
      saveData('hotel_name', trimmedName);
    });
    businessController.addListener(() {
      final trimmedBusiness = businessController.text.trim();
      saveData('legal_business_name', trimmedBusiness);
    });
    yearController.addListener(() {
      final trimmedYear = yearController.text.trim();
      saveData('year_established', trimmedYear);
    });
    licenseController.addListener(() {
      final trimmedLicense = licenseController.text.trim();
      saveData('license_number', trimmedLicense);
    });
  }

  @override
  void dispose() {
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
          title: const Text('Select Year'),
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
  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
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
            SizedBox(
              height: 86,
              width: screenWidth * 0.91,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  maxLength: 40,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field.'; // Error message
                    }
                    return null;
                  },
                  controller: nameController,
                  focusNode: nameFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.-]')), // Allow letters, numbers, spaces, commas, periods, and hyphens
                  ],
                  decoration: InputDecoration(
                    labelText: 'Hotel Name',
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
                    counterText: '', // Remove the max length counter
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
            // Legal Business Name TextFormField
            SizedBox(
              height: 86,
              width: screenWidth * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  maxLength: 40,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field.'; // Error message
                    }
                    return null;
                  },
                  controller: businessController,
                  focusNode: businessFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.-]')), // Allow letters, numbers, spaces, commas, periods, and hyphens
                  ],
                  decoration: InputDecoration(
                    labelText: 'Legal Business Name',
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
                    counterText: '', // Remove the max length counter
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
                      color: Pallete.neutral950,
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
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is a required field.'; // Error message
                  }
                  return null;
                },
                controller: yearController,
                focusNode: yearFocusNode,
                readOnly: true, // Make it readonly so users must use the year picker
                decoration: InputDecoration(
                  labelText: 'Year Established',
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
                  counterText: '', // Remove the max length counter
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
                    color: Pallete.neutral950,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // License/Registration Number TextFormField
            Container(
              height: 86,
              width: screenWidth * 0.9,
              padding: const EdgeInsets.only(top: 8, bottom: 22),
              child: TextFormField(
                maxLength: 40,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is a required field.'; // Error message
                  }
                  return null;
                },
                controller: licenseController,
                focusNode: licenseFocusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.-]')), // Allow letters, numbers, spaces, commas, periods, and hyphens
                ],
                decoration: InputDecoration(
                  labelText: 'License/Registration Number',
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
                  counterText: '', // Remove the max length counter
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
                    color: Pallete.neutral950,
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