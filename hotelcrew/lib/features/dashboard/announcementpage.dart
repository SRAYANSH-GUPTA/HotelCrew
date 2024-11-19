import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelcrew/core/packages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/packages.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final List<Announcement> announcements = [
    Announcement(
      title: "Monthly Staff Meeting Scheduled",
      description:
          "The next all-staff meeting is on March 15th at 2 PM in the main conference room. Prepare departmental updates and arrive on time. Attendance is mandatory for all department heads.",
      priority: "Urgent",
      department: "All Departments",
      role: "Admin",
      date: "1 March, 2024",
    ),
    Announcement(
      title: "Maintenance Alert: Pool Area",
      description:
          "The pool area will be closed from March 5-7 for repairs. Housekeeping, please coordinate guest notifications accordingly. Thank you for your cooperation.",
      priority: "Normal",
      department: "Housekeeping",
      role: "Manager",
      date: "5 March, 2024",
    ),
    Announcement(
      title: "Employee Wellness Program Launch",
      description:
          "We’re excited to announce the launch of our new wellness program for all employees. Join us for an informational session on February 20 at 3 PM in the lounge.",
      priority: "Normal",
      department: "All Departments",
      role: "Admin",
      date: "10 March, 2024",
    ),
  ];

  // Future<List<Announcement>> fetchAnnouncements() async {
  //   final response = await http.get(Uri.parse('https://api.example.com/announcements'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => Announcement.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load announcements');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_outlined,color: Pallete.neutral900,),
        titleSpacing: 0,
        title: Text(
          'Announcement',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Pallete.neutral1000,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:  ListView.builder(
          
              padding: const EdgeInsets.all(16.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return AnnouncementCard(announcement: announcement);
              },
            ),
      // FutureBuilder<List<Announcement>>(
      //   future: fetchAnnouncements(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return const Center(child: Text('No announcements available'));
      //     } else {
      //       final announcements = snapshot.data!;
      //       return ListView.builder(
      //         padding: const EdgeInsets.all(16.0),
      //         itemCount: announcements.length,
      //         itemBuilder: (context, index) {
      //           final announcement = announcements[index];
      //           return AnnouncementCard(announcement: announcement);
      //         },
      //       );
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
      shape: const CircleBorder(),
        onPressed: () {
          // Action for the FAB (e.g., open a new page to add an announcement)
        },
        backgroundColor: Pallete.primary700,
        child: InkWell(
          onTap: () {
            // Handle tap
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class Announcement {
  final String title;
  final String description;
  final String priority;
  final String department;
  final String role;
  final String date;

  Announcement({
    required this.title,
    required this.description,
    required this.priority,
    required this.department,
    required this.role,
    required this.date,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      department: json['department'],
      role: json['role'],
      date: json['date'],
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: announcement.priority == 'Urgent'
                        ? Colors.redAccent.withOpacity(0.2)
                        : Colors.greenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    announcement.priority,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: announcement.priority == 'Urgent' ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    announcement.department,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.title,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.description,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      announcement.role,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  announcement.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}