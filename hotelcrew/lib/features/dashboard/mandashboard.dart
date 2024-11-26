import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import 'leave.dart';
import 'manleave.dart';



class ManagerDashHomePage extends StatefulWidget {
  const ManagerDashHomePage({super.key});

  @override
  _ManagerDashHomePageState createState() => _ManagerDashHomePageState();
}

class _ManagerDashHomePageState extends State<ManagerDashHomePage> {
  // Sample Data (Hardcoded)
  

 final leaveRequests = [
      {'name': 'Mr. MK Joshi', 'detail': 'Sick Leave'},
      {'name': 'Ms. Sara Smith', 'detail': 'Annual Leave'},
      {'name': 'John Doe', 'detail': 'Casual Leave'},
    ];

  List<int> weeklyStaffperformance = [7, 8, 6, 5, 7, 10, 8];
  Map<String, double> staffAttendancePieData = {
    "Present": 70,
    "Absent": 20,
    "Leave": 10,
  };
  Map<String, double> roomStatusData = {
    "Occupied": 50,
    "Unoccupied": 30,
    "Maintenance": 20,
  };
  Map<String, double> staffStatusData = {
    "Busy": 80,
    "Vacant": 20,
    
  };
  List<double> financialData = [40, 50, 30, 60, 80, 70, 90];

 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Good Morning, User',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Pallete.neutral950,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16, top: screenHeight * 0.0125),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(height: 28),
            Text("Quick Actions", style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Pallete.neutral1000,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
              )
            ),
            ),
            const SizedBox(height: 24),
            Row(
            children: [Container(
              width: screenWidth * 0.428, // Set width here
              height: 97, // Set height here
              decoration: BoxDecoration(
                border: Border.all(color: Pallete.primary300, width: 1),
                 // Use the defined color from your palette
                borderRadius: BorderRadius.circular(8),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color(0x1A000000),
                //     blurRadius: 10,
                //     offset: Offset(0, 4),
                //   ),
                // ],
              ),
              child: QuickActionButton(
                title: 'Attendance',
                iconPath: 'assets/manattendance.svg', // Your icon path
                onPressed: () {
                  // Handle button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManLeaveAttendancePage(),
                    ),
                  );  
                },
              ),
            ),
            const Spacer(),
            Container(
              width: screenWidth * 0.428, // Set width here
              height: 97, // Set height here
              decoration: BoxDecoration(
                border: Border.all(color: Pallete.primary300, width: 1),
                 // Use the defined color from your palette
                borderRadius: BorderRadius.circular(8),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color(0x1A000000),
                //     blurRadius: 10,
                //     offset: Offset(0, 4),
                //   ),
                // ],
              ),
              child: QuickActionButton(
                title: 'Database',
                iconPath: 'assets/mandatabase.svg', // Your icon path
                onPressed: () {
                  // Handle button press
                  print('Attendance button pressed');
                },
              ),
            ),
            
            ],
          ),
            
            const SizedBox(height: 56),
            Text(
              "Staff Performance Metrics",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Pallete.neutral1000,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: Pallete.primary50,
              width: screenWidth * 0.92,
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: BarChartWidget(weeklyStaffperformance),
              ),
            ),
            const SizedBox(height: 56),
            Text(
              "Quick Stats Overview",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Pallete.neutral1000,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 228,
              width: screenWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      // height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                        color: Pallete.pagecolor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Pallete.primary200, width: 1),
                      ),
                      child: PieChartWidget(
              title: 'Staff Attendance',
              data: staffAttendancePieData,
              colors: const {
                "Present": Pallete.success500,
                "Absent": Pallete.error500,
                "Leave": Pallete.warning300,
              },
            ),

                    ),
                    const SizedBox(width: 16),
                    Container(
                      // height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                        color: Pallete.pagecolor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Pallete.primary200, width: 1),
                      ),
                      child:  PieChartWidget(
              title: 'Room Status',
              data: roomStatusData,
              colors: const {
                "Occupied": Pallete.success500,
                "Unoccupied": Pallete.error500,
                "Maintenance": Pallete.warning300,
              },
            ),
                    ),
                      const SizedBox(width: 16),
                    Container(
                      // height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                         color: Pallete.pagecolor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Pallete.primary200, width: 1),
                      ),
                      child:  PieChartWidget(
              title: 'Staff Status',
              data: staffStatusData,
              colors: const {
                "Busy": Pallete.success500,
                "Vacant": Pallete.error500,
              },
            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 56),

             GeneralListDisplay<Map<String, String>>(
        items: leaveRequests,
        title: 'Pending Requests',
        onViewAll: () {
          // Navigate to the full list view
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveAttendancePage()));
          print('View All clicked');
        },
        getTitle: (item) => item['name'] ?? 'Unknown',
        getSubtitle: (item) => item['detail'] ?? 'No details',
        onApprove: (item) {
          // Handle approve logic
          print('Approved: ${item['name']}');
        },
        onReject: (item) {
          // Handle reject logic
          print('Rejected: ${item['name']}');
        },
      ),
            const SizedBox(height:56),
            Text(
              "Weekly Financial Overview",
              style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            // Financial Overview Chart
            Container(
              color: Pallete.primary50,
              height: 283,
              width: screenWidth * 0.9,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: LineChartWidget(financialData)),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    ),
  );
}}


// 





Widget _buildPendingLeaveRequests() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        const Text(
          'Pending Leave Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12.0),
          child: const Text(
            'No pending requests at the moment.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        
      ],
    ),
   
  );
}
