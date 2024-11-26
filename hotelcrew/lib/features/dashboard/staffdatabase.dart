import '../../core/packages.dart';

// List<Map<String, String>> staffList = [
//     {"name": "John Doe", "email": "abcd123@gmail.com", "department": "Housekeeping", "salary": "15000"},
//     {"name": "Aakash", "email": "abcd123@gmail.com", "department": "Receptionist", "salary": "18000"},
//     {"name": "Amit", "email": "abcd123@gmail.com", "department": "Kitchen", "salary": "15000"},
//   ];


class StaffDatabasePage extends StatefulWidget {
  const StaffDatabasePage({super.key});

  @override
  _StaffDatabasePageState createState() => _StaffDatabasePageState();
}

final inputDecoration = InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  labelStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500),
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.indigo[800], // Replace with Pallete.primary800
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  padding: const EdgeInsets.symmetric(vertical: 14),
);

void showAddStaffBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)), // Bottom sheet radius
    ),
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Close Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Staff",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral950,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Pallete.neutral950),
                      onPressed: () => Navigator.pop(context), // Close bottom sheet
                    ),
                  ],
                ),
                const SizedBox(height: 38), // Spacing between title row and first text field
                // Styled TextFields
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Department",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Salary",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                // Styled Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.primary800, // Button color
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Button radius
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0), // Padding
                    ),
                    child: Text(
                      "Add Staff",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral00, // Button text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


class _StaffDatabasePageState extends State<StaffDatabasePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  // Initial dummy list
List<Map<String, String>> staffList = [
  {
    'id': "1",
    'Staff': 'Aakash',
    'Department': 'Housekeeping',
    'Email': 'aakash@testmail.com',
    'Salary': "3200",
    "account": "1234567890",
    'Status': 'Paid',
    'TransactionId': 'XFD8KLMO23'
  },
  {
    'id': "2",
    'Staff': 'Amit',
    'Department': 'Maintenance',
    'Email': 'amit@fakemail.com',
    "account": "1234567890",
    'Salary': "4500",
    'Status': 'Not Paid',
    'TransactionId': "None"
  },
  {
    'id': "3",
    'Staff': 'Tushar',
    'Department': 'Housekeeping',
    'Email': 'tushar@example.com',
    "account": "1234567890",
    'Salary': "2900",
    'Status': 'Transaction Error',
    'TransactionId': "None"
  },
  {
    'id': "4",
    'Staff': 'Krish',
    'Department': 'Security',
    'Email': 'krish@testmail.com',
    "account": "1234567890",
    'Salary': "3100",
    'Status': 'Paid',
    'TransactionId': 'GHD76KLM29'
  }
  // Add more staff here as needed
];


  //Future<void> fetchStaffData() async {
  // Make API call here and update `staffList` with response data
  // For example:
  // final response = await Dio().get('API_ENDPOINT');
  // setState(() {
  //   staffList = response.data;
  //   filteredList = List.from(staffList);
  // });
//}


  // Filtered list for updates
  List<Map<String, String>> filteredList = [];

  // Selected filters
  List<String> selectedDepartments = [];
  // List<String> selectedStatus = [];

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list is the same as the full staff list
    filteredList = List.from(staffList);
    //fetchStaffData();
  }

  void applyFilters() {
  setState(() {
    filteredList = staffList.where((staff) {
      final matchesDepartment = selectedDepartments.isEmpty ||
          selectedDepartments.contains(staff['Department']);
      return matchesDepartment;
    }).toList();
  });

  // Close filter modal only if filters are applied successfully
  Navigator.pop(context);
}

