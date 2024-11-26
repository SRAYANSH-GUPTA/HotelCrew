import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceSummaryPage extends StatefulWidget {
  const AttendanceSummaryPage({super.key});

  @override
  State<AttendanceSummaryPage> createState() => _AttendanceSummaryPageState();
}

class _AttendanceSummaryPageState extends State<AttendanceSummaryPage> {
  String selectedView = 'Month'; // Dropdown for Month/Week/Day views
  List<Map<String, String>> attendanceData = [
    {'Date': '2024-11-01', 'Status': 'Present'},
    {'Date': '2024-11-02', 'Status': 'Absent'},
    {'Date': '2024-11-03', 'Status': 'Leave'},
    {'Date': '2024-11-04', 'Status': 'Present'},
    {'Date': '2024-11-05', 'Status': 'Present'},
    // Add more dummy records for testing
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Summary',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to switch between Month/Week/Day views
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'November 2024',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedView,
                  items: ['Month', 'Week', 'Day']
                      .map((view) => DropdownMenuItem<String>(
                            value: view,
                            child: Text(view),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedView = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Table Header
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Date',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Status',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            Expanded(
              child: ListView.builder(
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  final record = attendanceData[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade300, width: 1),
                        right: BorderSide(color: Colors.grey.shade300, width: 1),
                        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                record['Date']!,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              record['Status']!,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: _getStatusColor(record['Status']!),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to get color for each status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Leave':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
