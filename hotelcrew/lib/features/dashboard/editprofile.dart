import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../core/packages.dart';
import "dart:io";
import "../resetpass/resertpasspage/resetpass.dart";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String userProfile = '';
  String role = 'Loading...';
  bool isLoading = true;
  bool isUpdating = false;
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      final response = await Dio().get(
        'https://hotelcrew-1.onrender.com/api/edit/user_profile/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['user'];
        setState(() {
          nameController.text = data['user_name'] ?? 'Username not found';
          emailController.text = data['email'] ?? 'Email not found';
          userProfile = data['user_profile'] ?? '';
          role = data['role'] ?? 'Role not found';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserProfile() async {
    setState(() {
      isUpdating = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      FormData formData = FormData.fromMap({
        'user_name': nameController.text,
        'user_profile': selectedImage != null
            ? await MultipartFile.fromFile(selectedImage!.path, filename: 'profile.jpg')
            : null,
      });

      final response = await Dio().put(
        'https://hotelcrew-1.onrender.com/api/edit/user_profile/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['user'];
        prefs.setString('username', data['user_name'] ?? '');
        prefs.setString('user_profile', data['user_profile'] ?? '');
        setState(() {
          nameController.text = data['user_name'] ?? '';
          if(selectedImage != null)
          {
            userProfile = data['user_profile'] ?? '';
          }
          
        });
        // Refresh the page
        fetchUserData();
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
        backgroundColor: Pallete.pagecolor,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                              backgroundImage: userProfile.isNotEmpty
                                  ? (userProfile.startsWith('http')
                                      ? NetworkImage(userProfile)
                                      : FileImage(File(userProfile))) as ImageProvider
                                  : null,
                              child: userProfile.isEmpty
                                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                  : null,
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
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50,
                                      preferredCameraDevice: CameraDevice.front,
                                      maxHeight: 800,
                                      maxWidth: 800,
                                      requestFullMetadata: false,
                                    );
                                    if (image != null && image.path.endsWith('.jpg')) {
                                      setState(() {
                                        selectedImage = image;
                                        userProfile = image.path;
                                      });
                                    } else {
                                      // Show error message if the file is not a JPG
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please select a JPG file.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // User Name and Role
                        Text(
                          nameController.text,
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          emailController.text,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          role,
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
                          isEditable: false,
                        ),
                        const SizedBox(height: 20),
                        // Change Password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Resetpass()));
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
                if (!isKeyboardVisible)
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewPadding.bottom + 48,
                    ),
                    child: isUpdating
                        ? const CircularProgressIndicator()
                        : buildMainButton(
                            context: context,
                            screenWidth: screenWidth,
                            buttonText: "Save Changes",
                            onPressed: () {
                              updateUserProfile();
                              Navigator.pop(context);
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
    bool isEditable = true,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditable,
      decoration: InputDecoration(
        labelText: label,
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
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        suffixIcon: controller.text.isNotEmpty && isEditable
            ? IconButton(
                icon: SvgPicture.asset(
                  'assets/removeline.svg',
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  controller.clear();
                },
              )
            : null,
      ),
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Pallete.neutral950,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
        ),
      ),
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
        minimumSize: Size(screenWidth * 0.9, 48), // Full-width button
        backgroundColor: const Color(0xFF5662AC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}