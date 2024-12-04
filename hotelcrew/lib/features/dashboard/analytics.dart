import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import "../../core/packages.dart"; // Add the correct path to your palette
import 'analyticschart.dart' as chart; 
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

  // Weekly attendance data
  // Daily attendance data from 13/11 to 23/11
  final List<Map<String, dynamic>> dailyData = [
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
    {
      'date': '22/11',
      'present': 45,
      'absent': 1,
      'total': 46
    },
    {
      'date': '23/11',
      'present': 42,
      'absent': 3,
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
    _updateBarChartData();
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
      appBar: AppBar(
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
              const Text(
                'Staff Performance Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Bar chart widget using the new BarChartWidget
              BarChartWidget(dailyData: dailyData),
              const SizedBox(height: 20),

              Text(
                'Attendance Analytics',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Bar chart widget using the new BarChartWidget
              BarChartWidget(dailyData: dailyData),
              const SizedBox(height: 24),
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
    Key? key,
    required this.dailyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
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
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= dailyData.length) return const Text('');
                  return Text(
                    dailyData[value.toInt()]['date'],
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
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
          borderData: FlBorderData(show: false),
          barGroups: dailyData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data['present'].toDouble(),
                  color: Pallete.success400,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: data['absent'].toDouble(),
                  color: Pallete.error400,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}