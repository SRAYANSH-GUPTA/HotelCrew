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


bool isLoadingAttendanceData = false;

bool isLoadingStaffData = true;

bool isLoadingRoomData = false;
  void fetchAvailableStaff() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    const url = 'https://hotelcrew-1.onrender.com/api/taskassignment/staff/available/';
// Replace with your actual token

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("="*100);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final int availableStaff = data['availablestaff'] ?? 0;
        final int staffBusy = data['staffbusy'] ?? 0;
        final int totalStaff = data['totalstaff'] ?? 0;

        setState(() {
          staffStatusData = {
            "Vacant": availableStaff / totalStaff * 100,
            "Busy": staffBusy / totalStaff * 100,
          };
          isLoadingStaffData = false;
        });

        print('Available Staff: $availableStaff');
        print('Staff Busy: $staffBusy');
        print('Total Staff: $totalStaff');
      } else {
        print('Failed with status: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

   Future<void> fetchRoomPieData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    const String apiUrl = "https://hotelcrew-1.onrender.com/api/hoteldetails/all-rooms/";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("room pie data resp: $data");
        int roomsOccupied = data['rooms_occupied'] ?? 0;
        int availableRooms = data['available_rooms'] ?? 0;

        double totalRooms = (roomsOccupied + availableRooms).toDouble();
        double occupiedPercentage = totalRooms > 0 ? (roomsOccupied / totalRooms) * 100 : 0;
        double availablePercentage = totalRooms > 0 ? (availableRooms / totalRooms) * 100 : 0;

        setState(() {
          roomStatusData = {
            "Occupied": occupiedPercentage,
            "Unoccupied": availablePercentage,
          };
          isLoadingRoomData = false;
        });
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        isLoadingRoomData = false;
      });
      print("Error fetching room data: $error");
    }
  }

  Future<void> fetchAttendancePieData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/week-stats/';
    

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<String> dates = List<String>.from(data['dates']);
        List<int> crewPresent = List<int>.from(data['total_crew_present']);
        List<int> staffAbsent = List<int>.from(data['total_staff_absent']);
        List<int> leave = List<int>.from(data['total_leave']);

        if (dates.isNotEmpty) {
          int lastIndex = dates.length - 1;

          int totalPresent = crewPresent[lastIndex];
          int totalAbsent = staffAbsent[lastIndex];
          int totalLeave = leave[lastIndex];

          int totalRecords = totalPresent + totalAbsent + totalLeave;

          double presentPercentage = totalRecords > 0 ? (totalPresent / totalRecords) * 100 : 0;
          double absentPercentage = totalRecords > 0 ? (totalAbsent / totalRecords) * 100 : 0;
          double leavePercentage = totalRecords > 0 ? (totalLeave / totalRecords) * 100 : 0;

          setState(() {
            staffAttendancePieData = {
              "Present": presentPercentage,
              "Absent": absentPercentage,
              "Leave": leavePercentage,
            };
            isLoadingAttendanceData = false;
          });

          print("Attendance Pie Data: $staffAttendancePieData");
        } else {
          print("No attendance data available.");
          setState(() {
            isLoadingAttendanceData = false;
          });
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoadingAttendanceData = false;
      });
      print('Error fetching attendance data: $error');
    }
  }





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
    
  };
  Map<String, double> roomStatusData = {
    
  };
  Map<String, double> staffStatusData = {
   
  };

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 14.52 / 12, // line-height in px / font-size in px
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
      ],
    );
  }

 @override
  void initState() {
    super.initState();
    getrole();
    fetchRoomPieData();
    fetchAttendancePieData();
    fetchAvailableStaff();
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
    backgroundColor: Pallete.pagecolor,
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
  decoration: BoxDecoration(
    color: Pallete.primary50,
    border: Border.all(color: Pallete.primary100, width: 1),
    borderRadius: BorderRadius.circular(0),
  ),
  width: screenWidth * 0.90,
  height: 232,
  child: Padding(
    padding: const EdgeInsets.all(8),
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CheckInOutChart(
                  dates: dates,
                  dailyCheckIns: dailyCheckIns,
                  dailyCheckOuts: dailyCheckOuts,
                ),
              ),
              // This Row for the Check-in and Check-out legend
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildLegend(Color(0xFF34A853), 'Check in'),
                  const SizedBox(width: 16),
                  _buildLegend(Pallete.error500, 'Check out'),
                ],
              ),
            ],
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
                        width: screenWidth * 0.483,
                        decoration: BoxDecoration(
                          color: Pallete.pagecolor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Pallete.primary200, width: 1),
                        ),
                        child: isLoadingAttendanceData
                            ? const Center(child: CircularProgressIndicator())
                            : PieChartWidget(
                                title: 'Staff Attendance',
                                data: staffAttendancePieData,
                                colors: const {
                                  "Present": Color(0xFF34A853),
                                  "Absent": Pallete.error500,
                                  "Leave": Pallete.warning300,
                                },
                              ),
                      ),
                    const SizedBox(width: 16),
                    Container(
                        width: screenWidth * 0.483,
                        decoration: BoxDecoration(
                          color: Pallete.pagecolor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Pallete.primary200, width: 1),
                        ),
                        child: isLoadingRoomData
                            ? const Center(child: CircularProgressIndicator())
                            : PieChartWidget(
                                title: 'Room Status',
                                data: roomStatusData,
                                colors: const {
                                  "Occupied": Pallete.success500,
                                  "Unoccupied": Pallete.error500,
                                },
                              ),
                      ),
                      const SizedBox(width: 16),
                    Container(
                        width: screenWidth * 0.483,
                        decoration: BoxDecoration(
                          color: Pallete.pagecolor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Pallete.primary200, width: 1),
                        ),
                        child: isLoadingStaffData
                            ? const Center(child: CircularProgressIndicator())
                            : PieChartWidget(
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
          height: 163,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              // maxY: 100, // Adjust based on your maximum check-in/check-out counts.
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final date = dates[group.x.toInt()];
                    String status = rodIndex == 0 ? 'Check in' : 'Check out';
                    return BarTooltipItem(
                      '$status: ${rod.toY.toInt()}\n$date',
                      GoogleFonts.montserrat(
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 10,
                checkToShowHorizontalLine: (_) => true,
                checkToShowVerticalLine: (_) => true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Pallete.neutral300,
                    strokeWidth: 0.5,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Pallete.neutral300,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < dates.length) {
                        final date = dates[index];
                        return Text(
                          date, // Date will already be in "dd/MM" format.
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 14.52 / 12,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  
                  sideTitles: SideTitles(
                    
                    interval: 10,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 14.52 / 12,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        textAlign: TextAlign.left,
                      );
                    },
                    reservedSize: 15,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              backgroundColor: Pallete.primary50,
              borderData: FlBorderData(
                border: Border(
                  top: BorderSide(
                    color: Pallete.neutral300,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                  left: BorderSide(
                    color: Pallete.neutral300,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: Pallete.neutral300,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                  bottom: BorderSide(
                    color: Pallete.primary800,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              barGroups: _generateBarGroups(),
            ),
          ),
        ),
        // const SizedBox(height: 16),
       
      ],
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(dates.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dailyCheckIns[index].toDouble(),
            color: Pallete.success1000,
            width: 12,
            borderRadius: BorderRadius.circular(0),
          ),
          BarChartRodData(
            toY: dailyCheckOuts[index].toDouble(),
            color: Pallete.error1000,
            width: 12,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });
  }

   
}

 

  