import '../../../core/packages.dart';
import 'dart:convert';

class PageFive extends StatefulWidget {
  const PageFive({super.key});

  @override
  _PageFiveState createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {
  final TextEditingController numberOfRoomsController = TextEditingController();
  final List<TextEditingController> roomTypeControllers = [];
  final List<TextEditingController> roomCountControllers = [];
  final List<TextEditingController> roomPriceControllers = [];
  final FocusNode numberOfRoomsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the page is initialized
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      numberOfRoomsController.text = prefs.getString('numberOfRooms') ?? '0';
      int numberOfRooms = int.tryParse(numberOfRoomsController.text) ?? 0;
      for (int i = 0; i < numberOfRooms; i++) {
        roomTypeControllers.add(TextEditingController(text: prefs.getString('roomType_$i') ?? ''));
        roomCountControllers.add(TextEditingController(text: prefs.getString('roomCount_$i') ?? ''));
        roomPriceControllers.add(TextEditingController(text: prefs.getString('roomPrice_$i') ?? ''));
      }
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('numberOfRooms', numberOfRoomsController.text);
    List<Map<String, dynamic>> rooms = [];
    for (int i = 0; i < roomTypeControllers.length; i++) {
      rooms.add({
        "room_type": roomTypeControllers[i].text,
        "count": int.tryParse(roomCountControllers[i].text) ?? 0,
        "price": roomPriceControllers[i].text,
      });
      print(rooms);
      
      prefs.setString('roomType_$i', roomTypeControllers[i].text);
      prefs.setString('roomCount_$i', roomCountControllers[i].text);
      prefs.setString('roomPrice_$i', roomPriceControllers[i].text);
    }
    prefs.setString('rooms', jsonEncode(rooms));
    print(prefs.getString('rooms'));
  }

  void _generateRoomFields() {
    int numberOfRooms = int.tryParse(numberOfRoomsController.text) ?? 0;
    roomTypeControllers.clear();
    roomCountControllers.clear();
    roomPriceControllers.clear();
    for (int i = 0; i < numberOfRooms; i++) {
      roomTypeControllers.add(TextEditingController());
      roomCountControllers.add(TextEditingController());
      roomPriceControllers.add(TextEditingController());
    }
    setState(() {});
  }

  @override
  void dispose() {
    numberOfRoomsController.dispose();
    for (var controller in roomTypeControllers) {
      controller.dispose();
    }
    for (var controller in roomCountControllers) {
      controller.dispose();
    }
    for (var controller in roomPriceControllers) {
      controller.dispose();
    }
    numberOfRoomsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 24, left: screenWidth * 0.045, right: screenWidth * 0.045),
      child: SizedBox(
        height: 392,
        width: screenWidth * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Number of Rooms
              SizedBox(
                height: 86,
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 22),
                  child: TextFormField(
                    controller: numberOfRoomsController,
                    focusNode: numberOfRoomsFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number Of Rooms',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/plus.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              int currentValue = int.tryParse(numberOfRoomsController.text) ?? 0;
                              numberOfRoomsController.text = (currentValue + 1).toString();
                              numberOfRoomsController.selection = TextSelection.fromPosition(
                                TextPosition(offset: numberOfRoomsController.text.length),
                              );
                              _generateRoomFields();
                              _saveData();
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/minus.svg',
                              height: 24,
                              width: 24,
                            ),
                            onPressed: () {
                              int currentValue = int.tryParse(numberOfRoomsController.text) ?? 0;
                              if (currentValue > 0) {
                                numberOfRoomsController.text = (currentValue - 1).toString();
                                numberOfRoomsController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: numberOfRoomsController.text.length),
                                );
                                _generateRoomFields();
                                _saveData();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Pallete.neutral950,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    onChanged: (value) {
                      _generateRoomFields();
                      _saveData();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Room Type, Count, and Price Fields
              for (int i = 0; i < roomTypeControllers.length; i++)
                Column(
                  children: [
                    SizedBox(
                      height: 86,
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: roomTypeControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Room Type ${i + 1}',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.neutral950,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: roomCountControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Room Count ${i + 1}',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.neutral950,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 22),
                        child: TextFormField(
                          controller: roomPriceControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Room Price ${i + 1}',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.neutral700, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Pallete.primary700, width: 2.0),
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Pallete.neutral950,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.primary700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
