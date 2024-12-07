import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Replace with your model path
 // Replace with your utility package imports
import 'createannouncementpage.dart';
import 'model/getannouncementmodel.dart';
import 'package:intl/intl.dart';
import "../../core/packages.dart";

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Announcement> _announcements = [];
  bool _isLoading = true;
  String? _nextPageUrl;
  String email = "";
  String role = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    getEmailAndRole();
    fetchAnnouncements(); // Fetch initial announcements
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels > 0) {
        if (_nextPageUrl != null) {
          fetchAnnouncements(url: _nextPageUrl); // Fetch next page
        }
      }
    });
  }

  Future<void> getEmailAndRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String emails = prefs.getString('email') ?? '';
    final String roles = prefs.getString('Role') ?? '';
    setState(() {
      email = emails;
      role = roles;
    });
  }

  Future<void> fetchAnnouncements({String? url}) async {
    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("Access token not found");
      }

      final String apiUrl = url ?? 'https://hotelcrew-1.onrender.com/api/taskassignment/announcements/?page=1';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          _announcements.addAll(results.map((json) => Announcement.fromJson(json)).toList());
          _nextPageUrl = data['next'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch announcements');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.pagecolor,
      appBar: AppBar(
        foregroundColor: Pallete.pagecolor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900)),
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
        backgroundColor: Pallete.pagecolor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading && _announcements.isEmpty
          ? Center(
              child: SvgPicture.asset(
                "assets/noannouncement.svg",
                height: 316,
                width: 328,
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _announcements.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/emptyannouncement.svg', // Replace with your SVG file path
                                width: 328,
                                height: 316,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _announcements.length + (_nextPageUrl != null ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _announcements.length) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final announcement = _announcements[index];
                            return AnnouncementCard(
                              announcement: announcement,
                              currentUserEmail: email,
                              currentUserRole: role,
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAnnouncementPage()));
          _announcements.clear();
          _nextPageUrl = null;
          fetchAnnouncements(); // Refresh announcements after creation
        },
        backgroundColor: Pallete.primary700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final String currentUserEmail; // The email to compare with
  final String currentUserRole; // The role to compare with

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.currentUserEmail, // Accept the email to compare with
    required this.currentUserRole, // Accept the role to compare with
  });

  @override
  Widget build(BuildContext context) {
  // Check if the assignedBy email and role match the current user's email and role
  bool isCurrentUser = announcement.assignedBy == '$currentUserEmail ($currentUserRole)';

  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft, // Align entire card
    child: Card(
      margin: isCurrentUser ? const EdgeInsets.only(left: 50, bottom: 16) : const EdgeInsets.only(right: 50, bottom: 16), // Add margin to the side opposite the user
      color: Pallete.primary50,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Pallete.primary200, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: announcement.urgency == 'Urgent'
                        ? Pallete.accent200
                        : Pallete.success100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    announcement.urgency,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: announcement.urgency == 'Urgent' ? Pallete.accent800 : Pallete.success800,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Pallete.primary200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/anndept.svg', height: 12, width: 12),
                      const SizedBox(width: 4),
                      Text(
                        announcement.department,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Pallete.neutral800,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.description,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Pallete.neutral900,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
  child: Row(
    children: [
      SvgPicture.asset('assets/annuser.svg', height: 28, width: 28),
      const SizedBox(width: 4),
      Expanded( // Wrap the Column with Expanded
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 12,
                color: Pallete.neutral800,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            Text(
              announcement.assignedBy,
              style: const TextStyle(
                fontSize: 12,
                color: Pallete.neutral800,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
              maxLines: 2, // Limits to 2 lines
            ),
          ],
        ),
      ),
    ],
  ),
),
              ],
            ),
            // Display the creation time of the announcement
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('dd-MMM hh:mm a').format(
                  DateTime.parse(announcement.createdAt).toLocal(),
                ),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
