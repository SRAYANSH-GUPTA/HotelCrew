import "../../core/packages.dart";
import 'attendancepage.dart';

class LeaveAttendancePage extends StatefulWidget {
  const LeaveAttendancePage({super.key});

  @override
  _LeaveAttendancePageState createState() => _LeaveAttendancePageState();
}

class _LeaveAttendancePageState extends State<LeaveAttendancePage> {
  // Add more sample data for testing filters
  final List<Map<String, dynamic>> leaveRequests = [
    {
      "id": "001",
      "name": "John Doe",
      "type": "Sick Leave",
      "department": "Engineering",
      "duration": "2 days",
      "dates": "15 Mar - 16 Mar",
      "status": "Pending"
    },
    {
      "id": "002",
      "name": "Jane Smith",
      "type": "Annual Leave",
      "department": "HR",
      "duration": "3 days",
      "dates": "20 Mar - 22 Mar",
      "status": "Approved"
    },
    {
      "id": "003",
      "name": "Bob Wilson",
      "type": "Sick Leave",
      "department": "Sales",
      "duration": "1 day",
      "dates": "18 Mar",
      "status": "Rejected"
    },
  ];

  String selectedFilter = "All";

  // Add this method to filter requests
  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter == "All") {
      return leaveRequests;
    }
    return leaveRequests.where((request) => 
      request["status"] == selectedFilter
    ).toList();
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
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOverviewCard("Present", "45", Pallete.success200),
                _buildOverviewCard("Absent", "5", Pallete.error200),
                _buildOverviewCard("Leave", "3", Pallete.warning200),
              ],
            ),
            const SizedBox(height: 24),
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
                child: Text("View Full Attendance",
                
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  height:1.5,
                  color: Pallete.neutral00,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Leave Requests",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                height:1.5,
                color: Pallete.neutral950,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) => _buildLeaveRequestCard(filteredRequests[index],screenWidth),
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
          
                    label: Text(filter
                    ,style: GoogleFonts.montserrat(
                // fontSize: 14,
                // height:1.5,
                
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

  Widget _buildLeaveRequestCard(Map<String, dynamic> request,double screenWidth) {
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
          // Name at the top
          Text(
            request["name"],
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Leave details and buttons in a row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leave details section
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

              // Approve and Reject buttons section
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: screenWidth * 0.261,
                    child: ElevatedButton(
                      onPressed: () {
                        // Approve logic
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                         shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
        side: const BorderSide(color: Pallete.success600,width: 1),
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
      // Reject logic
    },
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Pallete.error700, width: 1), // Different border color
      ),
      backgroundColor: Colors.white, // Different background color
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
        color: Pallete.error700, // Text matches the border color
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