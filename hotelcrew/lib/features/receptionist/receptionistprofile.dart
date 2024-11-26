import '../../core/packages.dart';
import '../../providers/notification.dart';






class StaffProfilePage extends ConsumerWidget {
  const StaffProfilePage({super.key});






  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final isNotificationEnabled = ref.watch(notificationProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(backgroundColor: Pallete.pagecolor,
      appBar: AppBar(foregroundColor: Pallete.pagecolor,
        title: Text('Profile',
        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
        ),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_outlined,color: Pallete.neutral900,)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16,top: screenHeight*0.0125),
            child: InkWell(onTap: (){
            
            },
            splashColor: Colors.transparent, // Removes the splash effect
  highlightColor: Colors.transparent, 
            child: SvgPicture.asset("assets/message.svg",
            height: screenWidth* 0.12,
            width: screenWidth* 0.12,),),
          )
        ],
        backgroundColor: Pallete.pagecolor,
        elevation: 0,
      ),
      body: 
      Column(
        children: [
          // Profile Header Section
          Container(
            // color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image
                const CircleAvatar(
                  radius: 40,
        
                   foregroundImage: AssetImage("assets/image.png"),
                ),
                SizedBox(width: screenWidth* 0.15),
                // Name and Role
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ABCDEF',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Admin',
                      style: TextStyle(
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
                  img: SvgPicture.asset('assets/salaryprofile.svg',
                  height: 36,
                  width: 36,),
                  title: 'Salary',
                  trailing: SvgPicture.asset("assets/profileback.svg",
      height: 16,
      width: 22,),
                  onTap: () {},
                ),
                
                buildMenuItem(
                  img: SvgPicture.asset('assets/profilenotification.svg',
                  height: 36,
                  width: 36,),
                  title: 'Notifications',
                  trailing: SizedBox(
                    // color:Colors.blue,
                    height: 16,
                    width: 31,
                    child: Transform.scale(
                      scale: 0.7,
                      child: 
                        Switch(
                          value: isNotificationEnabled,
                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                          activeTrackColor: Pallete.neutral500,
                          activeColor: Pallete.whitecolor,
                          onChanged: (value) {
                               ref.read(notificationProvider.notifier).toggleNotification();
                                print(isNotificationEnabled);

                          },
                        ),
                      
                    ),
                  ),
                ),
                buildMenuItem(
                 img: SvgPicture.asset('assets/profilepolicy.svg',
                  height: 36,
                  width: 36,),
                  title: 'Privacy Policy',
                  trailing: SvgPicture.asset("assets/profileback.svg",
      height: 16,
      width: 22,),
                  onTap: () {},
                ),
                buildMenuItem(
                  img: SvgPicture.asset('assets/profilehelp.svg',
                  height: 36,
                  width: 36,),
                  title: 'Help & Support',
                  trailing: SvgPicture.asset("assets/profileback.svg",
      height: 16,
      width: 22,),
                  onTap: () {},
                ),
                buildMenuItem(
                 img: SvgPicture.asset('assets/profilelogout.svg',
                  height: 36,
                  width: 36,),
                  title: 'Log Out',
                 
                  onTap: () {},
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
      title: Text(title,
      style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Pallete.neutral950,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),),
      trailing: trailing,
      onTap: onTap,
    );
  }
}