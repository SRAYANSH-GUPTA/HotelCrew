import 'dart:async';
import '../model/stafflistmodel.dart';
class CustomerDatabaseViewModel {
  // Simulate a network call and customer data
  Future<List<Map<String, String>>> fetchCustomerData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay for fetching data

    // Sample customer data
    return [
      {
        'name': 'John Doe',
        'customerId': '1234567890',
        'email': 'abcd123@gmail.com',
        'contact': '9876543210',
        'room': '301',
        'checkIn': '20-03-2024',
        'checkOut': '20-05-2024',
        'status': 'Regular',
      },
      {
        'name': 'Jane Smith',
        'customerId': '0987654321',
        'email': 'janesmith@gmail.com',
        'contact': '1234567890',
        'room': '302',
        'checkIn': '22-03-2024',
        'checkOut': '22-05-2024',
        'status': 'VIP',
      },
      {
        'name': 'Mark Johnson',
        'customerId': '1122334455',
        'email': 'markjohnson@gmail.com',
        'contact': '5566778899',
        'room': '303',
        'checkIn': '25-03-2024',
        'checkOut': '25-05-2024',
        'status': 'Regular',
      },
    ];
  }

  // Mock function to filter customers based on their status
  Future<List<Map<String, String>>> filterCustomersByStatus(
      List<Map<String, String>> customerData, List<String> selectedStatuses) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate filter delay

    // If no status is selected, return all customers
    if (selectedStatuses.isEmpty) {
      return customerData;
    }

    // Filter customers by selected statuses
    return customerData.where((customer) {
      final customerStatus = customer['status']?.toLowerCase() ?? '';
      return selectedStatuses.contains(customerStatus);
    }).toList();
  }

  // Mock function to search customers by name
  Future<List<Map<String, String>>> searchCustomersByName(
      List<Map<String, String>> customerData, String searchTerm) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate search delay

    if (searchTerm.isEmpty) {
      return customerData;
    }

    // Filter customers by search term in their name
    return customerData.where((customer) {
      final customerName = customer['name']?.toLowerCase() ?? '';
      return customerName.contains(searchTerm.toLowerCase());
    }).toList();
  }
}
