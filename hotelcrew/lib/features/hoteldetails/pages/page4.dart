import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }

  @override
  void dispose() {
    saveData();  // Save data when the page is disposed (before navigating)
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
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('primary_contact', cnumberController.text);
    await prefs.setString('emergency_contact', enumberController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('address', addressController.text);
    
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
                    decoration: InputDecoration(
                      labelText: 'Primary Contact Number',
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
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Number',
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
                  decoration: InputDecoration(
                    labelText: 'Complete Address',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
