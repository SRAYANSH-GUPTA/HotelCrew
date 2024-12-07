import '../../core/packages.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

// List<Map<String, String>> staffList = [
//     {"name": "John Doe", "email": "abcd123@gmail.com", "department": "Housekeeping", "Shift": "15000"},
//     {"name": "Aakash", "email": "abcd123@gmail.com", "department": "Receptionist", "Shift": "18000"},
//     {"name": "Amit", "email": "abcd123@gmail.com", "department": "Kitchen", "Shift": "15000"},
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





class _StaffDatabasePageState extends State<StaffDatabasePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  // Initial dummy list
  void onDelete() {
    fetchAttendanceData();  // Refresh the list after deletion
  }

void showAddStaffBottomSheet(BuildContext context) {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();
  final shiftController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder( 
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)), // Bottom sheet radius
    ),
    isScrollControlled: true,
    builder: (context) {
      return GlobalLoaderOverlay(
        child: SafeArea(
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
                     controller: nameController, // Add controller
          validator: (value) => value?.isEmpty ?? true ? 'This is required': null,
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
                    controller: emailController, // Add controller
          validator: (value) => value?.isEmpty ?? true ? 'This is required' : null,
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
                    controller: departmentController, // Add controller
          validator: (value) => value?.isEmpty ?? true ? 'This is required' : null,
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
                  DropdownButtonFormField<String>(
  value: shiftController.text.isNotEmpty ? shiftController.text : null,
  items: const [
    DropdownMenuItem(
      value: 'Morning',
      child: Text('Morning'),
    ),
    DropdownMenuItem(
      value: 'Evening',
      child: Text('Evening'),
    ),
    DropdownMenuItem(
      value: 'Night',
      child: Text('Night'),
    ),
  ],
  onChanged: (value) {
    shiftController.text = value ?? '';  // Update the controller with the selected value
  },
  validator: (value) => value?.isEmpty ?? true ? 'This is required' : null,
  decoration: InputDecoration(
    labelText: "Shift",
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
                        print("pressed");
                        if (true) {
                          print("done");
                            addStaff(
                              context,
                              name: nameController.text,
                              email: emailController.text,
                              department: departmentController.text,
                              shift: shiftController.text,
                            );
                          }
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
        ),
      );
    },
  );
}

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
List<String> dept = ['Housekeeping', 'Maintenance', 'Kitchen', 'Security'];

void fetchDepartments(BuildContext context) async {
  final Uri url = Uri.parse('https://hotelcrew-1.onrender.com/api/edit/department_list/'); // Replace with your actual endpoint
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token'); // Fetch access token from shared preferences

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        final Map<String, dynamic> staffPerDepartment =
            responseData['staff_per_department'] ?? {};
        List<String> departments = []; // Start with 'All Staff'
        departments.addAll(staffPerDepartment.keys);
        setState(() {
          dept = departments + ['Manager','Receptionist'];
        });
        
      } else {
        throw Exception('Unexpected response: ${responseData['message']}');
      }
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch departments.');
    }
  } catch (error) {
    // Show error in Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );

  }
}


String access_token = "";


  Future<void> addStaff(BuildContext context, {
    
  required String name,
  required String email,
  required String department,
  required String shift,
}) async {
  const String url = 'https://hotelcrew-1.onrender.com/api/edit/create/';
   SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  final Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {
    'user_name': name,
    'email': email,
    'department': department,
    'shift': shift,
    'role': 'Staff'
  };
  print(body);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    print(response.body);

    if (response.statusCode == 201) {
      print("hello");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff added successfully')),
      );
      Navigator.pop(context);
      // Refresh staff list
      fetchAttendanceData();
    } 
    else if(response.statusCode == 400)
    {
      Navigator.pop(context);
      String error = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
    else {
      throw Exception('Failed to add staff');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
List<Map<String, String>> staffList = [];
 
final Dio _dio = Dio();
  // Filtered list for updates
  List<Map<String, String>> filteredList = [];

  // Selected filters
  List<String> selectedDepartments = [];
  // List<String> selectedStatus = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments(context);
    // Initially, the filtered list is the same as the full staff list
    fetchAttendanceData();
    filteredList = List.from(staffList);
    //fetchStaffData();
  }
  bool isLoading = false;
Future<void> fetchAttendanceData({String? department}) async {
  setState(() {
    isLoading = true;
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

    if (response.statusCode == 200) {
      List<Map<String, String>> convertedStaffList = [];
      
      // Safely convert dynamic values to strings
      for (var item in (response.data as List)) {
        convertedStaffList.add({
          'id': (item['id'] ?? '').toString(),
          'Staff': (item['user_name'] ?? '').toString(),
          'Department': (item['department'] ?? '').toString(),
          'Email': (item['email'] ?? '').toString(),
          'Shift': (item['shift'] ?? '').toString(),
          'account': (item['account_number'] ?? '').toString(),
          'Status': (item['payment_status'] ?? 'Not Paid').toString(),
          'TransactionId': (item['transaction_id'] ?? 'None').toString(),
          'User_profile': (item['user_profile'] ?? 'None').toString()
        });
      }

      setState(() {
        staffList = convertedStaffList;
        filteredList = List.from(staffList);
        isLoading = false;
      });

      print('Staff list updated: ${staffList.length} records');
    } else {
      throw Exception('Failed to fetch attendance');
    }
  } catch (e) {
    print('Error fetching attendance data: $e');
    setState(() {
      isLoading = false;
    });
  }
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
                children: dept
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
              SizedBox(
                width :double.infinity,
                child: ElevatedButton(
                  onPressed: applyFilters,
                  style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.primary800, // Button color
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Button radius
                          ),
                          // padding: const EdgeInsets.symmetric(vertical: 14.0), // Padding
                        ),
                        child: Text(
                          "Show Results",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Pallete.neutral00, // Button text color
                          ),
                        ),
                ),
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
    return GlobalLoaderOverlay(
      child: Scaffold(
        backgroundColor: Pallete.pagecolor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          foregroundColor: Pallete.pagecolor,
          backgroundColor: Pallete.pagecolor,
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900)),
            title: Text(
              "Staff Details",
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
          minHeight: 44,
          minWidth: 36, // Ensure icon is properly sized
              ),
              hintText: 'Search for staff details',
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
            
                ],
                  
                ),
                const SizedBox(height: 35),
                // Table header
               
                
                Expanded(
            child: filteredList.isEmpty
          ? Center(
              child: SvgPicture.asset(
                'assets/nostaff.svg',
                height: 272,
                width: 293.03,
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
                  Shift: staff['Shift'] ?? "",
                  department: staff['Department'] ?? "",
                  user_profile: staff['User_profile'] ?? "",
                  screenWidth: screenWidth,
                  id: staff['id'] ?? "",
                  onDelete: () => fetchAttendanceData(),
                  
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
        ),
    );
  }
}




