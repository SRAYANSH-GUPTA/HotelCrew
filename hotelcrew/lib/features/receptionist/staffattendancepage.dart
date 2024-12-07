import "../../core/packages.dart";
import 'staffmanageleave.dart';
import 'attendancesummary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "staffannouncement.dart";
import '../../providers/shift_providers.dart'; // Import the shift provider

class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  _StaffAttendancePageState createState() => _StaffAttendancePageState();
}

class _StaffAttendancePageState extends State<StaffAttendancePage> {
  List<Map<String, dynamic>> attendanceData = [];
  String selectedFilter = "All";
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;

  int daysPresent = 0;
  int totalLeaveDays = 0;
  int totalDaysUpToToday = 0;

  String shift = 'Loading..';
  String shiftTime = 'Loading';

  final String attendanceApiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/month-check/';
  final String monthlyAttendanceApiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/month/';

  @override
  void initState() {
    super.initState();
    getTokenAndFetchData();
    fetchShiftData(); // Fetch shift data
  }

  String access_token = "";

  Future<void> getTokenAndFetchData() async {
    await getToken();
    fetchAttendanceData();
    fetchMonthlyAttendanceData();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      print('Token is null or empty');
    } else {
      if (mounted) {
        setState(() {
          access_token = token;
        });
      }
      print('Token retrieved: $access_token');
    }
  }

  Future<void> fetchShiftData() async {
    try {
      ShiftProvider shiftProvider = ShiftProvider();
      Map<String, String> shiftData = await shiftProvider.fetchShiftData();
      if (mounted) {
        setState(() {
          shift = shiftData['shift']!;
          shiftTime = shiftData['shiftTime']!;
        });
        print("shift: $shiftTime");
      }
    } catch (e) {
      print('Error fetching shift data: $e');
    }
  }

  Future<void> fetchAttendanceData() async {
    if (access_token.isEmpty) {
      print('Access token is null or empty');
      return;
    }

    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$attendanceApiUrl?page=$currentPage'),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      print(response.statusCode);
      print(response.body);
      print("%" * 50);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Map<String, dynamic>> newAttendanceData = convertAttendanceData(data['results']);
        if (mounted) {
          setState(() {
            attendanceData.addAll(newAttendanceData);
            currentPage++;
            hasMoreData = data['next'] != null;
          });
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchMonthlyAttendanceData() async {
    if (access_token.isEmpty) {
      print('Access token is null or empty');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(monthlyAttendanceApiUrl),
        headers: {
          'Authorization': 'Bearer $access_token',
        },
      );
      print("%" * 50);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            daysPresent = data['days_present'];
            totalLeaveDays = data['leaves'];
            totalDaysUpToToday = data['total_days_up_to_today'];
          });
        }
      } else {
        print('Failed to load monthly attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching monthly attendance data: $e');
    }
  }

  List<Map<String, dynamic>> convertAttendanceData(List<dynamic> attendanceList) {
    List<Map<String, dynamic>> formattedAttendanceData = [];
    for (var attendance in attendanceList) {
      formattedAttendanceData.add({
        'date': formatDateTime(attendance['date']),
        'status': attendance['attendance'] ? 'Present' : 'Absent',
      });
    }
    return formattedAttendanceData;
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int daysAbsent = totalDaysUpToToday - daysPresent - totalLeaveDays;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Your Shift Schedule",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: screenWidth * 0.9,
                height: 136,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
                decoration: BoxDecoration(
                  color: Pallete.pagecolor,
                  border: Border.all(
                    color: Pallete.neutral300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shift[0].toUpperCase() + shift.substring(1),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            shiftTime,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/staffattednance.svg",
                      height: 112,
                      width: screenWidth * 0.32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 49),
              Text(
                "Your Attendance",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOverviewCard("Present", daysPresent.toString(), Pallete.success200),
                  _buildOverviewCard("Absent", daysAbsent.toString(), Pallete.error200),
                  _buildOverviewCard("Leave", totalLeaveDays.toString(), Pallete.warning200),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.4389,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceSummaryPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primary800,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "View Summary",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          height: 1.5,
                          color: Pallete.neutral00,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: screenWidth * 0.4389,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffManageLeavePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.neutral00,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        side: const BorderSide(color: Pallete.primary800, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Manage Leave",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          height: 1.5,
                          color: Pallete.primary800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Attendance History",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  height: 1.5,
                  color: Pallete.neutral1000,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              attendanceData.isEmpty
    ? Center(
        child: SvgPicture.asset(
          'assets/staffnoattendancehistory.svg', // Replace with your SVG file path
          width: 200, // Adjust the width as needed
          height: 200, // Adjust the height as needed
        ),
      )
    : ListView.builder(
        itemCount: attendanceData.length + (hasMoreData ? 1 : 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == attendanceData.length) {
            fetchAttendanceData();
            return const Center(child: CircularProgressIndicator());
          }
          final item = attendanceData[index];
          return AttendanceCard(
            date: item['date']!,
            status: item['status']!,
          );
        },
      )

            ],
          ),
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
}

class AttendanceCard extends StatelessWidget {
  final String date;
  final String status;

  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Pallete.neutral100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Text(
            status == 'Present' ? 'P' :
            status == 'Absent' ? 'A' : 
            status == 'Leave' ? 'L' : '',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: status == 'Present'
                  ? Pallete.success500
                  : status == 'Absent'
                      ? Pallete.error700
                      : Pallete.warning600,
            ),
          ),
        ),
      ),
    );
  }
}
