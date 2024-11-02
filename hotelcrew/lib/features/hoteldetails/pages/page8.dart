import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotelcrew/features/hoteldetails/pages/staffdetails.dart';

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 24, left: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFECF1F3),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 92,
              width: 328,
              child: Row(
                children: [
                  Container(
                    width: 263,
                    height: 76,
                    margin: EdgeInsets.only(left: 14, top: 0),
                    child: Column(
                      children: [
                        Container(
                          height: 28,
                          width: 263,
                          child: Text(
                            'Business License',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          height: 42,
                          width: 263,
                          child: Text(
                            'Upload all business license documents for verification',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 12,
                    margin: EdgeInsets.only(left: 24),
                    child: SvgPicture.asset(
                      'assets/document_arrow.svg',
                      height: 16.97,
                      width: 9.48,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFECF1F3),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 92,
              width: 328,
              child: Row(
                children: [
                  Container(
                    width: 263,
                    height: 76,
                    margin: EdgeInsets.only(left: 14, top: 0),
                    child: Column(
                      children: [
                        Container(
                          height: 28,
                          width: 263,
                          child: Text(
                            'Insurance Documents',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          height: 42,
                          width: 263,
                          child: Text(
                            'Upload all insurance documents for verification',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 12,
                    margin: EdgeInsets.only(left: 24),
                    child: SvgPicture.asset(
                      'assets/document_arrow.svg',
                      height: 16.97,
                      width: 9.48,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Staffdetails(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECF1F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 92,
                width: 328,
                child: Row(
                  children: [
                    Container(
                      width: 263,
                      height: 76,
                      margin: EdgeInsets.only(left: 14, top: 0),
                      child: Column(
                        children: [
                          Container(
                            height: 28,
                            width: 263,
                            child: Text(
                              'Staff Details',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFF121212),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            height: 42,
                            width: 263,
                            child: Text(
                              'Upload staff details in excel sheet for their login credentials.',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  color: Color(0xFF121212),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 12,
                      margin: EdgeInsets.only(left: 24),
                      child: SvgPicture.asset(
                        'assets/document_arrow.svg',
                        height: 16.97,
                        width: 9.48,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
