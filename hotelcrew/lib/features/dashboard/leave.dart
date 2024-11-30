import "../../core/packages.dart";
import 'attendancepage.dart';
import 'package:dio/dio.dart'; 
import 'model/getleavemodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attendancemanager.dart';
import 'viewmodel/getleaveviewmodel.dart';

class LeaveAttendancePage extends StatefulWidget {
  const LeaveAttendancePage({super.key});

  @override
  _LeaveAttendancePageState createState() => _LeaveAttendancePageState();
}

class _LeaveAttendancePageState extends State<LeaveAttendancePage> {
  final leaveCountViewModel = LeaveCountViewModel();
  String Roles = '';

  void getrole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String Role = prefs.getString('Role') ?? '';
    print(Role);
    setState(() {
      Roles = Role;
    });
  }

  int _presentCount = 0;
  int _absentCount = 0;
  int _leaveCount = 0;
  bool _isLoading = true;

  Future<void> fetchAttendance() async {
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/week-stats/';
    const String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVC9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs";

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

          setState(() {
            _presentCount = crewPresent[lastIndex];
            _absentCount = staffAbsent[lastIndex];
            _leaveCount = leave[lastIndex];
            _isLoading = false;
          });

          print("Date: ${dates[lastIndex]}");
          print("Present: $_presentCount");
          print("Absent: $_absentCount");
          print("Leave: $_leaveCount");
        } else {
          print("No attendance data available.");
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching attendance data: $error');
    }
  }

  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/leave_count/';

  Future<void> fetchleavecount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Response response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _leaveCount = response.data['data']['leave_count'] ?? 0;
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Log In Again');
      } else {
        throw Exception('Failed to load leave count');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      print("Error fetching data: $error");
    }
  }

  Future<void> approveLeaveRequest(String leaveId, String status) async {
    final String url = 'https://hotelcrew-1.onrender.com/api/attendance/leave_approve/$leaveId/';
    final Map<String, String> headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'status': status,
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print("&&&&&&&&&&&");
      print(response.body);
      print(leaveId);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave request updated successfully')),
        );
        fetchleavecount();
        getdata(); // Refresh leave count
      } else {
        throw Exception('Failed to update leave request');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  List<Map<String, dynamic>> leaveRequests = [
    {
      "id": "001",
      "name": "John Doe",
      "type": "Sick Leave",
      "department": "Engineering",
      "duration": "2 days",
      "reason": "Sick",
      "dates": "15 Mar - 16 Mar",
      "status": "Pending"
    },
    {
      "id": "002",
      "name": "Jane Smith",
      "type": "Annual Leave",
      "department": "HR",
      "duration": "3 days",
      "reason": "Vacation",
      "dates": "20 Mar - 22 Mar",
      "status": "Approved"
    },
    {
      "id": "003",
      "name": "Bob Wilson",
      "type": "Sick Leave",
      "department": "Sales",
      "duration": "1 day",
      "reason": "Flu",
      "dates": "18 Mar",
      "status": "Rejected"
    },
  ];

  String selectedFilter = "All";

  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter == "All") {
      return leaveRequests;
    }
    return leaveRequests.where((request) => request["status"] == selectedFilter).toList();
  }

  bool isLoading = false;

  void getdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      leaveRequests = await leaveCountViewModel.fetchLeaveRequests();
    } catch (e) {
      print("Error fetching leave requests: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    print(leaveRequests);
  }

  @override
  void initState() {
    super.initState();
    getrole();
    fetchAttendance();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
        ),
        title: Text(
          "Attendance",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral950,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Today's Attendance Overview",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: LinearProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOverviewCard("Present", _presentCount.toString(), Pallete.success200),
                      _buildOverviewCard("Absent", _absentCount.toString(), Pallete.error200),
                      _buildOverviewCard("Leave", _leaveCount.toString(), Pallete.warning200),
                    ],
                  ),
            const SizedBox(height: 24),
            if (Roles == 'Manager')
              SizedBox(
                width: screenWidth * 0.65,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerAttendancePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Mark Today’s Attendance",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.5,
                      color: Pallete.neutral00,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (Roles == 'Admin')
              SizedBox(
                width: screenWidth * 0.637,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendancePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "View Full Attendance",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.5,
                      color: Pallete.neutral00,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              "Leave Requests",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                height: 1.5,
                color: Pallete.neutral950,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: LinearProgressIndicator())
                  : leaveRequests.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) => _buildLeaveRequestCard(filteredRequests[index], screenWidth),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Update the filter chip selection
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["All", "Approved", "Rejected"]
            .map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    showCheckmark: false,
                    selectedColor: Pallete.neutral200,
                    label: Text(
                      filter,
                      style: GoogleFonts.montserrat(
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => selectedFilter = filter);
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLeaveRequestCard(Map<String, dynamic> request, double screenWidth) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request["name"],
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Department: ",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Pallete.neutral950,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: request["department"],
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
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.261,
                      child: ElevatedButton(
                        onPressed: () {
                          approveLeaveRequest(request["id"], "Approved");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Pallete.success600, width: 1),
                          ),
                          backgroundColor: Pallete.neutral00,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                        ),
                        child: Text(
                          "Approve",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Pallete.success600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: screenWidth * 0.261,
                      child: ElevatedButton(
                        onPressed: () {
                          approveLeaveRequest(request["id"], "Rejected");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Pallete.error700, width: 1),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                        ),
                        child: Text(
                          "Reject",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Pallete.error700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
