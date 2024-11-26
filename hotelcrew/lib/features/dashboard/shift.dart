import '../../core/packages.dart';
import 'model/shiftmodel.dart';
import "viewmodel/shiftviewmodel.dart";
class ShiftSchedulePage extends StatefulWidget {
  const ShiftSchedulePage({super.key});

  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  // Initial dummy list
  late Future<List<Map<String, String>>> _staffSchedules;
  List<Map<String, String>> staffList = [
    {'Staff': 'Aakash', 'Department': 'Housekeeping', 'Shift': 'Day'},
    {'Staff': 'Amit', 'Department': 'Maintenance', 'Shift': 'Night'},
    {'Staff': 'Tushar', 'Department': 'Housekeeping', 'Shift': 'Day'},
    {'Staff': 'Krish', 'Department': 'Security', 'Shift': 'Day'},
    {'Staff': 'Sanskriti', 'Department': 'Maintenance', 'Shift': 'Night'},
    {'Staff': 'Priya', 'Department': 'Receptionist', 'Shift': 'Day'},
    {'Staff': 'Supriya', 'Department': 'Kitchen', 'Shift': 'Night'},
  ];
late Future<List<Map<String, String>>> _staffSchedulesFuture;


//   Future<void> fetchStaffData() async {
//   Make API call here and update `staffList` with response data
//   For example:
//   final response = await Dio().get('API_ENDPOINT');
//   setState(() {
//     staffList = response.data;
//     filteredList = List.from(staffList);
//   });
// }
Future<List<Map<String, String>>> _fetchStaffSchedules() async{
   await Future.delayed(Duration(seconds: 2)); // Simulating a delay
  return StaffScheduleService().fetchAndTransformStaffSchedules();
}

  // Filtered list for updates
  List<Map<String, String>> filteredList = [];

  // Selected filters
  List<String> selectedDepartments = [];
  List<String> selectedShifts = [];

  @override
  void initState () {
    super.initState();
    // Initially, the filtered list is the same as the full staff list
  //   _staffSchedules = StaffScheduleService().fetchAndTransformStaffSchedules();
  //   print(_staffSchedules);
  _fetchAndSetStaffSchedules();
  // filteredList = List.from(staffList);
    //fetchStaffData();
    //  _fetchStaffSchedules(); 
    
    
  }


Future<void> _fetchAndSetStaffSchedules() async {
  try {
    // Show the global overlay loader
    // GlobalOverlayLoader.show();

    // Fetch staff schedules from the service
    _staffSchedulesFuture = _fetchStaffSchedules(); 
    final staffList = await _staffSchedulesFuture;
        filteredList = List.from(staffList);

    // Update the state with fetched data
    setState(() async{
      // _staffSchedules = await fetchedSchedules;
      // staffList = _staffSchedules;
      filteredList = List.from(staffList); // Initialize the filtered list
    });

    print(_staffSchedules);
  } catch (error) {
    // Handle errors gracefully
    print("Error fetching staff schedules: $error");
  } finally {
    // Hide the global overlay loader
    // GlobalOverlayLoader.hide();
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
    filteredList = List.from(staffList); // Reset to the full list
  });
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
              // Modal Header
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
                      resetFilters(); // Invoke the reset function properly
                    },
                  ),
                ],
              ),
              const SizedBox(height: 44),

              // Department Filters
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

              // Shift Filters
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
                children: ['Day', 'Night', 'Morning']
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

              // Apply Filters Button
              ElevatedButton(
                onPressed: () {
                  applyFilters(); // Apply filters when pressed
                  Navigator.of(context).pop(); // Close the modal
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Show Results'),
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
          backgroundColor: Pallete.pagecolor,
          elevation: 0,
          // iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Shift Schedule',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          actions: [
            IconButton(
              icon: 
                // padding: EdgeInsets.only(right: 16),
                 SvgPicture.asset(
                  'assets/message.svg', // Replace with your SVG icon
                  height: 40,
                  width: 40,
                ),
              
              onPressed: () {
                print("announcement");
              },
            ),
          ],
        ),
      
      //showFilterModal
      
      
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 32.0),
          child: Column(
            
            children: [
              // Search bar (optional, can be removed)
              Row(children: [
                InkWell(
                  onTap: showFilterModal,
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
  child: FutureBuilder<List<Map<String, String>>>(
    future: _staffSchedulesFuture, // Future for fetching data
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show a loader while waiting for the data
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        // Show an error message if something goes wrong
        return Center(
          child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        // Handle the case where no data is returned
        return const Center(
          child: Text(
            'No staff schedules available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        );
      } else {
        // Data is successfully fetched
        final staffList = snapshot.data!;

        // Initialize the filteredList if it's not already set
        if (filteredList.isEmpty) {
          filteredList = List.from(staffList);
        }

        return Column(
          children: [
            // Table header
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
            // Table content
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
                        return Container(
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

      ],),),),
    );
  }
}
