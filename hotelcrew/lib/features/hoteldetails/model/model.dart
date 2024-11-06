class HotelInfo {
  final int user;
  final String hotelName;
  final String legalBusinessName;
  final int yearEstablished;
  final String licenseRegistrationNumbers;
  final String completeAddress;
  final String mainPhoneNumber;
  final String emergencyPhoneNumber;
  final String emailAddress;
  final int totalNumberOfRooms;
  final int numberOfFloors;
  final bool valetParkingAvailable;
  final int valetParkingCapacity;
  final String checkInTime;
  final String checkOutTime;
  final String paymentMethods;
  final double roomPrice;
  final int numberOfDepartments;
  final String departmentNames;
  final String staffExcelSheet;

  HotelInfo({
    required this.user,
    required this.hotelName,
    required this.legalBusinessName,
    required this.yearEstablished,
    required this.licenseRegistrationNumbers,
    required this.completeAddress,
    required this.mainPhoneNumber,
    required this.emergencyPhoneNumber,
    required this.emailAddress,
    required this.totalNumberOfRooms,
    required this.numberOfFloors,
    required this.valetParkingAvailable,
    required this.valetParkingCapacity,
    required this.checkInTime,
    required this.checkOutTime,
    required this.paymentMethods,
    required this.roomPrice,
    required this.numberOfDepartments,
    required this.departmentNames,
    required this.staffExcelSheet,
  });

  // Convert HotelInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'hotel_name': hotelName,
      'legal_business_name': legalBusinessName,
      'year_established': yearEstablished,
      'license_registration_numbers': licenseRegistrationNumbers,
      'complete_address': completeAddress,
      'main_phone_number': mainPhoneNumber,
      'emergency_phone_number': emergencyPhoneNumber,
      'email_address': emailAddress,
      'total_number_of_rooms': totalNumberOfRooms,
      'number_of_floors': numberOfFloors,
      'valet_parking_available': valetParkingAvailable,
      'valet_parking_capacity': valetParkingCapacity,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'payment_methods': paymentMethods,
      'room_price': roomPrice,
      'number_of_departments': numberOfDepartments,
      'department_names': departmentNames,
      'staff_excel_sheet': staffExcelSheet,
    };
  }

  // Create HotelInfo object from JSON
  factory HotelInfo.fromJson(Map<String, dynamic> json) {
    return HotelInfo(
      user: json['user'],
      hotelName: json['hotel_name'],
      legalBusinessName: json['legal_business_name'],
      yearEstablished: json['year_established'],
      licenseRegistrationNumbers: json['license_registration_numbers'],
      completeAddress: json['complete_address'],
      mainPhoneNumber: json['main_phone_number'],
      emergencyPhoneNumber: json['emergency_phone_number'],
      emailAddress: json['email_address'],
      totalNumberOfRooms: json['total_number_of_rooms'],
      numberOfFloors: json['number_of_floors'],
      valetParkingAvailable: json['valet_parking_available'],
      valetParkingCapacity: json['valet_parking_capacity'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      paymentMethods: json['payment_methods'],
      roomPrice: double.parse(json['room_price']),
      numberOfDepartments: json['number_of_departments'],
      departmentNames: json['department_names'],
      staffExcelSheet: json['staff_excel_sheet'],
    );
  }
}
