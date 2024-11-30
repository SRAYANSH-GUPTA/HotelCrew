import '../../core/packages.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import "viewmodel/shiftviewmodel.dart";

class ShiftSchedulePage extends StatefulWidget {
  const ShiftSchedulePage({super.key});

  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  late Future<List<Map<String, String>>> _staffSchedulesFuture;
  List<Map<String, String>> staffList = [];
  List<Map<String, String>> filteredList = [];

  List<String> selectedDepartments = [];
  List<String> selectedShifts = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSetStaffSchedules();
  }

  Future<List<Map<String, String>>> _fetchStaffSchedules() async {
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
                ElevatedButton(
                  onPressed: () {
                    applyFilters();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.primary700,
    
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text('Show Results',style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral00,
                  ),),
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
                child: FutureBuilder<List<Map<String, String>>>(
                  future: _staffSchedulesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(fontSize: 16, color: Colors.red),
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
                                      return Container(
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
