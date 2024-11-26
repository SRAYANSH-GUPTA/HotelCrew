import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/packages.dart';
import  'package:fl_chart/fl_chart.dart';
import '../receptionist/staffannouncement.dart';
import '../receptionist/staffmanageleave.dart';
class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

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
            padding: EdgeInsets.only(right: 16, top: 16),
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
           SizedBox(height:20),
            

            // Weekly Task Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                "Weekly Task Overview",
                style: GoogleFonts.montserrat(
                  textStyle:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral1000,
                ),),
              ),
              SizedBox(width: 20),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverviewCard(
                  title: "Assigned",
                  count: "24",
                  color: Pallete.warning200,
                ),
                OverviewCard(
                  title: "Completed",
                  count: "16",
                  color: Pallete.success200,
                ),
                OverviewCard(
                  title: "Pending",
                  count: "8",
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
              child:LineChartWidget(),
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
              child: const PieChartWidgetstaff(
                title: "Your Attendance",
                data: {
                  "Present": 70.0,
                  "Absent": 20.0,
                  "Leave": 10.0,
                },
                colors: {
                  "Present": Colors.green,
                  "Absent": Colors.red,
                  "Leave": Colors.orange,
                },
              ),
            ),
            SizedBox(height: 56),

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
              SizedBox(width: 20),
               GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StaffManageLeavePage()));

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
            const LeaveRequestCard(
              request: {
                "type": "Sick",
                "duration": "3 days",
                "dates": "24-12-24 to 12-11-24",
                "status": "Pending",
              },
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
       Spacer(),
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
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
         Padding(
          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
           child: CustomPaint(
            painter: DashedLinePainter(), // Add dashed lines using CustomPainter
            child: SizedBox(
              height: 200,
              width: screenWidth * 0.8,
            ),
                   ),
         )
        ,Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        // decoration: BoxDecoration(
        //   color: Pallete.pagecolor,
        //   borderRadius: BorderRadius.circular(12),
        //   border: Border.all(color: Colors.blue.shade200, width: 1),
        // ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: false,
            ),
            // gridData: FlGridData(
            // drawHorizontalLine: true,
            // drawVerticalLine: true,
            // horizontalInterval: 20,
            // verticalInterval: 1,
            // getDrawingHorizontalLine: (value) {
            //   return FlLine(
            //     color: Colors.grey,
            //     strokeWidth: 1,
            //     dashArray: [4, 4], // Dash pattern for horizontal lines
            //   );
            // },
            //  getDrawingVerticalLine: (value) {
            //   return FlLine(
            //     color: Colors.grey,
            //     strokeWidth: 1,
            //     dashArray: [4, 4], // Dash pattern for vertical lines
            //   );
            // },
            // ),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            show: false,
            border: Border.all(
              color: Colors.grey,
              width: 1,
              
              // dashArray: [4, 4], // Dash pattern for border lines
            ),
          ),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 100), // Monday
                  FlSpot(1, 20),  // Tuesday
                  FlSpot(2, 50),  // Wednesday
                  FlSpot(3, 30),  // Thursday
                  FlSpot(4, 90),  // Friday
                  FlSpot(5, 70),  // Saturday
                  FlSpot(6, 50),  // Sunday
                ],
                
                isCurved: true,
                isStrokeJoinRound: true,
                color: Pallete.primary700,
                barWidth: 1,
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
        radius: 5, // Or set radius to zero to make them invisible
        color: Colors.transparent,
        strokeColor: Pallete.primary700,
        strokeWidth: 1,
      );},
                ),
              ),
            ],
          ),
        ),
      ),],
    );
  }


  
}
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    const dashWidth = 4;
    const dashSpace = 4;

    // Draw horizontal dashed lines
    for (double y = 0; y <= size.height; y += size.height / 5) {
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
    for (double x = 0; x <= size.width; x += size.width / 6) {
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

    // Draw dashed border
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

