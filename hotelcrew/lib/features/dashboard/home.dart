import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import 'attendancepage.dart';
import 'announcementpage.dart';

class DashHomePage extends StatefulWidget {
  const DashHomePage({super.key});

  @override
  _DashHomePageState createState() => _DashHomePageState();
}

class _DashHomePageState extends State<DashHomePage> {
  // Sample Data (Hardcoded)
  final List<VoidCallback> onPressedList= [
              () =>  print('Attendance Pressed'),
              () => print('Leave Requests Pressed'),
              () => print('Analytics Pressed'),
              () => print('Pay Roll Pressed'),
            ];
  List<int> weeklyStaffperformance = [7, 8, 6, 5, 7, 10, 8];
  Map<String, double> staffAttendancePieData = {
    "Present": 70,
    "Absent": 30,
  };
  Map<String, double> roomStatusData = {
    "Occupied": 50,
    "Unoccupied": 30,
    "Maintenance": 20,
  };
  Map<String, double> StaffStatus = {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementPage()));
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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 77,
                  width: screenWidth * 0.428,
                  child: _buildhomeButton('Attendance', () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendancePage()))),
                ),
                SizedBox(width: 0.055 * screenWidth),
                SizedBox(
                  height: 77,
                  width: screenWidth * 0.428,
                  child: _buildhomeButton('Leave Requests', onPressedList[1]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 77,
                  width: screenWidth * 0.428,
                  child: _buildhomeButton('Analytics', onPressedList[2]),
                ),
                SizedBox(width: 0.055 * screenWidth),
                SizedBox(
                  height: 77,
                  width: screenWidth * 0.428,
                  child: _buildhomeButton('Pay Roll', onPressedList[3]),
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
              height: 200,
              width: screenWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                        color: Pallete.primary50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PieChartWidget(
                        title: "Staff Attendance",
                        data: staffAttendancePieData,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                        color: Pallete.primary50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PieChartWidget(
                        title: "Room Status",
                        data: roomStatusData,
                      ),
                    ),
                      const SizedBox(width: 16),
                    Container(
                      height: 228,
                      width: screenWidth * 0.483,
                      decoration: BoxDecoration(
                        color: Pallete.primary50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PieChartWidget(
                        title: "Staff Status",
                        data: StaffStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height:56),
            Text(
              "Financial Overview",
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


class BarChartWidget extends StatelessWidget {
  final List<int> data;

  const BarChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Explicit height constraint
      child: BarChart(
        BarChartData(
          // Border settings for the chart
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Pallete.primary500,
                style: BorderStyle.solid,
              ),
              left: BorderSide.none,
            ),
          ),
          backgroundColor: Pallete.primary50,
          
          // Grid line settings
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              // Dashed horizontal lines
              return const FlLine(
                color: Pallete.primary500,
                strokeWidth: 0.5,
                dashArray: [5, 5], // Creates a dashed effect
              );
            },
            checkToShowHorizontalLine: (value) => true,
            getDrawingVerticalLine: (value) {
              // Dashed vertical lines
              return const FlLine(
                color: Pallete.primary500,
                strokeWidth: 0.5,
                dashArray: [5, 5], // Creates a dashed effect
              );
            },
            checkToShowVerticalLine: (value) => true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
          ),

          // Align bars with some spacing
          alignment: BarChartAlignment.spaceAround,
          barGroups: data
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  barsSpace: 24.0,
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      toY: entry.value.toDouble(),
                      color: Pallete.primary500,
                      width: 16,
                    ),
                  ],
                ),
              )
              .toList(),
              
          // Axis titles settings
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class PieChartWidget extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const PieChartWidget({required this.title, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [const SizedBox(height: 8,),
        Text(
          title,
           style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.neutral900,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
        ),
        SizedBox(
    
          height: 150,
          width: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: data.entries
                  .map((entry) => PieChartSectionData(
                    showTitle: false,
                    radius: 54,
                        value: entry.value,
                        title: '${entry.key}\n(${entry.value.toInt()}%)',
                        color: entry.key == 'Present'
                            ? Colors.green
                            : entry.key == 'Occupied'
                                ? Colors.blue
                                : Colors.red,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> data;

  const LineChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      
      LineChartData(
        
        lineBarsData: [
          LineChartBarData(
            
            color:Pallete.primary600,
            spots: data
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
            isCurved: true,
           dotData: const FlDotData(
                  show: false, // Set this to false to remove dots
                ),
            belowBarData: BarAreaData(
             
              show: true,
              color: const Color(0xff5662ac4d),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Hide top x-axis labels
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Hide right y-axis labels
      ),
           bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Text(
  days[value.toInt()],
  style: GoogleFonts.inter(
    textStyle: const TextStyle(
      color: Pallete.neutral900,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.5,
    ),
  ),
);

                },
              ),
            ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 25.0,
              showTitles: true,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        gridData: const FlGridData(verticalInterval: 25),
         borderData: FlBorderData(
            border: const Border(
              
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(width: 1,color: Pallete.primary500,
              style: BorderStyle.solid,),
              
              
            ),
            
          ),
      ),
    );
  }
}
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
 Widget _buildhomeButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.primary800,
        elevation: 0,
        // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Pallete.neutral00,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
        ),
      ),
    );
  }

