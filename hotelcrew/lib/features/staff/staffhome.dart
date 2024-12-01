import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/packages.dart';
import  'package:fl_chart/fl_chart.dart';
import '../receptionist/staffannouncement.dart';
import '../receptionist/staffmanageleave.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../staff/requestaleave.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}
List<double> doubleData = [1.5, 2, 3, 4, 5, 6, 0]; 
// List<double> doubleData = data.map((e) => (e as num).toDouble()).toList();
class _StaffHomePageState extends State<StaffHomePage> {
double absent = 0;
double present = 0.0;
double leave = 0;
String assigned = "0";
String pending = "0";
String completed = "0";
String access_token = "";

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
  @override
  void initState() {
    super.initState();
    getToken();
    fetchLeaveRequests();
    fetchMonthlyAttendanceData();
    fetchTaskData();
    fetchWeeklyPerformance();
  }

Future<dynamic> fetchWeeklyPerformance() async {
   await getToken(); // Wait for the token to be retrieved
  if (access_token == null || access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }

    final url = Uri.parse('https://hotelcrew-1.onrender.com/api/statics/performance/staff/week/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $access_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> dailyStats = data['daily_stats'];

      // Convert daily performance percentages to List<double>
      List<double> performanceData = dailyStats
          .map<double>((item) => item['performance_percentage'].toDouble())
          .toList();
          print("^^^^^^^^^^^^^^^^^^^^^");
          print(performanceData);
        setState(() {
          doubleData = performanceData;
        });
      
    } else {
      
      throw Exception('Failed to load performance data');

    }
  }




 List<Map<String, dynamic>> leaveRequests = [];
 Future<void> fetchLeaveRequests() async {
   await getToken(); // Wait for the token to be retrieved
  if (access_token == null || access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }

  print(access_token);
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/apply_leave/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Map<String, dynamic>> formattedData = convertLeaveRequests(data['data']);
        setState(() {
          leaveRequests = formattedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }



   Future<void> fetchTaskData() async {
    await getToken(); // Wait for the token to be retrieved
  if (access_token == null || access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }

    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/staff/tasks/day/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );
      print("&&&&&&&&&");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          assigned = data['totaltask'].toString();
          completed = data['taskcompleted'].toString();
          pending = data['taskpending'].toString();
        });
      } else {
        print('Failed to load task data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching task data: $e');
    }
  }

  List<Map<String, dynamic>> convertLeaveRequests(List<dynamic> leaveList) {
    List<Map<String, dynamic>> formattedLeaveRequests = [];
    for (var leave in leaveList) {
      formattedLeaveRequests.add({
        'type': leave['leave_type'],
        'department': leave['user_name'],
        'duration': '${leave['duration']} days',
        'dates': '${leave['from_date']} to ${leave['to_date']}',
        'status': leave['status'],
      });
    }
    return formattedLeaveRequests;
  }


