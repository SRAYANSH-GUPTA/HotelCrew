import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

// Assuming you have the Pallete class defined for colors
import "../../core/packages.dart"; // Add the correct path to your palette

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Weekly attendance data
  final List<Map<String, dynamic>> weeklyData = [
    {
      'week': 'Week 1',
      'present': 45,
      'absent': 3,
      'leave': 2,
    },
    {
      'week': 'Week 2',
      'present': 44,
      'absent': 4,
      'leave': 2,
    },
    {
      'week': 'Week 3',
      'present': 46,
      'absent': 2,
      'leave': 2,
    },
    {
      'week': 'Week 4',
      'present': 43,
      'absent': 5,
      'leave': 2,
    },
  ];

  // Daily attendance data from 13/11 to 23/11
  final List<Map<String, dynamic>> dailyData = [
    {
      'date': '13/11',
      'present': 42,
      'absent': 3,
      'leave': 2,
      'total': 47
    },
    {
      'date': '14/11',
      'present': 44,
      'absent': 2,
      'leave': 1,
      'total': 47
    },
    {
      'date': '15/11',
      'present': 43,
      'absent': 3,
      'leave': 1,
      'total': 47
    },
    {
      'date': '16/11',
      'present': 45,
      'absent': 1,
      'leave': 1,
      'total': 47
    },
    {
      'date': '17/11',
      'present': 41,
      'absent': 4,
      'leave': 2,
      'total': 47
    },
    {
      'date': '20/11',
      'present': 44,
      'absent': 2,
      'leave': 1,
      'total': 47
    },
    {
      'date': '21/11',
      'present': 43,
      'absent': 2,
      'leave': 2,
      'total': 47
    },
    {
      'date': '22/11',
      'present': 45,
      'absent': 1,
      'leave': 1,
      'total': 47
    },
    {
      'date': '23/11',
      'present': 42,
      'absent': 3,
      'leave': 2,
      'total': 47
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

  // Sample attendance data with dates
  final List<Map<String, dynamic>> attendanceData = [
    {
      'date': DateTime(2023, 11, 23),
      'present': 45,
      'absent': 2,
      'leave': 1,
    },
    {
      'date': DateTime(2023, 11, 22),
      'present': 43,
      'absent': 3,
      'leave': 2,
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
    String day = _selectedDay.day.toString();
    List<int> performance = performanceData[day] ?? [0, 0];

    setState(() {
      barChartData = performance; // Store the performance data for the selected day
    });
  }

  // Get data for last 7 days from selected date
  List<Map<String, dynamic>> getFilteredData() {
    DateTime startDate = _selectedDay.subtract(const Duration(days: 7));
    return attendanceData.where((data) {
      return data['date'].isAfter(startDate) && 
             data['date'].isBefore(_selectedDay.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a['date'].compareTo(b['date']));
  }

  Widget buildBarChart() {
    final filteredData = getFilteredData();
    
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
                final data = filteredData[group.x.toInt()];
                final date = DateFormat('dd/MM').format(data['date']);
                String status = rodIndex == 0 ? 'Present' : 
                              rodIndex == 1 ? 'Absent' : 'Leave';
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
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= filteredData.length) {
                    return const Text('');
                  }
                  final date = filteredData[value.toInt()]['date'];
                  return Text(
                    DateFormat('dd/MM').format(date),
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: filteredData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data['present'].toDouble(),
                  color: Pallete.success400,
                  width: 16,
                ),
                BarChartRodData(
                  toY: data['absent'].toDouble(),
                  color: Pallete.error400,
                  width: 16,
                ),
                BarChartRodData(
                  toY: data['leave'].toDouble(),
                  color: Pallete.warning400,
                  width: 16,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Add to calendar selection handler
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar widget
              TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _updateBarChartData();
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
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
              BarChartWidget(barChartData),
              const SizedBox(height: 20),

              Text(
                'Attendance Analytics',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              buildBarChart(),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 50,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        // tooltipBgColor: Colors.white,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final data = dailyData[group.x.toInt()];
                          String status = rodIndex == 0 ? 'Present' : 
                                        rodIndex == 1 ? 'Absent' : 'Leave';
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
                      show: true,
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
                          BarChartRodData(
                            toY: data['leave'].toDouble(),
                            color: Pallete.warning400,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildLegend(),
              const SizedBox(height: 24),
              _buildWeeklyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Present', Pallete.success400),
        const SizedBox(width: 16),
        _buildLegendItem('Absent', Pallete.error400),
        const SizedBox(width: 16),
        _buildLegendItem('Leave', Pallete.warning400),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weeklyData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = weeklyData[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Pallete.neutral200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['week'],
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Present', data['present'], Pallete.success400),
                    _buildStatItem('Absent', data['absent'], Pallete.error400),
                    _buildStatItem('Leave', data['leave'], Pallete.warning400),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Pallete.neutral600,
          ),
        ),
      ],
    );
  }
}

// BarChartWidget class from your provided code
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
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Pallete.neutral900,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                        ),
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
