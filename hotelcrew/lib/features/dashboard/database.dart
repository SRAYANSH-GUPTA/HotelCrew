import '../../core/packages.dart';
import 'customerdatabase.dart';
import 'staffdatabase.dart';
class DatabasePage extends StatelessWidget {
  const DatabasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                height: 118,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12.33,vertical: 9),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Staff Details",
                            style: GoogleFonts.montserrat(textStyle:const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral1000,
                            ),),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            "View, add, or edit staff information.",
                             style: GoogleFonts.montserrat(textStyle:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral900,
                            ),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 25),
                   SvgPicture.asset(
                      'assets/databasestaff.svg',
                      width: screenWidth * 0.268,
                      height: 100,
                    ),],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomerDatabasePage()),
                );
              },
              child: Container(
                height: 118,
                padding: const EdgeInsets.symmetric(horizontal: 12.33,vertical: 9),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Guest Details",
                             style: GoogleFonts.montserrat(textStyle:const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral1000,
                            ),
                          ),),
                          const SizedBox(height: 4),
                          Text(
                            "Access and update guest records.",
                          style: GoogleFonts.montserrat(textStyle:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                     SvgPicture.asset(
                      'assets/customerdetails.svg',
                      width: screenWidth * 0.268,
                      height: 100,
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