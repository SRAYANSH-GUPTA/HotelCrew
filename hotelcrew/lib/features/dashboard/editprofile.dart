import '../../core/packages.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined,
                color: Pallete.neutral900)),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral950,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Profile Image with Pencil Icon
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            const AssetImage('assets/profile_placeholder.png'),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              'assets/camera.svg', // Replace with your SVG path
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () {
                              // Add functionality to update profile picture
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // User Name and Role
                  Text(
                    'ABCDEF',
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Staff',
                    style: GoogleFonts.montserrat(
                        fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  // User Name Field
                  _buildTextFormField(
                    controller: nameController,
                    label: 'User Name',
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  _buildTextFormField(
                    controller: emailController,
                    label: 'Email',
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  // Change Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Add change password functionality
                      },
                      child: Text(
                        'Change Password',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Pallete.primary700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Save Changes Button at Bottom
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewPadding.bottom + 48,
            ),
            child: buildMainButton(
              context: context,
              screenWidth: screenWidth,
              buttonText: "Save Changes",
              onPressed: () {
                // Add save changes functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  // TextFormField Builder Function
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color(0xFFB0BEC5), width: 1.0), // Neutral700
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color(0xFFD32F2F), width: 2.0), // Error700
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              const BorderSide(color: Color(0xFF1976D2), width: 2.0), // Primary700
        ),
      ),
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  // Button Builder Function
  Widget buildMainButton({
    required BuildContext context,
    required double screenWidth,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth, 48), // Full-width button
        backgroundColor: Pallete.primary700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
