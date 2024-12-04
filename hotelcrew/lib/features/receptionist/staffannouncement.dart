import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:hotelcrew/core/packages.dart';

class StaffAnnouncementPage extends StatefulWidget {
  const StaffAnnouncementPage({super.key});

  @override
  _StaffAnnouncementPageState createState() => _StaffAnnouncementPageState();
}

class _StaffAnnouncementPageState extends State<StaffAnnouncementPage> {
  List<Announcement> announcements = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  String access_token = "";

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      print('Token is null or empty');
    } else {
      setState(() {
        access_token = token;
      });
      print('Token retrieved: $access_token');
    }
  }

  Future<void> fetchAnnouncements() async {
    await getToken();
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        'https://hotelcrew-1.onrender.com/api/taskassignment/announcements/?page=$page',
        options: Options(
          headers: {
            'Authorization': 'Bearer $access_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        setState(() {
          announcements.addAll(data.map((json) => Announcement.fromJson(json)).toList());
          hasMore = response.data['next'] != null;
          page++;
        });
      } else {
        showErrorSnackbar('Failed to load announcements');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        showErrorSnackbar('Connection timeout, please try again');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        showErrorSnackbar('Receive timeout, please try again');
      } else if (e.type == DioExceptionType.badResponse) {
        showErrorSnackbar('Bad response from server');
      } else {
        showErrorSnackbar('Unexpected error occurred');
      }
    } catch (e) {
      showErrorSnackbar('An unexpected error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.neutral00,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_outlined, color: Pallete.neutral900),
        ),
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
      body: isLoading && announcements.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
              ? const Center(child: Text('No Announcement'))
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading && hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      fetchAnnouncements();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: announcements.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == announcements.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final announcement = announcements[index];
                      return AnnouncementCard(announcement: announcement);
                    },
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
      priority: json['urgency'],
      department: json['department'],
      role: json['assigned_by'],
      date: json['created_at'],
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final localDate = DateFormat.yMMMd().add_jm().format(DateTime.parse(announcement.date).toLocal());

    return Card(
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
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: announcement.priority == 'Urgent' ? Pallete.accent200 : Pallete.success100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    announcement.priority,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: announcement.priority == 'Urgent' ? Pallete.accent800 : Pallete.success800,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/annuser.svg', height: 28, width: 28),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Pallete.neutral800,
                              height: 1.5,
                            ),
                          ),
                        ),
                        Text(
                          announcement.role,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Pallete.neutral800,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                localDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}