import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/packages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceSummaryPage extends StatefulWidget {
  const AttendanceSummaryPage({super.key});

  @override
  State<AttendanceSummaryPage> createState() => _AttendanceSummaryPageState();
}

class _AttendanceSummaryPageState extends State<AttendanceSummaryPage> {
  String selectedView = 'Month';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Add state variables
  String access_token = "";
  int daysPresent = 0;
  int totalLeaves = 0;
  int totalDays = 0;
  bool isLoading = false;
  List<String> dates = [];
  List<int> crewPresent = [];
  List<int> staffAbsent = [];
  List<int> crewLeave = [];

  Future<void> fetchWeeklyStats() async {
    if (access_token.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://hotelcrew-1.onrender.com/api/attendance/week/'),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dates = List<String>.from(data['dates']);
          crewPresent = List<int>.from(data['total_crew_present']);
          staffAbsent = List<int>.from(data['total_staff_absent']);
          crewLeave = List<int>.from(data['total_leave']);
        });
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No hotel associated with user")),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hotel associated with user')),
        );
      } else {
        throw Exception('Failed to load weekly stats');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token != null && token.isNotEmpty) {
      setState(() {
        access_token = token;
      });
      if (selectedView == 'Month') {
        fetchMonthlyStats();
      }
    }
  }

  Future<void> fetchMonthlyStats() async {
    if (access_token.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://hotelcrew-1.onrender.com/api/attendance/month/'),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          daysPresent = data['days_present'];
          totalLeaves = data['leaves'];
          totalDays = data['total_days_up_to_today'];
        });
      } else {
        throw Exception('Failed to load monthly stats');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Pallete.pagecolor,
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
            "Attendance Summary",
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral1000,
              ),
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to switch between Month/Week views
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_focusedDay.year}-${_focusedDay.month.toString().padLeft(2, '0')}',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildFilterDropdown(
                  screenWidth: screenWidth,
                  value: selectedView,
                  items: ['Month', 'Week'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedView = value;
                        _calendarFormat = value == 'Month'
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                      if (value == 'Month') {
                        fetchMonthlyStats();
                      } else {
                        fetchWeeklyStats();
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar View with BoxDecoration
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Pallete.neutral300, width: 1),
              ),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
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
            const SizedBox(height: 35),
            // Updated Attendance Summary Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Header Row
                  SizedBox(
                    width:screenWidth * 0.9,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Pallete.neutral100,
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                                      border: Border.all(color: Pallete.neutral300, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Present',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Pallete.neutral100,
                                      border: Border(
                                        top: BorderSide(color: Pallete.neutral300, width: 1),
                                        bottom: BorderSide(color: Pallete.neutral300, width: 1),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Absent',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Pallete.neutral100,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                                      border: Border.all(color: Pallete.neutral300, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Leave',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  // Data Rows
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: _buildAttendanceRow(screenWidth: screenWidth)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required double screenWidth,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: 30,
        width: screenWidth * 0.256,
        child: Card(
          color: Pallete.pagecolor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Pallete.neutral400, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Row(
              children: [
                SvgPicture.asset("assets/filter.svg"),
                const SizedBox(width: 3),
                Expanded(
                  child: DropdownButton<String>(
                    value: value,
                    borderRadius: BorderRadius.circular(4),
                    menuWidth: screenWidth * 0.39,
                    elevation: 0,
                    alignment: Alignment.center,
                    isExpanded: true,
                    icon: SvgPicture.asset("assets/dropdownarrow.svg"),
                    underline: Container(),
                    onChanged: onChanged,
                    items: items.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Pallete.neutral950,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  Widget _buildAttendanceRow({required double screenWidth}) {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (selectedView == 'Month') {
    return Row(
      children: [
        _buildDataCell(
          screenWidth: screenWidth,
          count: daysPresent.toString(),
          isLeftTopBorder: true,
        ),
        _buildDataCell(
          screenWidth: screenWidth,
          count: (totalDays - daysPresent - totalLeaves).toString(),
        ),
        _buildDataCell(
          screenWidth: screenWidth,
          count: totalLeaves.toString(),
          isRightTopBorder: true,
        ),
      ],
    );
  } else {
    // Weekly View
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Pallete.neutral200, width: 1),
          right: BorderSide(color: Pallete.neutral200, width: 1),
          bottom: BorderSide(color: Pallete.neutral200, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            screenWidth: screenWidth,
            count: crewPresent.isNotEmpty ? crewPresent.last.toString() : '0',
            isLeftTopBorder: true,
          ),
          _buildDataCell(
            screenWidth: screenWidth,
            count: staffAbsent.isNotEmpty ? staffAbsent.last.toString() : '0',
          ),
          _buildDataCell(
            screenWidth: screenWidth,
            count: crewLeave.isNotEmpty ? crewLeave.last.toString() : '0',
            isRightTopBorder: true,
          ),
        ],
      ),
    );
  }
}
 Widget _buildDataCell({
  required double screenWidth,
  required String count,
  bool isLeftTopBorder = false,
  bool isRightTopBorder = false,
}) {
  return Container(
    width: screenWidth * 0.3, // Adjusted width for responsive layout
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(
      border: Border(
        top: const BorderSide(
          color: Pallete.neutral200,
          width: 2,
        ),
        left: BorderSide(
          color: Pallete.neutral200,
          width: isLeftTopBorder ? 2 : 1,
        ),
        right: BorderSide(
          color: Pallete.neutral200,
          width: isRightTopBorder ? 2 : 1,
        ),
        bottom: const BorderSide(
          color: Pallete.neutral200,
          width: 2,
        ),
      ),
    ),
    child: Text(
      count,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral900,
        ),
      ),
    ),
  );
}}