Future<void> fetchMonthlyAttendanceData() async {
  await getToken(); // Wait for the token to be retrieved
  if (access_token == null || access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }

  const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/month/';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $access_token', // Properly formatted Authorization header
        'Content-Type': 'application/json',
      },
    );

    print(response.body);
    print(response.statusCode);
    print("^^^^^^^^^^^^^^^^^^^^");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      int daysPresent = data['days_present'];
      int totalLeaveDays = data['leaves'];
      int totalDaysUpToToday = data['total_days_up_to_today'];

      setState(() {
        present = (daysPresent / totalDaysUpToToday) * 100;
        leave = (totalLeaveDays / totalDaysUpToToday) * 100;
        absent = 100 - present - leave;
      });
    } else {
      print('Failed to load monthly attendance data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching monthly attendance data: $e');
  }
}

  // List<Map<String, dynamic>> convertLeaveRequests(List<dynamic> leaveList) {
  //   List<Map<String, dynamic>> formattedLeaveRequests = [];
  //   for (var leave in leaveList) {
  //     formattedLeaveRequests.add({
  //       'type': leave['leave_type'],
  //       'department': leave['user_name'],
  //       'duration': '${leave['duration']} days',
  //       'dates': '${leave['from_date']} to ${leave['to_date']}',
  //       'status': leave['status'],
  //     });
  //   }
  //   return formattedLeaveRequests;
  // }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
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
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffAnnouncementPage()));
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
          children: [
            // Greeting Section
           const SizedBox(height:20),
            

            // Weekly Task Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                "Today's Task Overview",
                style: GoogleFonts.montserrat(
                  textStyle:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral1000,
                ),),
              ),
              const SizedBox(width: 20),
              //  GestureDetector(
              //   onTap: () {
              //     // Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffAttendancePage()));

              //   },
              //   child: Row(
              //     children: [Text(
              //       'View All',
              //        style: GoogleFonts.montserrat(
              //       textStyle:const TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w600,
              //       color: Pallete.neutral900,
              //     ),),
              //     ),
              //     const SizedBox(width: 4,),
              //     SvgPicture.asset('assets/dasharrow.svg', height: 12, width: 6),
              //     ],
              //   ),
              // ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverviewCard(
                  title: "Assigned",
                  count: assigned,
                  color: Pallete.warning200,
                ),
                OverviewCard(
                  title: "Completed",
                  count: completed,
                  color: Pallete.success200,
                ),
                OverviewCard(
                  title: "Pending",
                  count: pending,
                  color: Pallete.error200,
                ),
              ],
            ),
            const SizedBox(height: 56),

            // Performance Chart
             Text(
                "Your Performance",
                style: GoogleFonts.montserrat(
                  textStyle:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral1000,
                ),),
              ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: screenWidth * 0.9,
              // padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Pallete.pagecolor,
                border: Border.all(color: Pallete.neutral200,width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:const LineChartWidget(),
            ),
            const SizedBox(height: 56),

            // Attendance Pie Chart
            Container(
               padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Pallete.pagecolor,
                border: Border.all(color: Pallete.neutral200,width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PieChartWidgetstaff(
                title: "Your Attendance",
                data: {
                  "Present": present,
                  "Absent": absent,
                  "Leave": leave,
                },
                colors: {
                  "Present": Colors.green,
                  "Absent": Colors.red,
                  "Leave": Colors.orange,
                },
              ),
            ),
            const SizedBox(height: 56),

            // Recent Leave Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
                "Recent Leave Requests",
                style: GoogleFonts.montserrat(
                  textStyle:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral1000,
                ),),
              ),
              const SizedBox(width: 20),
               GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffManageLeavePage()));

                },
                child: Row(
                  children: [Text(
                    'View All',
                     style: GoogleFonts.montserrat(
                    textStyle:const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral900,
                  ),),
                  ),
                  const SizedBox(width: 4,),
                  SvgPicture.asset('assets/dasharrow.svg', height: 12, width: 6),
                  ],
                ),
              ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: ListView.builder(
                    itemCount: leaveRequests.length > 2 ? 2 : leaveRequests.length,
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildLeaveRequestCard(
                          leaveRequests[index], screenWidth);
                    },
                  ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.schedule), label: "Schedule"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      //   selectedItemColor: Pallete.primary500,
      //   unselectedItemColor: Pallete.neutral600,
      // ),
    );
  }
}



class PieChartWidgetstaff extends StatelessWidget {
  final String title; // Title of the chart
  final Map<String, double> data; // Data categories with their values
  final Map<String, Color> colors; // Colors corresponding to each category

