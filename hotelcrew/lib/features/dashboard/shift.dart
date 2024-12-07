import '../../core/packages.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import "viewmodel/shiftviewmodel.dart";
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class ShiftSchedulePage extends StatefulWidget {
  const ShiftSchedulePage({super.key});

  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  late Future<List<Map<String, dynamic>>> _staffSchedulesFuture; // Updated to dynamic
  List<Map<String, dynamic>> staffList = []; // Updated to dynamic
  List<Map<String, dynamic>> filteredList = []; // Updated to dynamic

  List<String> selectedDepartments = [];
  List<String> selectedShifts = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments(context);
    _fetchAndSetStaffSchedules();
  }

List<String> dept = [];

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
        List<String> department = []; // Start with 'All Staff'
        department.addAll(staffPerDepartment.keys);
        setState(() {
          dept = department + ['Manager' ,'Receptionist'];
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




  Future<List<Map<String, dynamic>>> _fetchStaffSchedules() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
    return StaffScheduleService().fetchAndTransformStaffSchedules();
  }

  Future<void> _fetchAndSetStaffSchedules() async {
    try {
      _staffSchedulesFuture = _fetchStaffSchedules();
      final staffList = await _staffSchedulesFuture;
      setState(() {
        this.staffList = staffList;
        filteredList = List.from(staffList);
      });
    } catch (error) {
      print("Error fetching staff schedules: $error");
    }
  }

  void applyFilters() {
    setState(() {
      filteredList = staffList.where((staff) {
        final matchesDepartment = selectedDepartments.isEmpty ||
            selectedDepartments.contains(staff['Department']);
        final matchesShift = selectedShifts.isEmpty ||
            selectedShifts.contains(staff['Shift']);
        return matchesDepartment && matchesShift;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedDepartments.clear();
      selectedShifts.clear();
      filteredList = List.from(staffList);
    });
  }

  void showEditShiftBottomSheet(BuildContext context, Map<String, dynamic> staff) {
    final shiftController = TextEditingController(text: staff['Shift']);
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
                        "Edit Shift Schedule",
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
                  
                  // Staff Name Field (Non-editable)
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Staff Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                      ),
                      // enabled: false,
                    ),
                    initialValue: staff['Staff'],
                  ),
                  const SizedBox(height: 38),
                  
                  // Department Field (Non-editable)
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                      ),
                      // enabled: false,
                    ),
                    initialValue: staff['Department'],
                  ),
                  const SizedBox(height: 38),

                  // Shift Dropdown
                  DropdownButtonFormField<String>(
  value: shiftController.text.isNotEmpty &&
          ['Morning', 'Evening', 'Night'].contains(shiftController.text)
      ? shiftController.text
      : null,
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
                  const SizedBox(height: 114),

                  // Update Shift Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          context.loaderOverlay.show();

                          try {
                           await updateStaffShift(
  context: context, // Pass the BuildContext to show Snackbar
  userId: staff['id'], // Updated parameter name to match the function
  newShift: shiftController.text, // No changes here
);

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text("Shift updated successfully."),
                            //     backgroundColor: Colors.green,
                            //   ),
                            // );
                            Navigator.pop(context);
                            _fetchAndSetStaffSchedules(); // Refresh the staff schedules
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error updating shift: $error"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            context.loaderOverlay.hide();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primary800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Schedule Shift',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.5,
                          ),
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

  Future<void> updateStaffShift({
  required BuildContext context,
  required String userId,
  required String newShift,
}) async {
  print("pressed");
print(userId);
print("^"*100);
  const String apiUrl =
      'https://hotelcrew-1.onrender.com/api/edit/schedule_change/'; // API base URL

  // Retrieve the access token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');

  if (accessToken == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Access token not found. Please log in again.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    print("Started");
    final response = await Dio().put(
      '$apiUrl$userId/',
      data: {'shift': newShift},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    print(response.statusMessage);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Show success Snackbar with response data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data['message'] ?? 'Shift updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error Snackbar for unexpected status code
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update shift. Status code: ${response.statusCode}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } on DioException catch (e) {
    if (e.response != null) {
      // Handle API errors and show the error message from the response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data['error'] ?? 'Something went wrong with the request.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Handle network or unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  void showFilterModal() {
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
                                        ? Pallete.neutral00
                                        : Pallete.neutral900,
                                  ),
                                ),
                              ),
                              if (selectedDepartments.contains(department))
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
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
                const SizedBox(height: 32),
                Text(
                  'Shift',
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
                  children: ['Evening', 'Night', 'Morning']
                      .map(
                        (shift) => FilterChip(
                          showCheckmark: false,
                          side: const BorderSide(color: Pallete.neutral200, width: 1),
                          selectedColor: Pallete.primary700,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                shift,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: selectedShifts.contains(shift)
                                      ? Pallete.neutral00
                                      : Pallete.neutral900,
                                ),
                              ),
                              if (selectedShifts.contains(shift))
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.check,
                                    color: Pallete.neutral00,
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                          selected: selectedShifts.contains(shift),
                          onSelected: (bool selected) {
                            setModalState(() {
                              if (selected) {
                                selectedShifts.add(shift);
                              } else {
                                selectedShifts.remove(shift);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 106),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      applyFilters();
                      Navigator.of(context).pop();
                    },
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
          backgroundColor: Pallete.pagecolor,
          elevation: 0,
          title: Text(
            'Shift Schedule',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          actions:[
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: showFilterModal,
                    child: SvgPicture.asset("assets/filter.svg", height: 24, width: 24),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: screenWidth * 0.822,
                        child: TextField(
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Pallete.neutral900,
                            ),
                          ),
                          autofocus: false,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            filled: true,
                            fillColor: Pallete.neutral100,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SvgPicture.asset(
                                'assets/search.svg',
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minHeight: 36,
                              minWidth: 36,
                            ),
                            hintText: 'Search staff...',
                            labelStyle: const TextStyle(color: Pallete.neutral400),
                            hintStyle: const TextStyle(color: Pallete.neutral400),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.neutral200, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.neutral200, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.neutral200, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
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
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _staffSchedulesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error: Unexpected Error',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No staff schedules available',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      );
                    } else {
                      final staffList = snapshot.data!;
                      if (filteredList.isEmpty) {
                        filteredList = List.from(staffList);
                      }
                      return Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Pallete.neutral100,
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                                      border: Border.all(color: Pallete.neutral600, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Staff',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Pallete.neutral100,
                                      border: Border(
                                        top: BorderSide(color: Pallete.neutral600, width: 1),
                                        bottom: BorderSide(color: Pallete.neutral600, width: 1),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Department',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Pallete.neutral100,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                                      border: Border.all(color: Pallete.neutral600, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Shift',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Pallete.neutral900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                : ListView.builder(
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final staff = filteredList[index];
                                      return GestureDetector(
                                        onTap: () => showEditShiftBottomSheet(context, staff),
                                        child: Container(
                                          height: 56,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(color: Pallete.neutral200, width: 1),
                                              right: BorderSide(color: Pallete.neutral200, width: 1),
                                              bottom: BorderSide(color: Pallete.neutral200, width: 1),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 56,
                                                  decoration: const BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(color: Pallete.neutral200, width: 1),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(
                                                    staff['Staff']!,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Pallete.neutral900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 56,
                                                  decoration: const BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(color: Pallete.neutral200, width: 1),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(
                                                    staff['Department']!,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Pallete.neutral900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(color: Pallete.neutral200, width: 1),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(
                                                    staff['Shift']!,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Pallete.neutral900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
