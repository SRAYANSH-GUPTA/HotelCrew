import 'package:flutter/material.dart';
import '../../core/packages.dart';

class ShiftSchedulePage extends StatefulWidget {
  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  // Initial dummy list
  List<Map<String, String>> staffList = [
    {'Staff': 'Aakash', 'Department': 'Housekeeping', 'Shift': 'Day'},
    {'Staff': 'Amit', 'Department': 'Maintenance', 'Shift': 'Night'},
    {'Staff': 'Tushar', 'Department': 'Housekeeping', 'Shift': 'Day'},
    {'Staff': 'Krish', 'Department': 'Security', 'Shift': 'Day'},
    {'Staff': 'Sanskriti', 'Department': 'Maintenance', 'Shift': 'Night'},
    {'Staff': 'Priya', 'Department': 'Receptionist', 'Shift': 'Day'},
    {'Staff': 'Supriya', 'Department': 'Kitchen', 'Shift': 'Night'},
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
  List<String> selectedShifts = [];

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
      final matchesShift =
          selectedShifts.isEmpty || selectedShifts.contains(staff['Shift']);
      return matchesDepartment && matchesShift;
    }).toList();
  });

  // Close filter modal only if filters are applied successfully
  Navigator.pop(context);
}

void resetFilters() {
  setState(() {
    selectedDepartments.clear();
    selectedShifts.clear();
    filteredList = List.from(staffList);
  });
}

  void showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: resetFilters,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Department'),
                Wrap(
                  spacing: 8.0,
                  children: ['Housekeeping', 'Maintenance', 'Kitchen', 'Security']
                      .map((department) => FilterChip(
                            label: Text(department),
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
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text('Shift'),
                Wrap(
                  spacing: 8.0,
                  children: ['Day', 'Night', 'Morning']
                      .map((shift) => FilterChip(
                            label: Text(shift),
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
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: applyFilters,
                  child: const Text('Show Results'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
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
    return Scaffold(
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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          
          children: [
            // Search bar (optional, can be removed)
            Row(children: [
              InkWell(
                onTap: showFilterModal,
                child: SvgPicture.asset("assets/filter.svg", height: 24, width: 24)),
        
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search staff...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
            // Table header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: const [
                  Expanded(child: Text('Staff', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Shift', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Divider(thickness: 1),
            // List of staff
             Expanded(
        child: filteredList.isEmpty
            ? Center(
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(staff['Staff']!)),
                        Expanded(child: Text(staff['Department']!)),
                        Expanded(child: Text(staff['Shift']!)),
                      ],
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
