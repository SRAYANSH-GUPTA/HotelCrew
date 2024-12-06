import 'dart:convert';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:hotelcrew/core/packages.dart';
import 'assignroom.dart';
import 'receptionistdatabase.dart';
import 'package:intl/intl.dart';
import '../dashboard/gettaskpage.dart';
import 'staffattendancepage.dart';
import "staffannouncement.dart";



class ReceptionistDashHomePage extends StatefulWidget {
  const ReceptionistDashHomePage({super.key});

  @override
  _ReceptionistDashHomePageState createState() => _ReceptionistDashHomePageState();
}

class _ReceptionistDashHomePageState extends State<ReceptionistDashHomePage> {
  // Sample Data (Hardcoded)
  
List<String> dates = [];
  List<int> dailyCheckIns = [];
  List<int> dailyCheckOuts = [];
  bool isLoading = true;

String access_token = "";
Future<void> fetchCheckInOutData() async {
  await getToken(); // Wait for the token to be retrieved
  if (access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }
    const apiUrl = 'https://hotelcrew-1.onrender.com/api/hoteldetails/room-stats/'; // Replace with your API endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl),
       headers: {
        'Authorization': 'Bearer $access_token',
        'Content-Type': 'application/json',
      },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // Process and format dates to "dd/MM".
          dates = (data['dates'] as List)
              .map((date) => _formatDate(date))
              .toList();
          dailyCheckIns = List<int>.from(data['daily_checkins']);
          dailyCheckOuts = List<int>.from(data['daily_checkouts']);
          isLoading = false;
          print(dailyCheckIns);
          print(dailyCheckOuts);
        });
      } else {
        
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM').format(parsedDate); // Format date as "dd/MM".
  }



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

 @override
  void initState() {
    super.initState();
    getrole();
    fetchCheckInOutData();
  }

 Future<void> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null || token.isEmpty) {
    print('Token is null or empty');
  } else {
    setState(() {
      access_token = token;
    });
    print('Token retrieved: $access_token');
  }
}
String username = "Loading..";

 void getrole() async {
    print("&"*10000);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String Role = prefs.getString('Role') ?? '';
    final String Username= prefs.getString('username') ?? '';
    print(Role);
    print(Username);
    print("-"*1000);
    setState(() {
      // Roles = Role;
      username = Username;
    });
  }


 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
      appBar: AppBar(
        title: Text(
          'Good Morning, $username',
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
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StaffAnnouncementPage()));
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
                title: 'Assign Room',
                iconPath: 'assets/manattendance.svg', // Your icon path
                onPressed: () {
            
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssignRoomPage(),
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
                title: 'Manage Guests',
                iconPath: 'assets/mandatabase.svg', // Your icon path
                onPressed: () {
                  // Handle button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReceptionistCustomerDatabasePage(),
                    ),
                  );
                  print('Attendance button pressed');
                },
              ),
            ),
            
            ],
          ),
            
            const SizedBox(height: 56),
            Text(
              "Check-in/Check-out Overview",
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
                child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: CheckInOutChart(
                dates: dates,
                dailyCheckIns: dailyCheckIns,
                dailyCheckOuts: dailyCheckOuts,
              ),
            ),
              ),
            ),
            const SizedBox(height: 56),
            Text(
              "Stats Overview",
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
        title: 'Task Updates',
        onViewAll: () {
          // Navigate to the full list view
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskManagementPage()));
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
           
            // Financial Overview Chart
            
          ],
        ),
      ),
    )
  ;
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




class CheckInOutChart extends StatelessWidget {
  final List<String> dates; // List of dates from the API (formatted as "YYYY-MM-DD").
  final List<int> dailyCheckIns; // Check-in counts for each date.
  final List<int> dailyCheckOuts; // Check-out counts for each date.

  const CheckInOutChart({
    super.key,
    required this.dates,
    required this.dailyCheckIns,
    required this.dailyCheckOuts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 10, // Adjust based on your maximum check-in/check-out counts.
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < dates.length) {
                        final date = dates[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            date, // Date will already be in "dd/MM" format.
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              gridData: const FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(color: Colors.black26, width: 1),
                  left: BorderSide(color: Colors.black26, width: 1),
                ),
              ),
              barGroups: _generateBarGroups(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(Colors.green, 'Check in'),
            const SizedBox(width: 16),
            _buildLegend(Colors.red, 'Check out'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(dates.length, (index) {
      final checkIn = dailyCheckIns[index];
      final checkOut = dailyCheckOuts[index];

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: checkIn.toDouble(), color: Colors.green, width: 12),
          BarChartRodData(toY: checkOut.toDouble(), color: Colors.red, width: 12),
        ],
      );
    });
  }
}