  const PieChartWidgetstaff({
    required this.title,
    required this.data,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 8),
        // Chart Title
        Column(
          children:[ Text(
            title,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Pallete.neutral900,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
          height: 108,
          width: 108,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0, // Add spacing between sections
              centerSpaceRadius: 0,
              sections: data.entries
                  .map((entry) => PieChartSectionData(
                        showTitle: false,
                        radius: 50,
                        value: entry.value,
                        color: colors[entry.key] ?? Colors.grey,
                      ))
                  .toList(),
            ),
          ),
          
        ),
          
          ],
        ),
       const Spacer(),
        // Dynamic Legend
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: colors[entry.key] ?? Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    child: Text(
                      '${entry.key}: ${entry.value.toStringAsFixed(1)}%',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Pallete.neutral950,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 9),
      ],
    );
  }
  
}
class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
           child: Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        // decoration: BoxDecoration(
        //   color: Pallete.pagecolor,
        //   borderRadius: BorderRadius.circular(12),
        //   border: Border.all(color: Colors.blue.shade200, width: 1),
        // ),
        child: LineChart(
          LineChartData(
            // gridData: const FlGridData(
            //   show: false,
            // ),
            gridData: FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
                // dashArray: [4, 4], // Dash pattern for horizontal lines
              );
            },
             getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
                // dashArray: [4, 4], // Dash pattern for vertical lines
              );
            },
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 25,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Mon',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 1:
                        return const Text('Tue',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 2:
                        return const Text('Wed',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 3:
                        return const Text('Thu',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 4:
                        return const Text('Fri',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 5:
                        return const Text('Sat',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      case 6:
                        return const Text('Sun',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12));
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
  show: true,
  border: const Border(
    top: BorderSide(
      color: Colors.grey, // Color for the top border
      width: 0.5,           // Width of the top border
    ),
    right: BorderSide(
      color: Colors.grey, // Color for the right border
      width: 0.5,           // Width of the right border
    ),
    bottom: BorderSide(
      color: Colors.grey, // Color for the bottom border
      width: 3,           // Width of the bottom border
    ),
    left: BorderSide(
      color: Colors.grey, // Color for the left border
      width: 3,           // Width of the left border
    ),
  ),
),

            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: [
    FlSpot(0, doubleData[0]), // Monday
    FlSpot(1, doubleData[1]), // Tuesday
    FlSpot(2, doubleData[2]), // Wednesday
    FlSpot(3, doubleData[3]), // Thursday
    FlSpot(4, doubleData[4]), // Friday
    FlSpot(5, doubleData[5]), // Saturday
    FlSpot(6, doubleData[6]), // Uncomment this if data includes Sunday
  ],

                isCurved: true,
                isStrokeJoinRound: true,
                color: Pallete.primary700,
                barWidth: 2,
                isStrokeCapRound: true,
                curveSmoothness: 0,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(
                  show: true,
                   getDotPainter: (spot, xPercentage, bar, index) {
      // Returns a transparent dot painter
      return FlDotCirclePainter(
        radius: 3, // Or set radius to zero to make them invisible
        color: Pallete.primary700,
        strokeColor: Pallete.primary700,
        strokeWidth: 1,
      );},
                ),
              ),
            ],
          ),
        ),
    ),
         ),
      ],
    );
  }


  
}
class DashedLinePainter extends CustomPainter {
  final double minX, maxX, minY, maxY;
  final int horizontalDivisions, verticalDivisions;

  DashedLinePainter({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    this.horizontalDivisions = 5,
    this.verticalDivisions = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    const dashWidth = 4;
    const dashSpace = 4;

    // Calculate vertical spacing (for horizontal dashed lines)
    final double verticalSpacing = size.height / horizontalDivisions;
    // Calculate horizontal spacing (for vertical dashed lines)
    final double horizontalSpacing = size.width / verticalDivisions;

    // Draw horizontal dashed lines
    for (int i = 0; i <= horizontalDivisions; i++) {
      double y = i * verticalSpacing;
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashWidth, y),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    // Draw vertical dashed lines
    for (int i = 0; i <= verticalDivisions; i++) {
      double x = i * horizontalSpacing;
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }

    // Draw dashed border (optional)
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

 Widget _buildLeaveRequestCard(Map<String, dynamic> request, double screenWidth) {
    Color getStatusColor(String status) {
      switch (status) {
        case "Pending":
          return Pallete.warning700;
        case "Approved":
          return Pallete.success600;
        case "Rejected":
          return Pallete.error700;
        default:
          return Pallete.neutral700;
      }
    }

    return Card(
      color: Pallete.pagecolor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Pallete.neutral300, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leave Type
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Leave Type: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["type"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Duration
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Duration: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["duration"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Dates
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Dates: ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: request["dates"],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral950,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Status in a Row
              ],
            ),
            Container(
              height: 36,
              width: 94,
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(request["status"]).withOpacity(0.1),
                border: Border.all(color: getStatusColor(request["status"])),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  request["status"],
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(request["status"]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
