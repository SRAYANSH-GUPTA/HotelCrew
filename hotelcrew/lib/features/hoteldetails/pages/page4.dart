import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import '../../../core/packages.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  final TextEditingController cnumberController = TextEditingController();
  final TextEditingController enumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController(); 
  final TextEditingController addressController = TextEditingController(); 

  final FocusNode cnumberFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode(); 
  final FocusNode addressFocusNode = FocusNode(); 

  String _selectedCountryCode = '+1'; // Default selected code

  @override
  void initState() {
    super.initState();
    loadData();  // Load data when the page is initialized
    
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));

    // Add listeners to save data as it changes
    cnumberController.addListener(() => saveData('primary_contact', cnumberController.text));
    enumberController.addListener(() => saveData('emergency_contact', enumberController.text));
    emailController.addListener(() => saveData('emails', emailController.text));
    addressController.addListener(() {
      final trimmedAddress = addressController.text.trim();
      saveData('address', trimmedAddress);
    });
  }

  @override
  void dispose() {
    cnumberController.dispose();
    enumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    cnumberFocusNode.dispose();
    enumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  // Method to save data
  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Method to load saved data
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCNumber = prefs.getString('primary_contact');
    String? savedENumber = prefs.getString('emergency_contact');
    String? savedEmail = prefs.getString('email');
    String? savedAddress = prefs.getString('address');
  
    // If saved data exists, populate the fields
    if (savedCNumber != null) {
      cnumberController.text = savedCNumber;
    }
    if (savedENumber != null) {
      enumberController.text = savedENumber;
    }
    if (savedEmail != null) {
      emailController.text = savedEmail;
    }
    if (savedAddress != null) {
      addressController.text = savedAddress;
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
                    controller: cnumberController,
                    focusNode: cnumberFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 10, // Set max length to 10
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
                    decoration: InputDecoration(
                      labelText: 'Primary Contact Number',
                      counterText: '', // Remove the max length counter
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            items: const [
                              DropdownMenuItem(value: '+1', child: Text('+1')),
                              DropdownMenuItem(value: '+44', child: Text('+44')),
                              DropdownMenuItem(value: '+91', child: Text('+91')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCountryCode = value!;
                              });
                            },
                          ),
                        ),
                      ),
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
                      suffixIcon: cnumberFocusNode.hasFocus && cnumberController.text.isNotEmpty
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/removeline.svg',
                                height: 24,
                                width: 24,
                              ),
                              onPressed: () {
                                cnumberController.clear();
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
              const SizedBox(height: 16),

              // Emergency Contact Number
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: enumberController,
                    focusNode: enumberFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 10, // Set max length to 10
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Number',
                      counterText: '', // Remove the max length counter
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            items: const [
                              DropdownMenuItem(value: '+1', child: Text('+1')),
                              DropdownMenuItem(value: '+44', child: Text('+44')),
                              DropdownMenuItem(value: '+91', child: Text('+91')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCountryCode = value!;
                              });
                            },
                          ),
                        ),
                      ),
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
                      suffixIcon: enumberFocusNode.hasFocus && enumberController.text.isNotEmpty
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/removeline.svg',
                                height: 24,
                                width: 24,
                              ),
                              onPressed: () {
                                enumberController.clear();
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
              Container(
                height: 86,
                width: screenWidth * 0.9,
                padding: const EdgeInsets.only(top: 8),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    controller: emailController,
                    maxLength: 320,
                    validator: (value) => EmailValidator.validate(value ?? '') 
                        ? null 
                        : "Enter a valid email.",
                    decoration: InputDecoration(
                      labelText: 'Email',
                      counterText: "",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Complete Address TextFormField
              Container(
                height: 86,
                width: screenWidth * 0.9,
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  controller: addressController,
                  focusNode: addressFocusNode,
                  maxLength: 100, // Set max length to 100
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.-]')), // Allow letters, numbers, spaces, commas, periods, and hyphens
                  ],
                  decoration: InputDecoration(
                    labelText: 'Complete Address',
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
                    suffixIcon: addressFocusNode.hasFocus && addressController.text.isNotEmpty
                        ? IconButton(
                            icon: SvgPicture.asset(
                              'assets/removeline.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              addressController.clear();
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
                  onChanged: (value) {
                    final trimmedAddress = value.trim();
                    saveData('address', trimmedAddress);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}