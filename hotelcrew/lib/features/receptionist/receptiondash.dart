import 'package:flutter/material.dart';
import '../../core/packages.dart';
import 'recepitonhome.dart';
import 'staffattendancepage.dart';
import 'receptionistprofile.dart';
import '../dashboard/gettaskpage.dart';
class ReceptionDashboardPage extends StatefulWidget {
  const ReceptionDashboardPage({super.key});

  @override
  State<ReceptionDashboardPage> createState() => _ReceptionDashboardPageState();
}

class _ReceptionDashboardPageState extends State<ReceptionDashboardPage> {
  int _selectedIndex = 0;
  
  // List of pages to show in bottom nav
  final List<Widget> _pages = [
    const ReceptionistDashHomePage(),
    const TaskManagementPage(),
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Pallete.primary300: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.elliptical(100, 60)), // Oval shape
                  ),
                  child: SvgPicture.asset(
                    _selectedIndex == 0 
                        ? 'assets/homenav_selected.svg'
                        : 'assets/homenav.svg',
                    color: _selectedIndex == 0 ? Pallete.primary800 : Pallete.neutral600,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.elliptical(100, 60)),
                  ),
                  child: SvgPicture.asset(
                    'assets/tasknav.svg',
                    color: _selectedIndex == 1 ? Pallete.primary800 : Pallete.neutral600,
                  ),
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.elliptical(100, 60)),
                  ),
                  child: SvgPicture.asset(
                    'assets/schedulenav.svg',
                    color: _selectedIndex == 2 ? Pallete.primary800 : Pallete.neutral600,
                  ),
                ),
                label: 'Shifts',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3 ? Pallete.primary300 : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.elliptical(100, 60)),
                  ),
                  child: SvgPicture.asset(
                    _selectedIndex == 3 
                        ? 'assets/selectedprofilenav.svg'
                        : 'assets/profilenav.svg',
                    color: _selectedIndex == 3 ? Pallete.primary800 : Pallete.neutral600,
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