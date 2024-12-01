import "../../core/packages.dart";
import '../staff/requestaleave.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaffManageLeavePage extends StatefulWidget {
  const StaffManageLeavePage({super.key});

  @override
  _StaffManageLeavePageState createState() => _StaffManageLeavePageState();
}

class _StaffManageLeavePageState extends State<StaffManageLeavePage> {
  String selectedFilter = "All"; // Default filter
  List<Map<String, dynamic>> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }
String access_token = "";
 Future<void> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null || token.isEmpty) {
    print('Token is null or empty');
  } else {
    setState(() {
      access_token = token;
    });
    print('Token retrieved: $access_token');
  }
}


  Future<void> fetchLeaveRequests() async {
    await getToken(); // Wait for the token to be retrieved
  if (access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }
    const String apiUrl = 'https://hotelcrew-1.onrender.com/api/attendance/apply_leave/';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM1MzU5MTEzLCJpYXQiOjE3MzI3NjcxMTMsImp0aSI6IjEyMTgwNTczODc0ZDRkZDdiYTc3ZDZhODViZGUxZDg4IiwidXNlcl9pZCI6MTczfQ.iLnv1Hs-VyNe_Spd-FgOWLAyPaGOI4nFl3fMaGIRiT0',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Map<String, dynamic>> formattedData = convertLeaveRequests(data['data']);
        setState(() {
          leaveRequests = formattedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Map<String, dynamic>> convertLeaveRequests(List<dynamic> leaveList) {
    List<Map<String, dynamic>> formattedLeaveRequests = [];
    for (var leave in leaveList) {
      formattedLeaveRequests.add({
        'type': leave['leave_type'],
        'department': leave['user_name'],
        'duration': '${leave['duration']} days',
        'dates': '${leave['from_date']} to ${leave['to_date']}',
        'status': leave['status'],
      });
    }
    return formattedLeaveRequests;
  }

  // Filtered leave requests based on the selected filter
  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter == "All") return leaveRequests;
    return leaveRequests.where((request) => request["status"] == selectedFilter).toList();
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
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Pallete.neutral900,
          ),
        ),
        title: Text(
          "Manage Leave",
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
              const SizedBox(height: 16),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "23",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Leave Approved",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/manageleavestaff.svg",
                      height: 112,
                      width: screenWidth * 0.32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 49),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.4389,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestALeavePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primary800,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Request a Leave",
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
                ],
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
              // ListView.builder placed in an appropriate Container
              SizedBox(
                 // Specify a height to avoid rendering issues
                child: ListView.builder(
                  itemCount: filteredRequests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildLeaveRequestCard(
                        filteredRequests[index], screenWidth);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update the filter chip selection
  Widget _buildFilterChips() {
    final filters = ["All", "Pending", "Approved", "Rejected"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  showCheckmark: false,
                  selectedColor: Pallete.neutral200,
                  backgroundColor: Colors.white,
                  label: Text(
                    filter,
                    style: GoogleFonts.montserrat(
                      color: selectedFilter == filter
                          ? Pallete.neutral900
                          : Pallete.neutral700,
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
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLeaveRequestCard(Map<String, dynamic> request, double screenWidth) {
    Color getStatusColor(String status) {
      switch (status) {
        case "Pending":
          return Pallete.warning700;
        case "Approved":
          return Pallete.success600;
        case "Rejected":
          return Pallete.error700;
        default:
          return Pallete.neutral700;
      }
    }

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leave Type
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
                // Duration
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
                // Dates
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
                const SizedBox(height: 8),
                // Status in a Row
              ],
            ),
            Container(
              height: 36,
              width: 94,
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(request["status"]).withOpacity(0.1),
                border: Border.all(color: getStatusColor(request["status"])),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  request["status"],
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(request["status"]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
