import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/core/packages.dart';
import 'model/gettaskmodel.dart';
import 'viewmodel/gettaskviewmodel.dart';

class TaskManagementPage extends StatefulWidget {
  const TaskManagementPage({Key? key}) : super(key: key);

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  final TaskService _taskService = TaskService();
  Future<List<Task>>? _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _taskService.fetchTasks(); // Fetching mock data
  }

  // Mock function for deleting a task
  void _deleteTask(int taskId) {
    print("Task with ID $taskId deleted.");
    setState(() {
      _tasks = _taskService.fetchTasks(); // Refresh tasks list
    });
  }

  // Mock function to navigate to update task page
  void _navigateToUpdateTask(Task task) {
    print("Navigating to update page for task: ${task.title}");
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
          IconButton(
            icon: 
              // padding: EdgeInsets.only(right: 16),
               SvgPicture.asset(
                'assets/message.svg', // Replace with your SVG icon
                height: 40,
                width: 40,
              ),
            
            onPressed: () {
              print("Create new task button clicked");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              margin: EdgeInsets.only(left: 16,top: 32),
          width: screenWidth * 0.5445, // Width in pixels
          height: 40,  // Height in pixels
          child: ElevatedButton.icon(
            onPressed: () {   
              // Define the button action here
            },
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
               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              backgroundColor: Pallete.primary800, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              elevation: 2, // Button elevation for shadow
            ),
          ),),
            SizedBox(height: 32,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
            SizedBox(height: 32,),
            Padding(
              
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<Task>>(
                future: _tasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Task> tasks = snapshot.data!;
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(tasks[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('No tasks available.'));
                  }
                },
              ),
                      ),
            ],
        ),
      ),
    );
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
      side: BorderSide(color: Pallete.primary100, width: 1),
    ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0,right: 12,bottom: 8),
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
                    child: SvgPicture.asset(iconPath, height: 30, width: 30)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(
                          task.title,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Pallete.neutral950,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                  color: Pallete.neutral00,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Pallete.neutral200, width: 1),),
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
                  icon: const Icon(Icons.more_horiz), // Changed to horizontal dots
                ),],
                      ),
                      // const SizedBox(height: 10),
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            
                            
                              decoration: BoxDecoration(
    color: Pallete.primary200, // Background color
    borderRadius: BorderRadius.circular(4), // Rounded corners
    border: Border.all(
      color: Colors.transparent, // Border color
      width: 0, // Border width
    ),
  ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            
                            child: Text(
                              'Maintenance',
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
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Pallete.neutral800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      RichText(
  text: TextSpan(
    text: 'Deadline: ', // First part with its own style
    style: GoogleFonts.montserrat(
      textStyle: const TextStyle(
        fontSize: 12,
        color: Pallete.neutral900,
        fontWeight: FontWeight.w500,
      ),
    ),
    children: [
      TextSpan(
        text: '${task.deadline}', // Second part with different style
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 12,
            color: Pallete.neutral900, // Highlighting deadline
            fontWeight: FontWeight.w400, // Bold for emphasis
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
        task.description, // Second part with different style
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 14,
            color: Pallete.neutral900, // Different color for the assigned user
            fontWeight: FontWeight.w400, // Bold for emphasis
          ),
        ),
      ),
      SizedBox(height: 16),
            RichText(
  text: TextSpan(
    text: 'Assigned by: ', // First part with its own style
    style: GoogleFonts.montserrat(
      textStyle: const TextStyle(
        fontSize: 12,
        color: Pallete.neutral900,
        fontWeight: FontWeight.w500,
      ),
    ),
    children: [
      TextSpan(
        text: 'User ${task.assignedTo}', // Second part with different style
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 12,
            color: Pallete.neutral900, // Different color for the assigned user
            fontWeight: FontWeight.w400, // Bold for emphasis
          ),
        ),
      ),
    ],
  ),
),

SizedBox(height: 8),

           
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Last Updated: ', 
                        style: GoogleFonts.montserrat(
              textStyle: const TextStyle(fontSize: 12, color: Pallete.neutral900,
              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextSpan(
                        text: '11:00 PM',
                        style: GoogleFonts.montserrat(
              textStyle: const TextStyle(fontSize: 12, color: Pallete.neutral900,
              fontWeight: FontWeight.w400),
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
                  textStyle: const TextStyle(fontSize: 12, color: Pallete.neutral900,
                  fontWeight: FontWeight.w400),
                ),
              ),
            ),

              ]
            ),



          ],
        ),
      ),
    );
  }
}
