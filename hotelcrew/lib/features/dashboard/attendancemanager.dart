import 'package:dio/dio.dart';
import '../../core/packages.dart';

class ManagerAttendancePage extends StatefulWidget {
  const ManagerAttendancePage({super.key});

  @override
  _ManagerAttendancePageState createState() => _ManagerAttendancePageState();
}

class _ManagerAttendancePageState extends State<ManagerAttendancePage> {
  final Dio _dio = Dio();
  final String attendanceApiUrl = 'https://hotelcrew-1.onrender.com/api/attendance';

  String selectedAttendanceStatus = 'None';
  String selectedDepartment = 'All Staff';

  List<dynamic> attendanceList = [
    {
      'user_name': 'John Doe',
      "user_id": "1",
      'department': 'Housekeeping',
      'attendance': 'Present',
    },
    {
      'user_name': 'Jane Smith',
      "user_id": "7",
      'department': 'Receptionist',
      'attendance': 'Absent',
    },
    {
      'user_name': 'David Johnson',
      "user_id": "4",
      'department': 'Security',
      'attendance': 'Present',
    },
    {
      'user_name': 'Emily Davis',
      "user_id": "3",
      'department': 'Maintenance',
      'attendance': 'Absent',
    },
    {
      'user_name': 'Michael Brown',
      "user_id": "2",
      'department': 'Manager',
      'attendance': 'Present',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  bool _isLoading = false;

  Future<void> fetchAttendanceData({String? department}) async {
    setState(() {
      _isLoading = true;
    });
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

    try {
      final response = await _dio.get(
        'https://hotelcrew-1.onrender.com/api/attendance/list/',
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        queryParameters: department != null ? {'department': department} : null,
      );
      print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          attendanceList = response.data;
          _isLoading = false;
        });
        print(response.data);
      } else {
        throw Exception('Failed to fetch attendance');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> toggleAttendance(String userId) async {
    final userIndex =
        attendanceList.indexWhere((staff) => staff['id'].toString() == userId);

    if (userIndex != -1) {
      final currentStatus = attendanceList[userIndex]['current_attendance'];
      final newStatus = currentStatus == 'Present' ? 'Absent' : 'Present';

      // Temporarily update the UI
      setState(() {
        attendanceList[userIndex]['current_attendance'] = newStatus;
      });
      String id = userId.toString();
      try {
        // API request
        print("^"*20);
        print(userId);
        final response = await _dio.post(
          'https://hotelcrew-1.onrender.com/api/attendance/change/$id/',
          options: Options(headers: {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs'}),
        );
        print(response.statusCode);
        print(response.data);
        if (response.statusCode != 200) {
          // Revert UI on error
          setState(() {
            attendanceList[userIndex]['current_attendance'] = currentStatus;
          });
          throw Exception('Failed to toggle attendance');
        }
      } catch (e) {
        // Revert UI on error
        setState(() {
          attendanceList[userIndex]['current_attendance'] = currentStatus;
        });
        print('Error toggling attendance: $e');
      }
    } else {
      print('User with id $userId not found');
    }
  }

  Future<void> markAll(String status) async {
  try {
    for (var staff in attendanceList) {
      // Check if staff matches filter and needs updating
      if (_matchesFilter(staff) && staff['current_attendance'] != status) {
        // Update attendance locally
        setState(() {
          staff['current_attendance'] = status;
        });

        // Make API request to update attendance
        await _dio.post(
          'https://hotelcrew-1.onrender.com/api/attendance/change/${staff['id'].toString()}/',
          options: Options(
            validateStatus: (status) => status! < 501,
            headers: {
              'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MjA1NDQ5LCJpYXQiOjE3MzI2MTM0NDksImp0aSI6Ijc5YzAzNWM4YTNjMjRjYWU4MDlmY2MxMWFmYTc2NTMzIiwidXNlcl9pZCI6OTB9.semxNFVAZZJreC9NWV7N0HsVzgYxpVG1ysjWG5qu8Xs',
            },
          ),
         // Include data if required
        );
      }
    }
    print('All matching attendance updated to $status');
  } catch (e) {
    print('Error marking all as $status: $e');
  }
}


  bool _matchesFilter(dynamic staff) {
    final matchesDepartment =
        staff['department'] == selectedDepartment || selectedDepartment == 'All Staff';
    return matchesDepartment;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Pallete.pagecolor,
        appBar: AppBar(
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
          ),
          title: Text(
            "Today’s Attendance",
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral950,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterDropdown(
                    screenWidth: screenWidth,
                    value: selectedDepartment,
                    items: <String>[
                      'All Staff',
                      'Housekeeping',
                      'Security',
                      'Maintenance',
                      'Receptionist',
                      'Manager',
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        selectedDepartment = newValue!;
                      });
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Mark All:',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Pallete.neutral900,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      _buildFilterDropdown(
                        screenWidth: screenWidth,
                        value: selectedAttendanceStatus,
                        items: <String>[
                          'None',
                          'Present',
                          'Absent',
                        ],
                        onChanged: (newValue) async {
                          if (newValue != null) {
                            setState(() {
                              selectedAttendanceStatus = newValue;
                            });
                            if (newValue == 'Present' || newValue == 'Absent') {
                              await markAll(newValue);
                              print('called');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  'Staff',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral1000,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Attendance',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral1000,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final staff = attendanceList[index];

                        if (!_matchesFilter(staff)) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:  NetworkImage(staff['user_profile']),
                          ),
                          title: Text(
                            staff['user_name'] ?? 'No Name',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Pallete.neutral900,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            staff['department'] ?? '',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Pallete.neutral900,
                              ),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              print(staff['id'].toString());
                              toggleAttendance(staff['id'].toString());
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: staff['current_attendance'] == 'Present'
                                    ? const Color.fromARGB(255, 179, 255, 181)
                                    : Pallete.pagecolor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Pallete.success100,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                    color: staff['current_attendance'] == 'Present'
                                        ? Pallete.success700
                                        : Pallete.neutral900,
                                  ),
                                ),
                              ),
                            ),
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
}
