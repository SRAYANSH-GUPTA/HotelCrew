import 'dart:async';
class CustomerDatabaseViewModel {
  // Simulate a network call and customer data
  Future<List<Map<String, String>>> fetchCustomerData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay for fetching data

    // Sample customer data
    return [
      
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
