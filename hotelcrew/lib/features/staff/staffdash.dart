import '../../core/packages.dart';
import 'staffhome.dart';
import 'stafftaskpage.dart';
import '../receptionist/staffattendancepage.dart';
import '../receptionist/receptionistprofile.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  int _selectedIndex = 0;
  
  // List of pages to show in bottom nav
  final List<Widget> _pages = [
    const StaffHomePage(),
    const StaffTaskManagementPage(),
    const StaffAttendancePage(),
    const StaffProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 2,
            backgroundColor: Pallete.neutral100,
            selectedItemColor: Pallete.neutral1000,
            unselectedItemColor: Pallete.neutral600,
            selectedFontSize: 12, 
            unselectedLabelStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Pallete.neutral950
              ),
            ),// Same size as unselected
            selectedLabelStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Pallete.neutral950
              ),
            ),// Same size as unselected
            unselectedFontSize: 12, // Keep consistent
            enableFeedback: false, // Removes haptic feedback
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Pallete.primary300: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.elliptical(100, 90)), // Oval shape
                  ),
                  child: SvgPicture.asset(
                     _selectedIndex == 0 
                     ? 
                    'assets/shome.svg'
                
                    : 'assets/homenav.svg',
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.elliptical(100, 90)),
                  ),
                  child: SvgPicture.asset(
                    _selectedIndex == 1 ? 'assets/stask.svg' : 'assets/tasknav.svg',
                  ),
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.elliptical(100, 90)),
                  ),
                  child: SvgPicture.asset(
                    _selectedIndex == 2 ? 'assets/sschedule.svg' : 'assets/schedulenav.svg',
                  ),
                ),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.elliptical(100, 90)),
                  ),
                  child: SvgPicture.asset(
                    _selectedIndex == 3 ? 'assets/sprofile.svg' : 'assets/profilenav.svg',
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}