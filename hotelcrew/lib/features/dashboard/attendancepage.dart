import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/packages.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Dio _dio = Dio();
  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/list/';

  List<dynamic> attendanceList = [{
    'user_name': 'John Doe',
    'department': 'Housekeeping',
    'attendance': 'Present', // or 'Absent'
  },
  {
    'user_name': 'Jane Smith',
    'department': 'Receptionist',
    'attendance': 'Absent',
  },
  {
    'user_name': 'David Johnson',
    'department': 'Security',
    'attendance': 'Present',
  },
  {
    'user_name': 'Emily Davis',
    'department': 'Maintenance',
    'attendance': 'Absent',
  },
  {
    'user_name': 'Michael Brown',
    'department': 'Manager',
    'attendance': 'Present',
  },];
  String selectedDepartment = 'All Staff';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchAttendanceData();
  }

  Future<void> fetchAttendanceData({String? department}) async {
    
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          validateStatus: (status) => status! < 501,
          headers: {
            'Authorization': 'Bearer <YOUR_ACCESS_TOKEN>',
          },
        ),
        queryParameters: department != null ? {'department': department} : null,
      );

      if (response.statusCode == 200) {
        setState(() {
          attendanceList = response.data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch attendance');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
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
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900)),
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
            // Department Filter Dropdown
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Container(
                height: 30,
                width: screenWidth * 0.39,
                child: Card(
                  color: Pallete.pagecolor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Pallete.neutral400, width: 1),
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
                            value: selectedDepartment,
                            borderRadius: BorderRadius.circular(4),
                            menuWidth: screenWidth * 0.39,
                            elevation: 0,
                            alignment: Alignment.center,
                            isExpanded: true,
                            icon: SvgPicture.asset("assets/dropdownarrow.svg"),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartment = newValue!;
                              });
                              // fetchAttendanceData(department: newValue != 'All Staff' ? newValue : null);
                            },
                            items: <String>[
                              'All Staff',
                              'Housekeeping',
                              'Security',
                              'Maintenance',
                              'Receptionist',
                              'Manager'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
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
            ),
            const SizedBox(height: 25),
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Staff",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral1000,
                      ),
                    ),
                  ),
                  Text(
                    "Status",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral1000,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Attendance List
            Expanded(
              child: 
              // isLoading
              //     ? const Center(child: CircularProgressIndicator())
              //     : 
              ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final item = attendanceList[index];
                        if(item['department'] != selectedDepartment && selectedDepartment != 'All Staff') {
                          return const SizedBox.shrink();
                        }
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            item['user_name'] ?? 'No Name',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Pallete.neutral900,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            item['department'] ?? '',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Pallete.neutral900,
                              ),
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: item['attendance'] == 'Present'
                                  ? Pallete.success100
                                  : Pallete.error100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Text(
                              item['attendance'] == 'Present' ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: item['attendance'] == 'Present'
                                    ? Pallete.success700
                                    : Pallete.error800,
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
}
