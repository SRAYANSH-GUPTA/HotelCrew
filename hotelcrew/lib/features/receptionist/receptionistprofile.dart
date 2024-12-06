import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../core/packages.dart';
import '../auth/view/pages/login_page.dart';
import '../dashboard/editprofile.dart'; 
import 'staffannouncement.dart';

class StaffProfilePage extends StatefulWidget {
  const StaffProfilePage({super.key});

  @override
  _StaffProfilePageState createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  String username = 'Loading...';
  String role = 'Loading...';
  String userProfile = '';
  bool isLoading = true;

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
      print(accessToken);
      if (response.statusCode == 200) {
        final data = response.data['user'];
        setState(() {
          username = data['user_name'] ?? 'Username not found';
          role = data['role'] ?? 'Role not found';
          userProfile = data['user_profile'] ?? '';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
        foregroundColor: Pallete.pagecolor,
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16, top: screenHeight * 0.0125),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffAnnouncementPage()));
              },
              splashColor: Colors.transparent, // Removes the splash effect
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/message.svg",
                height: screenWidth * 0.12,
                width: screenWidth * 0.12,
              ),
            ),
          )
        ],
        backgroundColor: Pallete.pagecolor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image with Pencil Icon
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: userProfile.isNotEmpty
                                ? NetworkImage(userProfile)
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
                                  'assets/profilepencil.svg', // Replace with your SVG path
                                  width: 16,
                                  height: 16,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                                  fetchUserData();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.15),
                      // Name and Role
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            role,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Pallete.neutral,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                // Menu Options
                Expanded(
                  child: ListView(
                    children: [
                      buildMenuItem(
                        img: SvgPicture.asset(
                          'assets/salaryprofile.svg',
                          height: 36,
                          width: 36,
                        ),
                        title: 'Salary',
                        trailing: SvgPicture.asset(
                          "assets/profileback.svg",
                          height: 16,
                          width: 22,
                        ),
                        onTap: () {},
                      ),
                      buildMenuItem(
                        img: SvgPicture.asset(
                          'assets/profilenotification.svg',
                          height: 36,
                          width: 36,
                        ),
                        title: 'Notifications',
                        trailing: SizedBox(
                          height: 16,
                          width: 31,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: true,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeTrackColor: Pallete.neutral500,
                              activeColor: Pallete.whitecolor,
                              onChanged: (value) {
                                // Handle notification toggle
                              },
                            ),
                          ),
                        ),
                      ),
                      buildMenuItem(
                        img: SvgPicture.asset(
                          'assets/profilepolicy.svg',
                          height: 36,
                          width: 36,
                        ),
                        title: 'Privacy Policy',
                        trailing: SvgPicture.asset(
                          "assets/profileback.svg",
                          height: 16,
                          width: 22,
                        ),
                        onTap: () {},
                      ),
                      buildMenuItem(
                        img: SvgPicture.asset(
                          'assets/profilehelp.svg',
                          height: 36,
                          width: 36,
                        ),
                        title: 'Help & Support',
                        trailing: SvgPicture.asset(
                          "assets/profileback.svg",
                          height: 16,
                          width: 22,
                        ),
                        onTap: () {},
                      ),
                      buildMenuItem(
                        img: SvgPicture.asset(
                          'assets/profilelogout.svg',
                          height: 36,
                          width: 36,
                        ),
                        title: 'Log Out',
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Helper method to create menu items
  Widget buildMenuItem({
    required Widget img,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: img,
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Pallete.neutral950,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  // Method to show the logout dialog
 void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Pallete.pagecolor, // Adjust color if needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.primary700, // Use your primary color
              foregroundColor: Pallete.neutral100, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("access_token");
              prefs.remove("refresh_token");
              prefs.remove("email");
              prefs.remove("Role");
              Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                      (Route<dynamic> route) => false,
                                    );
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  );
}
}