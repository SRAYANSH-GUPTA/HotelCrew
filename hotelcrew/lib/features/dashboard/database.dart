import 'package:flutter/material.dart';
import '../../core/packages.dart';
import 'customerdatabase.dart';
import 'staffdatabase.dart';
import "../../core/packages.dart";
class DatabasePage extends StatelessWidget {
  const DatabasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar:AppBar(
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
          ),
          title: Text(
            "Database",
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral950,
              ),
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StaffDatabasePage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Pallete.pagecolor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                   
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Staff Details",
                            style: GoogleFonts.montserrat(textStyle:TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral1000,
                            ),),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "View, add, or edit staff information.",
                             style: GoogleFonts.montserrat(textStyle:TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral900,
                            ),),
                          ),
                        ],
                      ),
                    ),
                   SvgPicture.asset(
                      'assets/databasestaff.svg',
                      width: 64,
                      height: 64,
                    ),],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerDatabasePage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Pallete.pagecolor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    // SvgPicture.asset(
                    //   'assets/customerdetails.svg',
                    //   width: 64,
                    //   height: 64,
                    // ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Details",
                             style: GoogleFonts.montserrat(textStyle:TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral1000,
                            ),
                          ),),
                          SizedBox(height: 4),
                          Text(
                            "Access and update guest records.",
                          style: GoogleFonts.montserrat(textStyle:TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral900),
                            ),
                          ),
                        ],
                      ),
                    ),
                     SvgPicture.asset(
                      'assets/databasestaff.svg',
                      width: 64,
                      height: 64,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}