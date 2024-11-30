import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import 'package:hotelcrew/features/dashboard/database.dart';
import 'leave.dart';
import 'payroll.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'attendancemanager.dart';
import "model/getleavemodel.dart";
import "viewmodel/getleaveviewmodel.dart";
import 'manleave.dart';

class DashHomePage extends StatefulWidget {
  const DashHomePage({super.key});

  @override
  _DashHomePageState createState() => _DashHomePageState();
}

class _DashHomePageState extends State<DashHomePage> {
  final List<VoidCallback> onPressedList = [
    () => print('Attendance Pressed'),
    () => print('Leave Requests Pressed'),
    () => print('Analytics Pressed'),
    () => print('Pay Roll Pressed'),
  ];
  final leaveCountViewModel = LeaveCountViewModel();
  List<Map<String, dynamic>> leaveRequests = [];

  List<int> weeklyStaffperformance = [7, 8, 6, 5, 7, 10, 8];
  Map<String, double> staffAttendancePieData = {
    "Present": 70,
    "Absent": 20,
    "Leave": 10,
  };
  Map<String, double> roomStatusData = {
    "Occupied": 50,
    "Unoccupied": 30,
  };
  Map<String, double> staffStatusData = {
    "Busy": 80,
    "Vacant": 20,
  };
  bool isLoadingRoomData = true;
  bool isLoadingAttendanceData = true;
  bool isLoadingStaffData = true;
  List<double> financialData = [40, 50, 60, 60, 90, 70, 90];

  void fetchAvailableStaff() async {
    const url = 'https://hotelcrew-1.onrender.com/api/taskassignment/staff/available/';
    const token = '<your-jwt-token>'; // Replace with your actual token

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs',
          'Content-Type': 'application/json',
        },
      );
      print("***********");
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

  bool leaveisLoading = false;

  void getrole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String Role = prefs.getString('Role') ?? '';
    print(Role);
    setState(() {
      Roles = Role;
    });
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

  void getdata() async {
    setState(() {
      leaveisLoading = true;
    });

    try {
      leaveRequests = await leaveCountViewModel.fetchLeaveRequests();
      print(leaveRequests);
    } catch (e) {
      print("Error fetching leave requests: $e");
    } finally {
      setState(() {
        leaveisLoading = false;
      });
    }

    print(leaveRequests);
  }

  String Roles = "";

  Future<void> fetchRoomPieData() async {
    const String apiUrl = "https://hotelcrew-1.onrender.com/api/hoteldetails/all-rooms/";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs",
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
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/week-stats/';
    const String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs";

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

  @override
  void initState() {
    super.initState();
    getrole();
    fetchRoomPieData();
    fetchAvailableStaff();
    fetchAttendancePieData();
    getdata(); // Fetch data during initialization
  }

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
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
              if (Roles == "Manager") const SizedBox(height: 28),
              if (Roles == "Manager")
                Text(
                  "Quick Actions",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Pallete.neutral1000,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              if (Roles == "Manager") const SizedBox(height: 24),
              Row(
                children: [
                  if (Roles == "Manager")
                    Container(
                      width: screenWidth * 0.428, // Set width here
                      height: 97, // Set height here
                      decoration: BoxDecoration(
                        border: Border.all(color: Pallete.primary300, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QuickActionButton(
                        title: 'Attendance',
                        iconPath: 'assets/manattendance.svg', // Your icon path
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaveAttendancePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  const Spacer(),
                  if (Roles == "Manager")
                    Container(
                      width: screenWidth * 0.428, // Set width here
                      height: 97, // Set height here
                      decoration: BoxDecoration(
                        border: Border.all(color: Pallete.primary300, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QuickActionButton(
                        title: 'Database',
                        iconPath: 'assets/mandatabase.svg', // Your icon path
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DatabasePage(),
                            ),
                          );
                          print('Attendance button pressed');
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              if (Roles == "Admin")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 77,
                      width: screenWidth * 0.428,
                      child: HomeButtonWidget(
                        title: 'Attendance',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaveAttendancePage(),
                            ),
                          );
                        },
                        icon: 'assets/attendancedash.svg', // Path to your icon asset
                        screenWidth: MediaQuery.of(context).size.width, // Get screen width dynamically
                        color: Pallete.primary800, // Use the defined color from your palette
                      ),
                    ),
                    SizedBox(width: 0.055 * screenWidth),
                    SizedBox(
                      height: 77,
                      width: screenWidth * 0.428,
                      child: HomeButtonWidget(
                        title: 'Database', // Title for the button
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DatabasePage(),
                            ),
                          );
                        }, // The callback from the onPressedList at index 1
                        icon: 'assets/databasedash.svg', // Path to the SVG icon for the Database
                        screenWidth: MediaQuery.of(context).size.width, // Get screen width dynamically
                        color: Pallete.primary800, // Background color from your Pallete
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (Roles == "Admin")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 77,
                      width: screenWidth * 0.428,
                      child: HomeButtonWidget(
                        title: 'Analytics', // Title for the button
                        onPressed: onPressedList[2], // The callback from the onPressedList at index 2
                        icon: 'assets/analyticsdash.svg', // Path to the SVG icon for Analytics
                        screenWidth: MediaQuery.of(context).size.width, // Get screen width dynamically
                        color: Pallete.primary800, // Background color from your Pallete
                      ),
                    ),
                    SizedBox(width: 0.055 * screenWidth),
                    SizedBox(
                      height: 77,
                      width: screenWidth * 0.428,
                      child: HomeButtonWidget(
                        title: 'Pay Roll', // Title for the button
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StaffPaymentPage()),
                        ), // Navigation to StaffPaymentPage when the button is pressed
                        icon: 'assets/payrolldash.svg', // Path to the SVG icon for Pay Roll
                        screenWidth: MediaQuery.of(context).size.width, // Get screen width dynamically
                        color: Pallete.primary800, // Background color from your Pallete
                      ),
                    ),
                  ],
                ),
              if (Roles == "Admin") const SizedBox(height: 56),
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
                  padding: const EdgeInsets.all(16),
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
                                  "Present": Pallete.success500,
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
              GeneralListDisplay<Map<String, dynamic>>(
                items: leaveRequests,
                title: 'Pending Requests',
                onViewAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveAttendancePage()));
                  print('View All clicked');
                },
                getTitle: (item) => item['name'] ?? 'Unknown',
                getSubtitle: (item) => item['type'] ?? 'No details',
                onApprove: (item) {
                  approveLeaveRequest(item["id"], "Approved");
                  print('Approved: ${item['name']}');
                },
                onReject: (item) {
                  approveLeaveRequest(item["id"], "Rejected");
                  print('Rejected: ${item['name']}');
                },
              ),
              const SizedBox(height: 56),
              Text(
                "Weekly Financial Overview",
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
              Container(
                color: Pallete.primary50,
                height: 283,
                width: screenWidth * 0.9,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: LineChartWidget(financialData),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralListDisplay<T> extends StatelessWidget {
  final List<T> items;
  final String title;
  final VoidCallback onViewAll;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final void Function(T) onApprove;
  final void Function(T) onReject;

  const GeneralListDisplay({
    super.key,
    required this.items,
    required this.title,
    required this.onViewAll,
    required this.getTitle,
    required this.getSubtitle,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Pallete.neutral1000,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset('assets/dasharrow.svg', height: 12, width: 6),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        items.isEmpty
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(getTitle(item)),
                      subtitle: Text(getSubtitle(item)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => onApprove(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => onReject(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
