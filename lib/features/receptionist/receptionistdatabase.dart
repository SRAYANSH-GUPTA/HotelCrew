import '../../core/packages.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReceptionistCustomerDatabasePage extends StatefulWidget {
  const ReceptionistCustomerDatabasePage({super.key});

  @override
  _ReceptionistCustomerDatabasePageState createState() => _ReceptionistCustomerDatabasePageState();
}

class _ReceptionistCustomerDatabasePageState extends State<ReceptionistCustomerDatabasePage> {
  final screenHeight = const MediaQueryData().size.height;
  final screenWidth = const MediaQueryData().size.width;

  List<Map<String, String>> customerData = [
    
  ];

  final String apiUrl = 'https://hotelcrew-1.onrender.com/api/hoteldetails/all-customers/';

  Future<void> fetchData() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Map<String, String>> formattedData = convertCustomerData(data);
        setState(() {
          customerData = formattedData;
          filteredList = List.from(customerData);
        });
        print('Formatted customer data: $formattedData');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Map<String, String>> convertCustomerData(List<dynamic> customerList) {
    List<Map<String, String>> formattedCustomerData = [];
    for (var customer in customerList) {
      formattedCustomerData.add({
        'name': customer['name'],
        'customerId': customer['id'].toString(),
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

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  }

  List<Map<String, String>> filteredList = [];
  List<String> selectedStatuses = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void applyFilters() {
    setState(() {
      filteredList = customerData.where((customer) {
        final customerStatus = customer['status']?.trim().toLowerCase() ?? '';
        final selectedStatusesLower = selectedStatuses.map((status) => status.trim().toLowerCase()).toList();
        if (selectedStatuses.isEmpty) {
          return true;
        }
        final matchesStatus = selectedStatusesLower.contains(customerStatus);
        return matchesStatus;
      }).toList();
    });
    print(filteredList);
    Navigator.pop(context);
  }

  void resetFilters() {
    setState(() {
      selectedStatuses.clear();
      filteredList = List.from(customerData);
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
String access_token = "";
  Future<void> checkoutCustomer(String customerId) async {
    await getToken(); // Wait for the token to be retrieved
  if (access_token.isEmpty) {
    print('Access token is null or empty');
    return;
  }
    final String checkoutUrl = 'https://hotelcrew-1.onrender.com/api/hoteldetails/checkout/$customerId/';
    try {
      final response = await http.post(
        Uri.parse(checkoutUrl),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer checked out successfully')),
        );
        fetchData(); // Refresh the list after successful checkout
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to checkout: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
          child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
        ),
        title: Text(
          "Manage Guests",
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showFilterModal(context);
                  },
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
                          hintText: 'Search Customer...',
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
                            if (value.isNotEmpty) {
                              filteredList = customerData.where((customer) {
                                final customerName = customer['name']?.toLowerCase() ?? '';
                                return customerName.contains(value.toLowerCase());
                              }).toList();
                            } else {
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
                            itemCount: filteredList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var customer = filteredList[index];
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
                                      screenWidth: screenWidth,
                                      onCheckout: () => checkoutCustomer(customer['customerId'] ?? ""),
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
          ],
        ),
      ),
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
  final VoidCallback onCheckout;

  const CustomerPaymentCard({
    super.key,
    required this.name,
    required this.customerId,
    required this.email,
    required this.contact,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.screenWidth,
    required this.onCheckout,
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
            Row(
              children: [
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
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: status == 'VIP' ? Pallete.warning100 : Pallete.neutral00,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: status == 'VIP' ? Pallete.warning200 : Pallete.neutral400,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: status == 'VIP' ? Pallete.neutral900 : Pallete.neutral900,
                    ),
                  ),
                ),
              ],
            ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Spacer(),
                ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary800,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Pallete.neutral00,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
