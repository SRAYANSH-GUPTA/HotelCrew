import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import "../../core/packages.dart"; // Add the correct path to your palette
import 'analyticschart.dart' as chart; 
import 'package:http/http.dart' as http;
import "dart:convert";

import 'package:flutter/material.dart';// Import the bar chart widget
 // Import the bar chart widget

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week; // Fixed to week format
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

 


void fetchPerformanceData() async {
  print("^"*100);
   SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print("^^^^"*50);
    print(token);

  final url = Uri.parse('https://hotelcrew-1.onrender.com/api/statics/performance/hotel/past7/');
  final headers = {
    'Authorization': 'Bearer $token',
  };


  final response = await http.get(url, headers: headers);
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    // Map the response data to the required format
    final Map<String, double> performanceData = {};
    final weeklyStats = data['weekly_stats'] as List;
    print(weeklyStats);
    print("^"*100);

    for (var stat in weeklyStats) {
      print("1");
      final date = stat['date'] as String;
      print("2");
      final performancePercentage = stat['performance_percentage'] as double;
      print("3");
      final formattedDate = _formatDate(date);  // Format the date to 'dd/MM'

      performanceData[formattedDate] = performancePercentage;
      print(performanceData);
    }
    print(performanceData);
    print("&"*100);
    // convertPerformanceDataToSampleData(performanceData);
    setState(() {
      sampleData = performanceData;
    });

    
  } else {
    throw Exception('Failed to load performance data');
  }
}


void fetchAttendanceData() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print("^^^^"*50);
    print(token);
  final url = Uri.parse('https://hotelcrew-1.onrender.com/api/attendance/week-stats/');
  final headers = {
    'Authorization': 'Bearer $token',
  };

  final response = await http.get(url, headers: headers);
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<String> dates = List<String>.from(data['dates']);
    final List<int> totalCrewPresent = List<int>.from(data['total_crew_present']);
    final List<int> totalStaffAbsent = List<int>.from(data['total_staff_absent']);
    
    List<Map<String, dynamic>> formattedData = [];

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final present = totalCrewPresent[i];
      final absent = totalStaffAbsent[i];
      final total = present + absent;

      // Format date to "dd/MM"
      final formattedDate = _formatDate(date);

      // Add the formatted data to the list
      formattedData.add({
        'date': formattedDate,
        'present': present,
        'absent': absent,
        'total': total,
      });
    }

    // Update the dailyData list using setState
    setState(() {
      dailyData = formattedData;
    });

  } else {
    throw Exception('Failed to load attendance data');
  }
}


String _formatDate(String date) {
  final parts = date.split('-');
  final dayAndMonth = '${parts[2]}/${parts[1]}';  // Format as "dd/MM"
  return dayAndMonth;
}


