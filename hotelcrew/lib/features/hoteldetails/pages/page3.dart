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
  final TextEditingController emailController = TextEditingController(); // Controller for Year Established
  final TextEditingController addressController = TextEditingController(); // Controller for License/Registration Number
  final FocusNode cnumberFocusNode = FocusNode();
  final FocusNode enumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode(); // FocusNode for Year Established
  final FocusNode addressFocusNode = FocusNode(); // FocusNode for License/Registration Number

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
    emailController.dispose(); // Corrected variable name
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
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: cnumberController,
                    focusNode: cnumberFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Primary Contact Number',
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
              Container(
                height: 86,
                width: 328,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: enumberController,
                    focusNode: enumberFocusNode,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Number',
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
              // Year Established TextFormField
              Container(
                height: 86,
                width: 328,
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    controller: emailController, // Corrected variable name
                    maxLength: 320,
                    validator: (value) => EmailValidator.validate(value ?? '') 
                        ? null 
                        : "Enter a valid email.",
                    decoration: InputDecoration(
                      labelText: 'Hotel Email',
                      border: OutlineInputBorder(),
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
