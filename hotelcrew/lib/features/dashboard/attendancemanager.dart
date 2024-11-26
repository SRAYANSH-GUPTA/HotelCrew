import 'package:dio/dio.dart';
import '../../core/packages.dart';

 // Ensure you have the `Pallete` defined in your project

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

  // Toggle attendance status for a specific staff
  Future<void> toggleAttendance(String userId) async {
    final userIndex =
        attendanceList.indexWhere((staff) => staff['user_id'].toString() == userId);

    if (userIndex != -1) {
      final currentStatus = attendanceList[userIndex]['attendance'];
      final newStatus = currentStatus == 'Present' ? 'Absent' : 'Present';

      // Temporarily update the UI
      setState(() {
        attendanceList[userIndex]['attendance'] = newStatus;
      });
      return;
      try {
        // API request
        await _dio.post(
          '$attendanceApiUrl/toggle',
          data: {
            'user_id': userId,
            'status': newStatus,
          },
          options: Options(headers: {'Authorization': 'Bearer <YOUR_ACCESS_TOKEN>'}),
        );
      } catch (e) {
        // Revert UI on error
        setState(() {
          attendanceList[userIndex]['attendance'] = currentStatus;
        });
        print('Error toggling attendance: $e');
      }
    } else {
      print('User with id $userId not found');
    }
  }

  // Mark all filtered staff as Present or Absent
  Future<void> markAll(String status) async {
  setState(() {
    for (var staff in attendanceList) {
      if (_matchesFilter(staff)) {
        print('Marking ${staff['user_name']} as $status');
        staff['attendance'] = status; // Update attendance locally
      }
    }
  });
  print('MarkAll function invoked with status: $status');

  return;
  try {
    await _dio.post(
      '$attendanceApiUrl/mark-all',
      data: {
        'status': status,
        'staffIds': attendanceList
            .where(_matchesFilter)
            .map((staff) => staff['user_id'])
            .toList(),
      },
      options: Options(headers: {'Authorization': 'Bearer <YOUR_ACCESS_TOKEN>'}),
    );
  } catch (e) {
    print('Error marking all as $status: $e');
  }
}

  // Filter logic for department and attendance status
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
            // Filter Row
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Department Filter Dropdown
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
              
                  // Attendance Status Dropdown
                  Row(
                    children:[ Text(
                      'Mark All:',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Pallete.neutral900,
                          height: 1.5,
                        ),
                      ),
                      
                    ),const SizedBox(width: 5),
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
                        print('called');// Mark all filtered staff as "Present" or "Absent"
                      }
                    }
                                    },
                                  ),],
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
            // Attendance List
            Expanded(
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final staff = attendanceList[index];

                  if (!_matchesFilter(staff)) {
                    return const SizedBox.shrink();
                  }

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
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
                        toggleAttendance(staff['user_id']);
                      },
                      child: Container(
  width: 32,  // Set width and height to make it circular
  height: 32,
  decoration: BoxDecoration(
    color: staff['attendance'] == 'Present'
        ? Pallete.success500
        : Pallete.pagecolor, // Background color
    shape: BoxShape.circle,
    border: Border.all(
      color: Pallete.success100,  // Border color for "Absent"
      width: 1, // Adjust border width
    ),
  ),
  child: Center(
    child: Text(
      'P', // Display the letter "P"
      style: TextStyle(
        fontSize: 14,
        height: 1.5, // Adjust font size as needed
        fontWeight: FontWeight.w400,
        color: staff['attendance'] == 'Present'
            ? Pallete.success700 // Text color for "Present"
            : Pallete.neutral900,  // Text color for "Absent"
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
