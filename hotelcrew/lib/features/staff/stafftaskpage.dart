import '../../core/packages.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class Task {
  final int id;
  final String title;
  final String department;
  final String description;
  final String status;
  final String deadline;
  final String assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.department,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
  });

  // Factory method to create a Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      department: json['department'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      deadline: json['deadline'] ?? "",
      assignedTo: json['assigned_to'] ?? "",
    );
  }
}

class StaffTaskManagementPage extends StatefulWidget {
  const StaffTaskManagementPage({super.key});

  @override
  State<StaffTaskManagementPage> createState() => _StaffTaskManagementPageState();
}

class _StaffTaskManagementPageState extends State<StaffTaskManagementPage> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  String selectedFilter = "All";
  String nextPageUrl = 'https://hotelcrew-1.onrender.com/api/taskassignment/tasks/staff/';
  bool isLoading = false;
  bool hasMore = true;

  String access_token = "";

  @override
  void initState() {
    super.initState();
    getTokenAndFetchTasks();
  }

  Future<void> getTokenAndFetchTasks() async {
    await getToken();
    fetchTasks();
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

  Future<void> fetchTasks() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(nextPageUrl),
        headers: {
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final List<Task> fetchedTasks = results.map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>)).toList();

        setState(() {
          tasks.addAll(fetchedTasks);
          filteredTasks = tasks;
          nextPageUrl = data['next'] ?? '';
          hasMore = nextPageUrl.isNotEmpty;
        });
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showStatusUpdateBottomSheet(Task task) {
    String selectedStatus = '';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Update Task Status',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusButton(
                        'Pending',
                        'assets/pendingtask.svg',
                        Pallete.error100,
                        Colors.redAccent,
                        selectedStatus == 'Pending',
                        () {
                          setState(() {
                            selectedStatus = 'Pending';
                          });
                        },
                      ),
                      _buildStatusButton(
                        'In Progress',
                        'assets/inprogresstask.svg',
                        Pallete.warning100,
                        Colors.amber,
                        selectedStatus == 'In Progress',
                        () {
                          setState(() {
                            selectedStatus = 'In Progress';
                          });
                        },
                      ),
                      _buildStatusButton(
                        'Completed',
                        'assets/completetask.svg',
                        Pallete.success200,
                        Colors.green,
                        selectedStatus == 'Completed',
                        () {
                          setState(() {
                            selectedStatus = 'Completed';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedStatus.isNotEmpty) {
                          // Implement status update logic here
                          print("Selected Status: $selectedStatus");
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a status.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.primary700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Update Status',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusButton(
    String title,
    String assetPath,
    Color bgColor,
    Color iconColor,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final Map<String, Color> borderColors = {
      'Pending': Pallete.error700,
      'In Progress': Pallete.warning600,
      'Completed': Pallete.success600,
    };

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? borderColors[title]! : Colors.transparent,
                width: 2,
              ),
            ),
            child: SvgPicture.asset(
              assetPath,
              width: 32,
              height: 32,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    String iconPath;
    Color statusColor;
    if (task.status == 'Pending') {
      iconPath = 'assets/pendingtask.svg';
      statusColor = Pallete.error100;
    } else if (task.status == 'In Progress') {
      iconPath = 'assets/inprogresstask.svg';
      statusColor = Pallete.warning200;
    } else {
      iconPath = 'assets/completetask.svg';
      statusColor = Pallete.success200;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      elevation: 0,
      color: Pallete.primary50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Pallete.primary100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: statusColor,
                    child: SvgPicture.asset(iconPath, height: 30, width: 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            task.title,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Pallete.neutral950,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Pallete.primary200,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              task.department,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Pallete.neutral800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.status,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Pallete.neutral800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: 'Deadline: ',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Pallete.neutral900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: task.deadline,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Pallete.neutral900,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.description,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Pallete.neutral900,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'Assigned by: ',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    color: Pallete.neutral900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  TextSpan(
                    text: task.assignedTo,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Last Updated: ',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Pallete.neutral900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: '11:00 PM',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Pallete.neutral900,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '11:00 PM',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w400,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Management',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Pallete.pagecolor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFilterChips(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredTasks.length) {
                        fetchTasks();
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          _showStatusUpdateBottomSheet(filteredTasks[index]);
                        },
                        child: _buildTaskCard(filteredTasks[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ["All", "Pending", "In Progress", "Completed"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  showCheckmark: false,
                  selectedColor: Pallete.primary200,
                  backgroundColor: Colors.white,
                  label: Text(
                    filter,
                    style: GoogleFonts.montserrat(
                      color: selectedFilter == filter
                          ? Pallete.neutral900
                          : Pallete.neutral700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: selectedFilter == filter,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                      _applyFilter(); // Update filtered tasks when filter changes
                    }
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter == "All") {
        filteredTasks = tasks;
      } else {
        filteredTasks = tasks.where((task) => task.status == selectedFilter).toList();
      }
    });
  }
}