Map<String, double> convertPerformanceDataToSampleData(List<Map<String, dynamic>> performanceData) {
  Map<String, double> formattedData = {};

  // Iterate over the performance data and format the date
  for (var stat in performanceData) {
    final String date = stat['date'];
    final double performancePercentage = stat['performance_percentage'];

    // Extract the day and month from the date (in the format 'yyyy-MM-dd')
    final DateTime dateTime = DateTime.parse(date);
    final String formattedDate = DateFormat('dd/MM').format(dateTime);

    // Add the formatted date and performance percentage to the map
    formattedData[formattedDate] = performancePercentage;
  }

  return formattedData;
}



  Map<String, double> sampleData = {
    
  };

  // Weekly attendance data
  // Daily attendance data from 13/11 to 23/11
  List<Map<String, dynamic>> dailyData = [
  
  
  ];
   List<Map<String, dynamic>> dailyroomData = [
     {
      'date': '13/11',
      'present': 42,
      'absent': 3,
      'total': 45
    },
    {
      'date': '14/11',
      'present': 44,
      'absent': 2,
      'total': 46
    },
    {
      'date': '15/11',
      'present': 43,
      'absent': 3,
      'total': 46
    },
    {
      'date': '16/11',
      'present': 45,
      'absent': 1,
      'total': 46
    },
    {
      'date': '17/11',
      'present': 41,
      'absent': 4,
      'total': 45
    },
    {
      'date': '20/11',
      'present': 44,
      'absent': 2,
      'total': 46
    },
    {
      'date': '21/11',
      'present': 43,
      'absent': 2,
      'total': 45
    },
   
  
  
  ];
  



  // Sample data for the bar chart, you can fetch this based on the selected date
  final Map<String, List<int>> performanceData = {
    '1': [5, 3],
    '2': [7, 2],
    '3': [6, 4],
    '4': [8, 1],
    '5': [6, 3],
    '6': [7, 4],
    '7': [9, 0],
    '8': [5, 2],
    '9': [8, 3],
    '10': [6, 4],
    '11': [6, 2],
    '12': [7, 3],
    '13': [8, 1],
    '14': [5, 4],
    '15': [6, 2],
    '16': [9, 1],
    '17': [10, 0],
    '18': [6, 3],
    '19': [7, 4],
    '20': [8, 2],
    '21': [5, 5],
    '22': [6, 3],
    '23': [7, 2],
    '24': [9, 0],
    '25': [10, 1],
    '26': [6, 3],
    '27': [7, 4],
    '28': [8, 1],
    '29': [5, 2],
    '30': [9, 0],
  };

  List<int> barChartData = [];
  List<double> presentData = [10, 20, 30, 40, 50, 60, 70]; // Example data
  List<double> absentData = [5, 15, 25, 35, 45, 55, 65]; // Example data

  // Sample attendance data with dates
  final List<Map<String, dynamic>> attendanceData = [
    {
      'date': DateTime(2023, 11, 23),
      'present': 45,
      'absent': 2,
    },
    {
      'date': DateTime(2023, 11, 22),
      'present': 43,
      'absent': 3,
    },
    // Add more historical data...
  ];

  @override
  void initState() {
    super.initState();
    fetchPerformanceData();
    fetchAttendanceData();
    // _updateBarChartData();
  }

  // Update the bar chart data based on selected date
  void _updateBarChartData() {
    String day = _selectedDay?.day.toString() ?? '';
    List<int> performance = performanceData[day] ?? [0, 0];

    setState(() {
      barChartData = performance; // Store the performance data for the selected day
    });
  }

  // Get data for last 7 days from selected date
  List<Map<String, dynamic>> getFilteredData() {
    DateTime startDate = _selectedDay?.subtract(const Duration(days: 7)) ?? DateTime.now();
    return attendanceData.where((data) {
      return data['date'].isAfter(startDate) && 
             data['date'].isBefore((_selectedDay ?? DateTime.now()).add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a['date'].compareTo(b['date']));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
        backgroundColor: Pallete.pagecolor,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Pallete.neutral900,
          ),
        ),
        title: Text(
          "Analytics",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral1000,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar widget
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    // Do nothing since the format is fixed to week
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Text for metrics
              Text(
  'Staff Performance Metrics',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16, // line-height in px / font-size in px
    textBaseline: TextBaseline.alphabetic, // Ensure proper text alignment
  ),
  textAlign: TextAlign.left, // Align text to the left
),

              const SizedBox(height: 20),
Container(
                color: Pallete.primary50,
                width: screenWidth*0.9,
                height: 220,
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 12.0),
                    child: SizedBox(
                      height: 200,
                      width: screenWidth*0.9,
                      child: WeeklyBarChart(sampleData)),
                  ),
                  

                  ]
                )),
              // Bar chart widget using the new BarChartWidget
             
              const SizedBox(height: 20),

              Text(
  'Staff Attendance',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16, // line-height in px / font-size in px
    textBaseline: TextBaseline.alphabetic, // Ensure proper text alignment
  ),
  textAlign: TextAlign.left, // Align text to the left
),




              const SizedBox(height: 24),

              // Bar chart widget using the new BarChartWidget
               Container(
                 decoration: BoxDecoration(
                color: Pallete.primary50,
                border: Border.all(color: Pallete.primary100, width: 1),
                borderRadius: BorderRadius.circular(0),
              ),
                // color: Pallete.primary50,
                width: screenWidth*0.9,
                height: 260,
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 12.0),
                    child: SizedBox(
                      height: 200,
                      width: screenWidth*0.9,
                      child: BarChartWidget(dailyData: dailyData)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 12),
        const SizedBox(width: 8),
        Text(
          'Present',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    Row(
      children: [
        const Icon(Icons.circle, color: Colors.red, size: 12),
        const SizedBox(width: 8),
        Text(
          'Absent',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    ),
  ],
),
                  )

                  ]
                )),


                              const SizedBox(height: 20),

              Text(
  'Room Status',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16, // line-height in px / font-size in px
    textBaseline: TextBaseline.alphabetic, // Ensure proper text alignment
  ),
  textAlign: TextAlign.left, // Align text to the left
),




              const SizedBox(height: 24),

              // Bar chart widget using the new BarChartWidget
               Container(
                 decoration: BoxDecoration(
                color: Pallete.primary50,
                border: Border.all(color: Pallete.primary100, width: 1),
                borderRadius: BorderRadius.circular(0),
              ),
                
                width: screenWidth*0.9,
                height: 260,
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 12.0),
                    child: SizedBox(
                      height: 200,
                      width: screenWidth*0.9,
                      child: BarChartWidget(dailyData: dailyroomData)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 12),
        const SizedBox(width: 8),
        Text(
          'Occupied',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    ),
    const SizedBox(height: 8),
    Row(
      children: [
        const Icon(Icons.circle, color: Colors.red, size: 12),
        const SizedBox(width: 8),
        Text(
          'Unoccupied',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        





      ],
    ),
    
  
  
  ],
),
                  ),
                  

                  ]
                )),
                const SizedBox(height: 24),
                Text(
  'Check-in revenue',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16, // line-height in px / font-size in px
    textBaseline: TextBaseline.alphabetic, // Ensure proper text alignment
  ),
  textAlign: TextAlign.left, // Align text to the left
),
const SizedBox(height: 20),
              // Bar chart widget using the new BarChartWidget
               Container(
                decoration: BoxDecoration(
                color: Pallete.primary50,
                border: Border.all(color: Pallete.primary100, width: 1),
                borderRadius: BorderRadius.circular(0),
              ),
          
                width: screenWidth*0.9,
                height: 210,
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.only(left: 0,right: 0,top: 0),
                    child: SizedBox(
                      height: 200,
                      width: screenWidth*0.9,
                      child: const LineChartWidget(doubleData: [20,40,50,40,60,10,50],),
                  ),),
                  
                  
                  

                  ])
                ),
                const SizedBox(height: 138),
             
            ],
          ),
        ),
      ),
    );
  }
}
class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> dailyData;

  const BarChartWidget({
    super.key,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 60,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = dailyData[group.x.toInt()];
                String status = rodIndex == 0 ? 'Present' : 'Absent';
                return BarTooltipItem(
                  '$status: ${rod.toY.toInt()}\n${data['date']}',
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
            horizontalInterval: 15,
            verticalInterval: 1,
            checkToShowHorizontalLine: (_) => true,
            checkToShowVerticalLine: (_) => true,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Pallete.neutral300,
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
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
                  if (value.toInt() >= dailyData.length) return const Text('');
                  return Text(
                    dailyData[value.toInt()]['date'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14.52 / 12, // line-height in px / font-size in px
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
  sideTitles: SideTitles(
    interval: 15,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      return Text(
        value.toInt().toString(), // Convert the double value to an integer
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 14.52 / 12, // line-height in px / font-size in px
          textBaseline: TextBaseline.alphabetic,
        ),
        textAlign: TextAlign.left,
      );
    },
    reservedSize: 30,
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
            border: const Border(
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
          barGroups: dailyData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data['present'].toDouble(),
                  color: Pallete.success1000,
                  width: 12,
                  borderRadius: BorderRadius.circular(0),
                ),
                BarChartRodData(
                  toY: data['absent'].toDouble(),
                  color: Pallete.error1000,
                  width: 12,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}


class WeeklyBarChart extends StatelessWidget {
  final Map<String, double> data; // Data for the bar chart as a map

  const WeeklyBarChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final dates = data.keys.toList(); // Extract dates from the map
    final values = data.values.toList(); // Extract values from the map

    return SizedBox(
      height: 200,
      child: data.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/empty_chart.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : BarChart(
              BarChartData(
                maxY: 100,
                minY: 0,
                borderData: FlBorderData(
                  border: const Border(
                    top: BorderSide(
                      color: Pallete.neutral300,
                      width: 0.5,
                    ),
                    left: BorderSide(
                      color: Pallete.neutral300,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: Pallete.primary800,
                      width: 1,
                    ),
                     right: BorderSide(
                      color: Pallete.neutral300,
                      width: 0.5,
                    ),
                  ),
                ),
                backgroundColor: Pallete.primary50,
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: 25,
                  verticalInterval: 1,
                  checkToShowHorizontalLine: (_) => true,
                  checkToShowVerticalLine: (_) => true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Pallete.neutral300,
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Pallete.neutral300,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                alignment: BarChartAlignment.spaceAround,
                barGroups: values
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            color: Pallete.primary700,
                            width: 26,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
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
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        final fixedValues = [0, 25, 50, 75, 100];
                        if (fixedValues.contains(value.toInt())) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              color: Pallete.neutral900,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < dates.length) {
                          return Text(
                            dates[value.toInt()],
                            style: const TextStyle(
                              color: Pallete.neutral900,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
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
class LineChartWidget extends StatelessWidget {
  final List<double> doubleData; // Input data for the line chart

  const LineChartWidget({super.key, required this.doubleData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            height: 196,
            width: screenWidth * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Center(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    horizontalInterval: 25,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Pallete.neutral300,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Pallete.neutral300,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('14/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 1:
                              return const Text('15/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 2:
                              return const Text('16/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 3:
                              return const Text('17/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 4:
                              return const Text('20/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 5:
                              return const Text('21/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
                            case 6:
                              return const Text('22/11',
                                  style: TextStyle(
                                      color: Pallete.neutral900, fontSize: 12,fontWeight: FontWeight.w400));
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
                        color: Pallete.neutral300,
                        width: 0.5,
                      ),
                      right: BorderSide(
                        color: Pallete.neutral300,
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: Pallete.neutral300,
                        width: 2,
                      ),
                      left: BorderSide(
                        color: Pallete.neutral300,
                        width: 0.5,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: doubleData
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value,
                              ))
                          .toList(),
                      isCurved: false,
                      isStrokeJoinRound: true,
                      color: Pallete.primary700, // Customize line color
                      barWidth: 1,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, xPercentage, bar, index) {
                          return FlDotCirclePainter(
                            radius: 1,
                            color: Pallete.primary700,
                            strokeColor: Pallete.primary700,
                            strokeWidth: 4,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

