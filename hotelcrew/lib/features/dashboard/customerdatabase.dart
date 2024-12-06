import '../../core/packages.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// List<Map<String, String>> customerData = [
//     {"name": "John Doe", "email": "abcd123@gmail.com", "department": "Housekeeping", "salary": "15000"},
//     {"name": "Aakash", "email": "abcd123@gmail.com", "department": "Receptionist", "salary": "18000"},
//     {"name": "Amit", "email": "abcd123@gmail.com", "department": "Kitchen", "salary": "15000"},
//   ];


class CustomerDatabasePage extends StatefulWidget {
  const CustomerDatabasePage({super.key});

  @override
  _CustomerDatabasePageState createState() => _CustomerDatabasePageState();
}


class _CustomerDatabasePageState extends State<CustomerDatabasePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;
  // Initial dummy list
List<Map<String, String>> customerData = [
  
];
//TODO: Fix thw filter option
final String apiUrl = 'https://hotelcrew-1.onrender.com/api/hoteldetails/all-customers/'; // Replace with your actual API URL

  // Function to fetch data via HTTPS
 
Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

  try {
    // Make the GET request to the API
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken', // Optional: Add authorization if needed
      },
    );

    // Check if the response is successful (HTTP 200)
    if (response.statusCode == 200) {
      // Parse the response body into JSON
      var data = json.decode(response.body);

      // Convert the data into the desired format
      List<Map<String, String>> formattedData = convertCustomerData(data);
      // SetState(() {
      //   customerData = formattedData;
      // });
      // Now you can use the formatted data
      setState(() {
          customerData = formattedData;
          filteredList = List.from(customerData);
        });
      print('Formatted customer data: $formattedData');
    } else {
      // Handle unsuccessful response
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle error if something goes wrong
    print('Error fetching data: $e');
  }
}

// Function to convert the API response data into the desired format
List<Map<String, String>> convertCustomerData(List<dynamic> customerList) {
  // Create a list to hold the formatted data
  List<Map<String, String>> formattedCustomerData = [];

  // Loop through each customer in the parsed data and format the data
  for (var customer in customerList) {
    formattedCustomerData.add({
      'name': customer['name'],
      'customerId': customer['id'].toString(), // Ensure the ID is a string
      'email': customer['email'],
      'contact': customer['phone_number'],
      'room': customer['room_no'].toString(),
      'checkIn': formatDateTime(customer['check_in_time']),
      'checkOut': formatDateTime(customer['check_out_time']),
      'status': customer['status'],
    });
  }

  return formattedCustomerData;
}

// Helper function to format DateTime into a readable string (e.g., 'dd-MM-yyyy')
String formatDateTime(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
}


  // Filtered list for updates
  List<Map<String, String>> filteredList = [];
List<String> selectedStatuses = [];

@override
void initState() {
  super.initState();
  fetchData();
   // Initially showing all customers
}

void applyFilters() {
  setState(() {
    filteredList = customerData.where((customer) {
      // Normalize customer status and selected statuses to lowercase for comparison
      final customerStatus = customer['status']?.trim().toLowerCase() ?? '';
      final selectedStatusesLower = selectedStatuses.map((status) => status.trim().toLowerCase()).toList();

      // If selectedStatuses is empty, return all customers
      if (selectedStatuses.isEmpty) {
        return true;
      }

      // Check if the customer's status matches any selected status
      final matchesStatus = selectedStatusesLower.contains(customerStatus);
      return matchesStatus;
    }).toList();
  });
  print(filteredList); // Debugging output


  // Close filter modal after applying filters
  Navigator.pop(context);
}

