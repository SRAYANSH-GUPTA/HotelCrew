import 'package:hotelcrew/features/hoteldetails/pages/staffdetails.dart';
import '../../../core/packages.dart';
class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9; // Adjust container width to 90% of screen width

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16), // Added right padding for symmetry
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDocumentContainer(
                context,
                title: 'Business License',
                description: 'Upload all business license documents for verification',
                containerWidth: containerWidth,
              ),
              const SizedBox(height: 24),
              buildDocumentContainer(
                context,
                title: 'Insurance Documents',
                description: 'Upload all insurance documents for verification',
                containerWidth: containerWidth,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Staffdetails(),
                    ),
                  );
                },
                child: buildDocumentContainer(
                  context,
                  title: 'Staff Details',
                  description: 'Upload staff details in excel sheet for their login credentials.',
                  containerWidth: containerWidth,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDocumentContainer(
    BuildContext context, {
    required String title,
    required String description,
    required double containerWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECF1F3),
        borderRadius: BorderRadius.circular(8),
      ),
      height: containerWidth * 0.29,
      width: containerWidth,
      child: Row(
        children: [
          Container(
            width: containerWidth * 0.8, // Adjusted width relative to parent container
            height: containerWidth * 0.37,
            margin: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10,),
                SizedBox(
                  height: 28,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFF121212),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: containerWidth * 0.14,
                  child: Text(
                    description,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Color(0xFF121212),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 24,
            width: 12,
            margin: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset(
              'assets/document_arrow.svg',
              height: 16.97,
              width: 9.48,
            ),
          ),
        ],
      ),
    );
  }
}
