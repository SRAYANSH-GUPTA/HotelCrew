import 'package:hotelcrew/core/packages.dart';
import 'createannouncementpage.dart';
import "viewmodel/getannouncement.dart";
import 'model/getannouncementmodel.dart';
import 'package:provider/provider.dart' as provider;
import 'package:intl/intl.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final ScrollController _scrollController = ScrollController();
  String email = "";
  String role = "";

  @override
  void initState() {
    super.initState();
    getEmailAndRole();
    // Fetch initial announcements when the page is loaded
    context.read<AnnouncementViewModel>().fetchAnnouncements();

    // Add listener to detect when the user scrolls to the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels > 0) {
        // Check if there's a next page to load
        if (context.read<AnnouncementViewModel>().getNextPageUrl() != null) {
          // Fetch the next page
          context.read<AnnouncementViewModel>().fetchAnnouncements(url: context.read<AnnouncementViewModel>().getNextPageUrl());
        }
      }
    });
  }

  Future<void> getEmailAndRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String emails = prefs.getString('email') ?? '';
    final String roles = prefs.getString('Role') ?? '';
    print(emails);
    print(roles);
    setState(() {
      email = emails;
      role = roles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.neutral00,
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
      body: provider.Consumer<AnnouncementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.announcements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              controller: _scrollController,  // Attach scroll controller
              itemCount: viewModel.announcements.length + (viewModel.getNextPageUrl() != null ? 1 : 0),  // Add 1 for the loading indicator if there's a next page
              itemBuilder: (context, index) {
                if (index == viewModel.announcements.length) {
                  // Display a loading indicator at the end if there's more data to load
                  return const Center(child: CircularProgressIndicator());
                }
                final announcement = viewModel.announcements[index];
                return AnnouncementCard(
                  announcement: announcement,
                  currentUserEmail: email, // Pass the email to compare with
                  currentUserRole: role, // Pass the role to compare with
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAnnouncementPage()));
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
        // margin: const EdgeInsets.only(bottom: 16),
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
                  Row(
                    children: [
                      SvgPicture.asset('assets/annuser.svg', height: 28, width: 28),
                      const SizedBox(width: 4),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text(
                          'Username',
                          style: TextStyle(fontSize: 12, color: Pallete.neutral800, fontWeight: FontWeight.w700, height: 1.5),
                        ),
                        Text(
                          announcement.assignedBy,
                          style: const TextStyle(fontSize: 12, color: Pallete.neutral800, fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
              // Display the creation time of the announcement
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(
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