class StaffPaymentCard extends StatelessWidget {
  final String staffName;
  final String email;
  final String Shift;
  final String department;
  final double screenWidth;
  final String user_profile;
   final String id;
    final VoidCallback onDelete;

  StaffPaymentCard({
    super.key,
    required this.staffName,
    required this.email,
    required this.Shift,
    required this.department,
    required this.screenWidth,
    required this.user_profile,
    required this.id,
    required this.onDelete,
  });
Future<void> updateStaff(BuildContext context, {
  required String userId,
  required String name,
  required String email,
  required String department,
  required String shift,
}) async {
  final String url = 'https://hotelcrew-1.onrender.com/api/edit/update/$userId/';
   SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
  
  final Map<String, String> headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> body = {
    'user_name': name,
    'email': email,
    'department': department,
    'shift': shift,
    'role': 'Staff',
    'salary': '0',  // Default value
    'upi_id': ''    // Default value
  };
  // Navigator.pop(context);
  
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
     final Map<String, dynamic> responseMap = jsonDecode(response.body);

  // Extract the message
  final String message = responseMap['message'] ?? 'Something went wrong';

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff updated successfully')),
      );
      // Navigator.pop(context);
      onDelete(); // Refresh list using the callback
    }
    
    else if (response.statusCode == 403) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),
         behavior: SnackBarBehavior.floating,
         
        ),
        
      );
      Navigator.pop(context);
      onDelete(); // Refresh list using the callback
    }
     else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to update staff');
    }
  } catch (e) {
    print('Error updating staff: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
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

// Add Staff Bottom Sheet

// Edit Staff Bottom Sheet
void showEditStaffBottomSheet(BuildContext context,
    {required String name, required String email, required String department, required String Shift}) {
  final nameController = TextEditingController(text: name);
  final emailController = TextEditingController(text: email);
  final departmentController = TextEditingController(text: department);
  final shiftController = TextEditingController(text: Shift);
  final formKey = GlobalKey<FormState>();

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
          child: Form(
            key: formKey,
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
                
                // Name Field
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
                  controller: nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 38),
                
                // Email Field
                TextFormField(
                  controller: emailController,
                  validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
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

                // Department Field
                TextFormField(
                  controller: departmentController,
                  validator: (value) => value?.isEmpty ?? true ? 'Department is required' : null,
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

                // Shift Dropdown
                SizedBox(
                  width: screenWidth * 0.9, // Ensures the dropdown has the same width as the text fields
                  child: DropdownButtonFormField<String>(
                    value: shiftController.text.isNotEmpty ? shiftController.text : null,
                    items: const [
                      DropdownMenuItem(
                        value: 'Morning',
                        child: Text('Morning'),
                      ),
                      DropdownMenuItem(
                        value: 'Evening',
                        child: Text('Evening'),
                      ),
                      DropdownMenuItem(
                        value: 'Night',
                        child: Text('Night'),
                      ),
                    ],
                    onChanged: (value) {
                      shiftController.text = value ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Shift",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.primary700, width: 1.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 38),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                  

                        await updateStaff(
                          context,
                          userId: id,
                          name: nameController.text,
                          email: emailController.text,
                          department: departmentController.text,
                          shift: shiftController.text,
                        );
                      }
                      Navigator.pop(context);
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
        ),
      );
    },
  );
}



 Future<void> deleteItem(int id) async {
    final String url = 'https://hotelcrew-1.onrender.com/api/edit/delete/$id/';
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
    print(id);
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 204) {
        print('Staff member deleted successfully.');
      } else {
        print('Failed to delete staff member. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while deleting staff member: $e');
    }
  }

  // Update _deleteProfile method
  void _deleteProfile(String email) async {
    try {
      int userId = int.parse(id); // Convert string id to int
      await deleteItem(userId);
    onDelete();
    } catch (e) {
      print('Error in _deleteProfile: $e');
    }
  }

  // Rest of the class remains the same


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
          CircleAvatar(
            backgroundImage: NetworkImage(user_profile),
            radius: 30,
          ),
          SizedBox(width: screenWidth * 0.059),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
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
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
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
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
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
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Shift: ',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral950,
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: Shift,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Pallete.neutral950,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            // height: 24,
            // width: 24,
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
  Shift: Shift,
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
