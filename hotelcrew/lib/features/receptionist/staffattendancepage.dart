import "../../core/packages.dart";
import 'staffmanageleave.dart';
import 'attendancesummary.dart';


class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  _StaffAttendancePageState createState() => _StaffAttendancePageState();
}

class _StaffAttendancePageState extends State<StaffAttendancePage> {
  // Add more sample data for testing filters
   final List<Map<String, String>> attendanceData = [
    {"date": "21/11/2024", "status": "P"},
    {"date": "20/11/2024", "status": "A"},
    {"date": "19/11/2024", "status": "P"},
    {"date": "18/11/2024", "status": "L"},
  ];
  String selectedFilter = "All";

  // Add this method to filter requests
 

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffAttendancePage()));
              },
              splashColor: Colors.transparent, // Removes the splash effect
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/message.svg",
                height: screenWidth * 0.12,
                width: screenWidth * 0.12,
              ),
            ),
          )
        ],
        backgroundColor: Pallete.pagecolor,
        
       
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                " Your Shift Schedule",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 24,),
              Container(
                width: screenWidth * 0.9,
                height: 136,
                padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 11),
                decoration: BoxDecoration(
                  color: Pallete.pagecolor,
                  border: Border.all(
                    color: Pallete.neutral300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:screenWidth*0.05),
                      
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                                    "Day Shift",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                   Text(
                                    "9:00 AM - 4:00 PM",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                      
                        ],
                      ),
                    )
                    ,SvgPicture.asset("assets/staffattednance.svg",
                  height: 112,
                  width:screenWidth* 0.32,
                  )
        
                  ],
                ),
              ),
              const SizedBox(height: 49,),
              
              Text(
                "Your Attendance",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOverviewCard("Present", "45", Pallete.success200),
                  _buildOverviewCard("Absent", "5", Pallete.error200),
                  _buildOverviewCard("Leave", "3", Pallete.warning200),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [SizedBox(
                  width: screenWidth * 0.4389,
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceSummaryPage()));
                
                
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.primary800,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("View Summary",
                    
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height:1.5,
                      color: Pallete.neutral00,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: screenWidth * 0.4389,
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffManageLeavePage()));
                
                
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.neutral00,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      side: const BorderSide(color: Pallete.primary800, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Manage Leave",
                    
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height:1.5,
                      color: Pallete.primary800,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ),
                ]
              ),
              const SizedBox(height: 24),
              Text(
                "Attendance History",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  height:1.5,
                  color: Pallete.neutral1000,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 16),
              Container(
                child:  ListView.builder(
          itemCount: attendanceData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = attendanceData[index];
            return AttendanceCard(
              date: item['date']!,
              status: item['status']!,
            );
          },
        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Update the filter chip selection
 



}