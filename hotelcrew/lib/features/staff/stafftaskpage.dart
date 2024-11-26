import '../../core/packages.dart';


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
}

class StaffTaskManagementPage extends StatefulWidget {
  const StaffTaskManagementPage({super.key});

  @override
  State<StaffTaskManagementPage> createState() => _StaffTaskManagementPageState();
}

class _StaffTaskManagementPageState extends State<StaffTaskManagementPage> {
  // Mock list of tasks
  
  final List<Task> tasks = [
    Task(
      id: 1,
      title: 'Clean Room 203',
      department: 'Maintenance',
      description: 'Urgent cleaning required.',
      status: 'Pending',
      deadline: '2:00 AM',
      assignedTo: 'John Doe',
    ),
    Task(
      id: 2,
      title: 'Fix AC in Room 301',
      department: 'Maintenance',
      description: 'AC needs repair.',
      status: 'In Progress',
      deadline: '4:00 PM',
      assignedTo: 'Jane Smith',
    ),
    // Add more tasks if needed
  ];


  String selectedFilter = "All";
  late List<Task> filteredTasks;

  @override
  void initState() {
    super.initState();
    filteredTasks = tasks; // Initially show all tasks
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

  // Function to show the Bottom Sheet for updating task status
void _showStatusUpdateBottomSheet(Task task) {
  String selectedStatus = ''; // To keep track of the selected status

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
                // Title Row with Close Icon
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
                // Status Options
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
                // Update Status Button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedStatus.isNotEmpty) {
                        // Implement status update logic here
                        print("!!!!!!!!!!!");
                        print("Selected Status: $selectedStatus");
                        Navigator.pop(context);
                      } else {
                        // Handle case when no status is selected
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
  // Map to define specific border colors for each status
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




  // Build the status update button with icon
 

  // Task card UI
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
      elevation: 0,
      color: Pallete.primary50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Pallete.primary100, width: 1),
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
                    children: [SizedBox(height: 16),
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
                        ],),
                      SizedBox(height: 10),
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
                      const SizedBox(height:10),
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
        text: task.deadline, // Second part with different style
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
      const SizedBox(height: 16),
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

const SizedBox(height: 8),

           
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
      body: Column(
        children: [
          // Add Filter Chips above the task list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildFilterChips(),
          ),
          Expanded(
            child: filteredTasks.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showStatusUpdateBottomSheet(filteredTasks[index]);
                        },
                        child: _buildTaskCard(filteredTasks[index]),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No tasks found.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }}