void resetFilters() {
  setState(() {
    selectedStatuses.clear();
    filteredList = List.from(customerData); // Reset to the full list
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

              // Status Filter
              Text(
                'Status',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Pallete.neutral900,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // "All" button to clear the status filter
              // FilterChip(
              //   side: const BorderSide(color: Pallete.neutral200, width: 1),
              //   selectedColor: Pallete.primary700,
              //   showCheckmark: false,
              //   label: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       // Text(
              //       //   'All',
              //       //   style: GoogleFonts.montserrat(
              //       //     textStyle: TextStyle(
              //       //       fontSize: 14,
              //       //       fontWeight: FontWeight.w400,
              //       //       color: selectedStatuses.isEmpty
              //       //           ? Pallete.neutral00
              //       //           : Pallete.neutral900,
              //       //     ),
              //       //   ),
              //       // ),
              //       if (selectedStatuses.isEmpty)
              //         const Padding(
              //           padding: EdgeInsets.only(left: 4.0),
              //           child: Icon(
              //             Icons.check,
              //             color: Pallete.neutral00,
              //             size: 18,
              //           ),
              //         ),
              //     ],
              //   ),
              //   selected: selectedStatuses.isEmpty,
              //   onSelected: (bool selected) {
              //     setModalState(() {
              //       selectedStatuses.clear(); // Clear all statuses to show all
              //     });
              //   },
              // ),
              const SizedBox(height: 24),

              // VIP and Regular Filters
              Wrap(
                spacing: 8.0,
                children: ['VIP', 'Regular']
                    .map(
                      (status) => FilterChip(
                        side: const BorderSide(color: Pallete.neutral200, width: 1),
                        selectedColor: Pallete.primary700,
                        showCheckmark: false,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              status,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: selectedStatuses.contains(status)
                                      ? Pallete.neutral00
                                      : Pallete.neutral900,
                                ),
                              ),
                            ),
                            if (selectedStatuses.contains(status))
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
                        selected: selectedStatuses.contains(status),
                        onSelected: (bool selected) {
                          setModalState(() {
                            if (selected) {
                              selectedStatuses.add(status); // Add to selected statuses
                            } else {
                              selectedStatuses.remove(status); // Remove from selected statuses
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 106),

              // Apply Filters Button
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
            "Guest Details",
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

//TODo: Fix search and filter
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
            hintText: 'Search Customer...',
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
    // Ensure value is not null or empty before filtering
    if (value.isNotEmpty) {
      filteredList = customerData.where((customer) {
        // Check if the 'name' field contains the search term, case-insensitively
        final customerName = customer['name']?.toLowerCase() ?? '';
        return customerName.contains(value.toLowerCase());
      }).toList();
    } else {
      // If the search term is empty, reset the filtered list to the original data
      filteredList = List.from(customerData);
    }
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
        ? Center(
              child: SvgPicture.asset(
                'assets/noguest.svg',
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
    itemCount: filteredList.length, // Use the filtered list here
    shrinkWrap: true,
    itemBuilder: (context, index) {
      var customer = filteredList[index]; // Get the customer from the filtered list
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                left: BorderSide(color: Pallete.primary300, width: 4),
              ),
            ),
            child: CustomerPaymentCard(
              name: customer['name'] ?? "",
              customerId: customer['customerId'] ?? "",
              email: customer['email'] ?? "",
              contact: customer['contact'] ?? "",
              room: customer['room'] ?? "",
              checkIn: customer['checkIn'] ?? "",
              checkOut: customer['checkOut'] ?? "",
              status: customer['status'] ?? "",
              screenWidth: screenWidth, // Pass screen width if needed
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    },
  ),
)

        
        
            ],
          ),
            
          
        ),
            ],),),
      );
  }
}




class CustomerPaymentCard extends StatelessWidget {
  final String name;
  final String customerId;
  final String email;
  final String contact;
  final String room;
  final String checkIn;
  final String checkOut;
  final String status;
  final double screenWidth;

  // Constructor receiving each field as a separate parameter
  const CustomerPaymentCard({super.key, 
    required this.name,
    required this.customerId,
    required this.email,
    required this.contact,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.primary50, 
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Pallete.primary300, width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Name and Status Row
    Row(
      children: [
        // Name Text
        RichText(
          text: TextSpan(
            text: 'Name:  ',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral950,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: name,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Pallete.neutral950,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Status Container
        Container(
          margin: const EdgeInsets.only(left: 8.0), // Margin between name and status
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: status == 'VIP' ? Pallete.warning100 : Pallete.neutral00, // Background color based on status
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: status == 'VIP' ? Pallete.warning200 : Pallete.neutral400, // Border color based on status
              width: 1,
            ),
          ),
          child: Text(
            status,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: status == 'VIP' ? Pallete.neutral900 : Pallete.neutral900, // Text color based on status
            ),
          ),
        ),
      ],
    ),

    // Customer ID
    RichText(
      text: TextSpan(
        text: 'Customer ID:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: customerId,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Pallete.neutral950,
            ),
          ),
        ],
      ),
    ),
    
    // Email
    RichText(
      text: TextSpan(
        text: 'Email:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
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
    
    // Contact
    RichText(
      text: TextSpan(
        text: 'Contact:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: contact,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Pallete.neutral950,
            ),
          ),
        ],
      ),
    ),
    
    // Room
    RichText(
      text: TextSpan(
        text: 'Room:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: room,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Pallete.neutral950,
            ),
          ),
        ],
      ),
    ),
    
    // Check-In
    RichText(
      text: TextSpan(
        text: 'Check-In:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: checkIn,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Pallete.neutral950,
            ),
          ),
        ],
      ),
    ),
    
    // Check-Out
    RichText(
      text: TextSpan(
        text: 'Check-Out:  ',
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.neutral950,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: checkOut,
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
)


      ),
    );
  }
}
