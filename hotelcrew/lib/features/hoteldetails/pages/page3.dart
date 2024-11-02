import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
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
    
    // Listen for focus changes to update the UI
    cnumberFocusNode.addListener(() => setState(() {}));
    enumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
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
              // Primary Contact Number
              Container(
                height: 86,
                width: 328,
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
                            items: [
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

              // Emergency Contact Number
              Container(
                height: 86,
                width: 328,
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
                            items: [
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

              // Email TextFormField
              Container(
                height: 86,
                width: 328,
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
              SizedBox(height: 8),

              // Complete Address TextFormField
              Container(
                height: 86,
                width: 328,
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: TextFormField(
                  controller: addressController,
                  focusNode: addressFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Complete Address',
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
      ),
    );
  }
}
