import '../../core/packages.dart';

class StaffPaymentPage extends StatefulWidget {
  const StaffPaymentPage({super.key});

  @override
  _StaffPaymentPageState createState() => _StaffPaymentPageState();
}

class _StaffPaymentPageState extends State<StaffPaymentPage> {
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
  List<String> selectedStatus = [];

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
      final matchesStatus=
          selectedStatus.isEmpty || selectedStatus.contains(staff['Status']);
      return matchesDepartment && matchesStatus;
    }).toList();
  });

  // Close filter modal only if filters are applied successfully
  Navigator.pop(context);
}

void resetFilters() {
  setState(() {
    selectedDepartments.clear();
    selectedStatus.clear();
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
              ),),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: (){Navigator.of(context).pop();
                resetFilters;
                
                },
              ),
            ],
          ),
                const SizedBox(height: 44),
                Text('Department',
                style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral900,
            ),
              ),),
              const SizedBox(height: 24),
               Wrap(
  spacing: 8.0,
  children: ['Housekeeping', 'Maintenance', 'Kitchen', 'Security']
      .map(
        (department) => FilterChip(
          side: const BorderSide(color: Pallete.neutral200, width: 1),
          selectedColor: Pallete.primary700,
          // checkmarkColor: Pallete.neutral00,
          showCheckmark: false,
          label: Row(mainAxisSize: MainAxisSize.min,
            children: [Text(
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

                const SizedBox(height: 32),
                 Text('Status',
                style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral900,
            ),
              ),),
              const SizedBox(height: 24),
                Wrap(
  spacing: 8.0,
  children: ['Paid', 'Not Paid', 'Transaction Error']
      .map(
        (status) => FilterChip(
          showCheckmark: false,
          side: const BorderSide(color: Pallete.neutral200, width: 1), // Border style
          selectedColor: Pallete.primary700, // Background color when selected
          // checkmarkColor: Colors.transparent, // Hide default checkmark
          // avatar: selectedShifts.contains(shift)
          //     ? Icon(
          //         Icons.check, // Custom checkmark
          //         color: Pallete.neutral00,
          //         size: 18,
          //       )
          //     : null, // No avatar when not selected
          label: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
               status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: selectedStatus.contains(status)
                      ? Pallete.neutral00 // Text color when selected
                      : Pallete.neutral900, // Text color when not selected
                ),
              ),
              if (selectedStatus.contains(status))
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
          selected: selectedStatus.contains(status),
          onSelected: (bool selected) {
            setModalState(() {
              if (selected) {
                selectedStatus.add(status);
              } else {
                selectedStatus.remove(status);
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
)

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
            "Payroll",
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral950,
              ),
            ),
          ),
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
                status: staff['Status'] ?? "",
                account: staff['account'] ?? "",
                transactionId: staff['TransactionId'] ?? "",
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
  final String status;
  final String transactionId;
  final String account;

  const StaffPaymentCard({
    super.key,
    required this.staffName,
    required this.email,
    required this.salary,
    required this.status,
    required this.account,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
  return
 
   Card(
  color: Pallete.primary50,
  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
  shape: RoundedRectangleBorder(
    side: const BorderSide(color: Pallete.primary300, width: 1),
    borderRadius: BorderRadius.circular(8),
  ),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // RichText for staff name
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Name: ', // Label
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral950,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: staffName, // Actual name
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Pallete.neutral950,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Add transaction status or "Paid"
            if (status == 'Paid') ...[
              Container(
                
                decoration: BoxDecoration(
                  color: Pallete.success100,
                  border: Border.all(color: Pallete.success200 ,width:1),
                  borderRadius: BorderRadius.circular(4),               ),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                child: Text(
                  'Paid',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ] else if (status == 'Transaction Error') ...[
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Pallete.error100,
                   borderRadius: BorderRadius.circular(4),
                   border: Border.all(color: Pallete.error200 ,width:1)
                
                ),
               
                child: Text(
                  textAlign: TextAlign.center,
                  'Transaction Failed',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Pallete.neutral900,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Email: ', // Label
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral950,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: email, // Actual email
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
                text: 'Account Number: ', // Label
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral950,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: account, // Actual account number
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Salary: ', // Label
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral950,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: 'Rs. $salary', // Actual salary
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Pallete.neutral950,
                  ),
                ),
              ],
            ),
          ),
         if (status == 'Transaction Error') 
  ElevatedButton(
    onPressed: () {
      // Add retry logic here
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Pallete.primary800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(
      'Try Again',
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral00,
        ),
      ),
    ),
  )
else if (status != 'Paid')...[ 
  
   ElevatedButton(
            onPressed: () {
              // Add payment logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.primary800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Pay',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Pallete.neutral00,
                ),
              ),
            ),
          ),],
          

             
          
          ],
        ),
        if (status == 'Paid')...[ 
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Transaction Id: ', // Label
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral950,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: transactionId, // Actual salary
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Pallete.neutral950,
                  ),
                ),
              ],
            ),
          ),],
        // const SizedBox(height: 12),
        // Conditional rendering of status-based widgets
        if (status == 'Transaction Error') ...[
          const Row(
            children: [
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //   decoration: BoxDecoration(
              //     color: Colors.red[100],
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Text(
              //     'Transaction Failed',
              //     style: GoogleFonts.montserrat(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.red[800],
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 8),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add retry logic here
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Pallete.primary700,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: Text(
              //     'Try Again',
              //     style: GoogleFonts.montserrat(
              //       textStyle: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600,
              //         color: Pallete.neutral00,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        // ] else if (status != 'Paid') ...[
        //   ElevatedButton(
        //     onPressed: () {
        //       // Add payment logic here
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Pallete.primary800,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     child: Text(
        //       'Pay',
        //       style: GoogleFonts.montserrat(
        //         textStyle: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //           color: Pallete.neutral00,
        //         ),
        //       ),
        //     ),
        //   ),
         ],
      ],
    ),
  ),
);


}
}