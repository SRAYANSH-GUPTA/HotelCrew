import '../../core/packages.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import '../dashboard/viewmodel/createannouncementviewmodel.dart';

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  _CreateAnnouncementPageState createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _priorityLevelController = TextEditingController();
  final TextEditingController _departmentsController = TextEditingController();

  String? _priorityLevel;
  List<String> _selectedDepartments = [];
  bool _isPriorityLevelError = false;
  bool _isDepartmentsError = false;

@override
  void initState() {
    super.initState();
    fetchDepartments(context);
    // Initially, the filtered list is the same as the full staff list
  }



void fetchDepartments(BuildContext context) async {
  final Uri url = Uri.parse('https://hotelcrew-1.onrender.com/api/edit/department_list/'); // Replace with your actual endpoint
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token'); // Fetch access token from shared preferences

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        final Map<String, dynamic> staffPerDepartment =
            responseData['staff_per_department'] ?? {};
        List<String> department = []; // Start with 'All Staff'
        department.addAll(staffPerDepartment.keys);
        setState(() {
          dept = department;
        });
        
      } else {
        throw Exception('Unexpected response: ${responseData['message']}');
      }
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch departments.');
    }
  } catch (error) {
    // Show error in Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );

  }
}



  List<String> dept = [];

  void _showPriorityLevelBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Heading with close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Priority Level',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Divider(),

          // Priority Options
          ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Pallete.error700,
                shape: BoxShape.circle,
              ),
            ),
            title: const Text("Urgent"),
            onTap: () {
              setState(() {
                _priorityLevel = "Urgent";
                _priorityLevelController.text = "Urgent";
                _isPriorityLevelError = false;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            title: const Text("Normal"),
            onTap: () {
              setState(() {
                _priorityLevel = "Normal";
                _priorityLevelController.text = "Normal";
                _isPriorityLevelError = false;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}


 void _showDepartmentSelectionBottomSheet(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: screenHeight * 0.6, // Adjust height as needed
            
            child: Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      // Border color
                      width: 0.5,
                      color: Colors.transparent         // Border width
                    ),
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                  ),
                  splashRadius: 24, // Radius for the checkbox ripple effect
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Pallete.primary700; // Checkbox fill color when selected
                    }
                    return Colors.white; // Checkbox fill color when not selected
                  }),
                  checkColor: WidgetStateProperty.all(Colors.white), // Checkmark color
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact, // Reduces space around checkbox
                ),
              ),
              child: Column(

                children: [
                  // Header with Close Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tag Departments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Divider(),

                  // Checkbox List
                  Expanded(
                    child: ListView(
                      children: [
                        // Checkbox for "All Departments"
CheckboxListTile(
  title: const Text("All Departments"),
  value: _selectedDepartments.length == dept.length, // Check if all departments are selected
  onChanged: (value) {
    setState(() {
      if (value == true) {
        _selectedDepartments = List.from(dept); // Select all departments
      } else {
        _selectedDepartments.clear(); // Clear selection
      }
      _departmentsController.text = value == true ? "All" : "";
      _isDepartmentsError = _selectedDepartments.isEmpty;
    });
  },
),
// Individual Department Checkboxes
...dept.map(
  (department) => CheckboxListTile(
    title: Text(department),
    value: _selectedDepartments.contains(department), // Check if this department is selected
    onChanged: (value) {
      setState(() {
        if (value == true) {
          _selectedDepartments = [department]; // Only select this department
        } else {
          _selectedDepartments.clear(); // Clear selection
        }
        _departmentsController.text =
            _selectedDepartments.isEmpty ? "" : _selectedDepartments.first;
        _isDepartmentsError = _selectedDepartments.isEmpty;
      });
    },
  ),
),


                            
                      ],
                    ),
                  ),

                  // Done Button
                  buildMainButton(
                    context: context,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    buttonText: 'Done',
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}



 void _postAnnouncement() async {
  print("^"*100);
  setState(() {
    _isPriorityLevelError = _priorityLevel == null;
    _isDepartmentsError = _selectedDepartments.isEmpty;
  });

  if (_formKey.currentState!.validate() &&
      !_isPriorityLevelError &&
      !_isDepartmentsError) {
    final announcementViewModel = AnnouncementViewModel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    print("************");
    print(_selectedDepartments);
   if (_selectedDepartments.length == 4 &&
    _selectedDepartments[0] == "Housekeeping" &&
    _selectedDepartments[1] == "Receptionist" &&
    _selectedDepartments[2] == "Kitchen" &&
    _selectedDepartments[3] == "Security") {
  _selectedDepartments = ["All"];
}
    print(_selectedDepartments);
    final result = await announcementViewModel.createAnnouncement(
      title: _titleController.text,
      message: _messageController.text,
      priorityLevel: _priorityLevel ?? "Normal",
      departments: _selectedDepartments,
    );

    // Close loading dialog

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['status'] ? Colors.green : Pallete.error700,
      ),
    );
    
   
    

    if (result['status']) {
      _formKey.currentState?.reset();
      setState(() {
        _priorityLevelController.clear();
        _departmentsController.clear();
        _priorityLevel = null;
        _selectedDepartments.clear();
      });
    }
    Navigator.pop(context);
    Navigator.pop(context);
     
    
  }
  
}


  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_outlined,color: Pallete.neutral900,)),
        title: Text("Create Announcement",
         style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral1000,
            ),
          ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [const SizedBox(height: 48,),
                 TextFormField(
  controller: _titleController,
  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Pallete.neutral700,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Pallete.primary700,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Pallete.error700,
        width: 2.0,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Pallete.error700,
        width: 2.0,
      ),
    ),
    labelText: "Announcement Title",
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Please enter an announcement title";
    }
    return null;
  },
),

                  const SizedBox(height: 38),
                  GestureDetector(
                    onTap: () => _showPriorityLevelBottomSheet(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _priorityLevelController,
                        decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.neutral700,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.primary700,
                    width: 2.0,
                  ),
                ),
                
                 errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.error700,
                    width: 2.0,
                  ),
                ),
                          labelText: "Priority Level",
                          border: InputBorder.none, // No border
                          errorText: _isPriorityLevelError
                              ? "Please select a priority level"
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  GestureDetector(
                    onTap: () => _showDepartmentSelectionBottomSheet(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        
                        controller: _departmentsController,
                        decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.neutral700,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.primary700,
                    width: 2.0,
                  ),
                ),
                 errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.error700,
                    width: 2.0,
                  ),
                ),
                          labelText: "Tag Departments",
                          border: InputBorder.none, // No border
                          errorText: _isDepartmentsError
                              ? "Please select at least one department"
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  TextFormField(
                  
                    controller: _messageController,
                    decoration: InputDecoration(
                       enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.neutral700,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.primary700,
                    width: 2.0,
                  ),
                ),
                 errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.error700,
                    width: 2.0,
                  ),
                ),
                      labelText: "Message",labelStyle: const TextStyle(
                        
                      ),
                      border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Pallete.primary700,
                    width: 1.0,
                  ),
                ), // No border
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a message";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.025,),
                  
                  if (!isKeyboardVisible(context)) 
    SizedBox(height: screenHeight * 0.178),
    
    if (!isKeyboardVisible(context)) 
              buildMainButton(
                      context: context,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      buttonText: "Post Announcement",
                      onPressed:_postAnnouncement,
                      
                      
                    ),
                  
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