void resetFilters() {
  setState(() {
    selectedDepartments.clear();
    filteredList = List.from(staffList);
  });
}
void showFilterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Pallete.pagecolor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Pallete.neutral950,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetFilters();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 44),
              Text(
                'Department',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral900,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8.0,
                children: ['Housekeeping', 'Maintenance', 'Kitchen', 'Security']
                    .map(
                      (department) => FilterChip(
                        side: const BorderSide(color: Pallete.neutral200, width: 1),
                        selectedColor: Pallete.primary700,
                        showCheckmark: false,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              department,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: selectedDepartments.contains(department)
                                      ? Pallete.neutral00 // Color when selected
                                      : Pallete.neutral900, // Color when not selected
                                ),
                              ),
                            ),
                            if (selectedDepartments.contains(department))
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0), // Spacing for icon
                                child: Icon(
                                  Icons.check,
                                  color: Pallete.neutral00,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                        selected: selectedDepartments.contains(department),
                        onSelected: (bool selected) {
                          setModalState(() {
                            if (selected) {
                              selectedDepartments.add(department);
                            } else {
                              selectedDepartments.remove(department);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 106),
              ElevatedButton(
                onPressed: applyFilters,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Show Results'),
              ),
              buildMainButton(
                context: context,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                buttonText: 'Show Results',
                onPressed: () {
                  applyFilters();  // Apply the filters when the button is pressed
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900)),
          title: Text(
            "Database",
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral950,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showAddStaffBottomSheet(context);
              },
              icon: const Icon(Icons.add, color: Pallete.neutral900),
            ),
          ],
        ),
//showFilterModal


      body: 
        Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            
            children: [
              // Search bar (optional, can be removed)
              Row(children: [
                InkWell(
                  onTap: () { 
                    showFilterModal(context);},
                  child: SvgPicture.asset("assets/filter.svg", height: 24, width: 24)),
          
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      // height: 36,
                      width: screenWidth * 0.822,
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Pallete.neutral900,
                            ),
                          )
          ,autofocus: false,
          decoration: InputDecoration(
            isCollapsed: true, // Ensures compact height
            filled: true,
            fillColor: Pallete.neutral100, // Background color (same for focus and unfocus)
            prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing
        child: SvgPicture.asset(
          'assets/search.svg', // Path to your SVG file
          height: 20.0,
          width: 20.0,
        ),
            ),
            prefixIconConstraints: const BoxConstraints(
        minHeight: 36,
        minWidth: 36, // Ensure icon is properly sized
            ),
            hintText: 'Search staff...',
            labelStyle: const TextStyle(
        
        color: Pallete.neutral400), // Optional label text color
            hintStyle: const TextStyle(
        color: Pallete.neutral400),
        // border: InputBorder.none, // Optional hint text color
            border: OutlineInputBorder(
        borderSide: const BorderSide(color: Pallete.neutral200, width: 1), // Border style
        borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
            ),
            enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Pallete.neutral200, width: 1), // Border when not focused
        borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Pallete.neutral200, width: 1), // Border when focused
        borderRadius: BorderRadius.circular(8),
            ),// Removes the outline border
            // enabledBorder: InputBorder(borderSide: BorderSide(color: Pallete.neutral200,width: 1)), // Removes enabled border
            // focusedBorder: InputBorder(borderSide: BorderSide(color: Pallete.neutral200,width: 1)), // Removes focused border
          ),
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          onChanged: (value) {
            setState(() {
        filteredList = staffList
            .where((staff) => staff['Staff']!
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
            });
          },
        ),
                    ),
                  ),
                ),
          
              ],
                
              ),
              const SizedBox(height: 35),
              // Table header
             
              
              Expanded(
          child: filteredList.isEmpty
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
        : Column(mainAxisSize: MainAxisSize.min,
            children: [
              // Table headers with vertical lines
             
          
              // Table header with vertical lines
             
             Expanded(
            
          child: ListView.builder(
            itemCount: filteredList.length,
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
        final staff = filteredList[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
        
        
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  left: BorderSide(color: Pallete.primary300,width: 4)
                )
              ), // Ensures full-width occupation
              child: StaffPaymentCard(
                staffName: staff['Staff'] ?? "",
                email: staff['Email'] ?? "",
                salary: staff['Salary'] ?? "",
                department: staff['Department'] ?? "",
                screenWidth: screenWidth,
                
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
            },
          ),
        ),
        
        
            ],
          ),
            
          
        ),
            ],),),
      );
  }
}




class StaffPaymentCard extends StatelessWidget {
  final String staffName;
  final String email;
  final String salary;
  final String department;
  final double screenWidth;

  StaffPaymentCard({
    super.key,
    required this.staffName,
    required this.email,
    required this.salary,
    required this.department,
    required this.screenWidth,
  });
final inputDecoration = InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  labelStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500),
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.indigo[800], // Replace with Pallete.primary800
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  padding: const EdgeInsets.symmetric(vertical: 14),
);

// Add Staff Bottom Sheet

// Edit Staff Bottom Sheet
void showEditStaffBottomSheet(BuildContext context,
    {required String name, required String email, required String department, required String salary}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)), // Bottom sheet radius
    ),
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Close Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Staff",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral950,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Pallete.neutral950),
                    onPressed: () => Navigator.pop(context), // Close bottom sheet
                  ),
                ],
              ),
              const SizedBox(height: 38), // Spacing between title row and first text field
              // Styled TextFields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                  ),
                ),
                controller: TextEditingController(text: name),
              ),
              const SizedBox(height: 38),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                  ),
                ),
                controller: TextEditingController(text: email),
              ),
              const SizedBox(height: 38),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                  ),
                ),
                controller: TextEditingController(text: department),
              ),
              const SizedBox(height: 38),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Salary",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                  ),
                ),
                controller: TextEditingController(text: salary),
              ),
              const SizedBox(height: 38),
              // Styled Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary800, // Button color
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Button radius
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0), // Padding
                  ),
                  child: Text(
                    "Update Staff Details",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral00, // Button text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void _deleteProfile(String email) {
    // Simulate deletion logic here
    print("Staff with email $email has been deleted.");
  }

  void _navigateToUpdateProfile(String email) {
    // Navigation logic for editing details
    print("Navigating to update profile for email: $email");
  }

  void showConfirmationDialog(BuildContext context, String staffName, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Dialog shape
        title: Column(
          children: [
            SvgPicture.asset("assets/deletewarning.svg",height:48,width:48), // Warning Icon
            const SizedBox(height: 16),
            Text(
              'Are you sure?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral950,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove $staffName\'s details?',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Pallete.neutral700,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Delete Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.383,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary800, // Delete button color
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Button radius
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    onDelete(); // Perform the delete action
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral00, // Button text color
                    ),
                  ),
                ),
              ),
              // Cancel Button

              const SizedBox(height:12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.383,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Button radius
                    ),
                    side: const BorderSide(color: Pallete.primary800, width: 1), // Border color
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Pallete.primary800, // Button text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.primary50,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Pallete.primary300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30,
            ),
            SizedBox(width: screenWidth * 0.059),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Name: ',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral950,
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: staffName,
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
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Email: ',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: email,
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
                        text: 'Department: ',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: department,
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
                        text: 'Salary: ',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Pallete.neutral950,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Rs. $salary',
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
            const Spacer(),
            SizedBox(
              height:24,
              width:24,
              child: PopupMenuButton<String>(
                color: Pallete.neutral00,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(color: Pallete.neutral200, width: 1),
                ),
                onSelected: (value) {
                  if (value == 'Edit') {
                   showEditStaffBottomSheet(
  context,
  name: staffName,
  email: email,
  department: department,
  salary: salary,
);

                  } else if (value == 'Delete') {
                    showConfirmationDialog(context, staffName, () {
                      _deleteProfile(email);
                    });
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_horiz),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
