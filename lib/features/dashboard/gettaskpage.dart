import 'package:hotelcrew/core/packages.dart';
import 'package:hotelcrew/features/dashboard/createtask.dart';
import 'model/gettaskmodel.dart';
import 'viewmodel/gettaskviewmodel.dart';
import 'edittaskpage.dart';
import 'package:hotelcrew/features/dashboard/announcementpage.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({super.key});

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  final TaskService _taskService = TaskService();
  final List<Task> _tasks = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Initial fetch

    // Add scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchTasks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newTasks = await _taskService.fetchTasks(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (mounted) {
        setState(() {
          if (newTasks.isEmpty) {
            _hasMore = false;
          } else {
            _tasks.addAll(newTasks);
            _currentPage++;
            _hasMore = newTasks.length == _pageSize;
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToCreateTask() async {
    // Navigate to CreateTaskPage and fetch tasks when it pops
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskPage()),
    );
    _fetchTasks(); // Refresh tasks after returning
  }

  void _navigateToUpdateTask(Task task) async {
    // Navigate to EditTaskPage and fetch tasks when it pops
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          id: task.id.toString(),
          taskTitle: task.title,
          department: task.department ?? "",
          description: task.description,
        ),
      ),
    );
    _fetchTasks(); // Refresh tasks after returning
  }
   @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
        backgroundColor: Pallete.pagecolor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Task Management',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
              },
              splashColor: Colors.transparent,
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 32),
              width: screenWidth * 0.5445,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: _navigateToCreateTask,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  "Create a new task",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  backgroundColor: Pallete.primary800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Monitor Active Tasks",
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Pallete.neutral1000,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _tasks.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: SvgPicture.asset(
                              'assets/emptytask.svg',
                              width: 328,
                              height: 272,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tasks.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _tasks.length) {
                          return _hasMore
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox();
                        }
                        return _buildTaskCard(_tasks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

void _deleteTask(int taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =  prefs.getString('access_token'); // Fetch access token from shared preferences
  final Uri url = Uri.parse('https://hotelcrew-1.onrender.com/api/taskassignment/tasks/delete/$taskId/'); // Replace with your API URL

  try {
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Success: Show success message in Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
      setState(() {
        // Optionally, remove the task from the list in the UI
        _tasks.removeWhere((task) => task.id == taskId);
      });
      _fetchTasks();
    } else {
      // Failure: Show error message in Snackbar
      final Map<String, dynamic> responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['detail'] ?? 'An error occurred')),
      );
    }
  } catch (e) {
    // Network or other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}



  Widget _buildTaskCard(Task task) {
    // Determine icon and color based on status
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
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      color: Pallete.primary50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Pallete.primary100, width: 1),
    ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with icon and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circle icon container
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

                // Title, department, and status column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with PopupMenuButton
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.neutral950,
                                ),
                              ),
                              maxLines: 1, // Limit to one line
                              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                            ),
                          ),
                          PopupMenuButton<String>(
                            color: Pallete.neutral00,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                  color: Pallete.neutral200, width: 1),
                            ),
                            onSelected: (value) {
                              if (value == 'Edit') {
                                _navigateToUpdateTask(task);
                              } else if (value == 'Delete') {
                                _deleteTask(task.id);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Edit',
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/taskpencil.svg',
                                      height: 18,
                                      width: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Edit Details'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Delete',
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/taskdelete.svg',
                                      height: 18,
                                      width: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            icon: const Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Department and status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Pallete.primary200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.department ?? "no department",
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
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Task description
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

            // Deadline
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
                    text: task.deadline == null ? 'None' : DateFormat('dd MMM, hh:mm a').format(task.deadline!.toLocal()),

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

            // Last updated and assigned by
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Last Updated: ',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('dd MMM, hh:mm a').format(task.updatedAt.toLocal()),
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
            RichText(
              text: TextSpan(
                text: 'Assigned by: ', // Static part of the text
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    color: Pallete.neutral900,
                    fontWeight: FontWeight.w500, // Slightly bolder for the label
                  ),
                ),
                children: [
                  TextSpan(
                    text: task.assignedBy, // Dynamic part of the text
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Pallete.neutral900,
                        fontWeight: FontWeight.w400, // Normal weight for the value
                      ),
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