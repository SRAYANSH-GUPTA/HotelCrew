import "../../core/packages.dart";
import 'viewmodel/createtaskviewmodel.dart';
import 'model/createtaskmodel.dart';
import '../../core/widgets.dart';


class EditTaskPage extends StatefulWidget {
  final String taskTitle;
  final String department;
  final String description;
  final int id;

  const EditTaskPage({
    super.key,
    required this.taskTitle,
    required this.department,
    required this.description,
    required this.id,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> departments = ['Housekeeping', 'Receptionist', 'Kitchen', 'Security'];
  final TaskViewModel taskViewModel = TaskViewModel();

  
@override
void initState() {
  super.initState();
  titleController.text = widget.taskTitle;
  departmentController.text = widget.department;
  descriptionController.text = widget.description;
}



  void _showDepartmentSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
    ),
    builder: (context) => Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Departments',
                style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral950,
            ),
              ),),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        // const Divider(height: 1),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: departments.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(departments[index], style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral950,
            ),
              ),),
            onTap: () {
              departmentController.text = departments[index];
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}

  Future<void> _submitTask() async {
    if(context.loaderOverlay.visible)
    {
      return;
    }
    context.loaderOverlay.show();
    if (_formKey.currentState!.validate()) {
      Task newTask = Task(
        title: titleController.text,
        department: departmentController.text,
        deadline: deadlineController.text.isNotEmpty ? deadlineController.text : null,
        description: descriptionController.text,
      );
      

      try {
        await taskViewModel.assignTask(newTask);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Created Successfully')),
        );
        _clearForm();
        context.loaderOverlay.hide();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        context.loaderOverlay.hide();
      }
      
    }
    context.loaderOverlay.hide();
  }

  void _clearForm() {
    titleController.clear();
    departmentController.clear();
    deadlineController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
   final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GlobalLoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {Navigator.pop(context);},
            child: const Icon(Icons.arrow_back_ios_outlined,color: Pallete.neutral900,)),
          title: Text("Edit Task",
           style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Pallete.neutral1000,
              ),
            ),),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [SizedBox(height:40),
                    _buildTextFormField(
                      controller: titleController,
                      label: 'Task Title',
                      isRequired: true,
                    ),
                    SizedBox(height:38),
                    
                    GestureDetector(
                      onTap: _showDepartmentSheet,
                      child: AbsorbPointer(
                        child: _buildTextFormField(
                          controller: departmentController,
                          label: 'Department',
                          isRequired: true,
                        ),
                      ),
                    )
                    ,
                    SizedBox(height:38),
                    _buildTextFormField(
                      controller: deadlineController,
                      label: 'Deadline (optional)',
                      isRequired: false,
                    ),
                    //descriptionController
                    SizedBox(height:38),
                    _buildTextFormField(
                      controller: descriptionController,
                      label: 'Description',
                      isRequired: true,
                       maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Only show the button if the keyboard is not visible
            if (!isKeyboardVisible)
              Positioned(
                bottom: MediaQuery.of(context).viewPadding.bottom + 48, // 48 above the navigation bar
                left: 16,
                right: 16,
                child: 
                buildMainButton(
                        context: context,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        buttonText: "Update Task",
                        onPressed: _submitTask,
                        
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
  required TextEditingController controller,
  required String label,
  bool isRequired = false,
  int maxLines = 1, // Updated maxLines property
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Pallete.error700, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
      ),
    ),
    maxLines: maxLines,
    // minLines: maxLines > 1 ? 3 : 1, // Show at least 3 lines if maxLines > 1
    keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
    validator: (value) {
      if (isRequired && (value == null || value.isEmpty)) {
        return 'This field is required';
      }
      return null;
    },
  );
}

}
