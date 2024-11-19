

import 'package:hotelcrew/features/hoteldetails/pages/page3.dart';
import 'package:hotelcrew/features/hoteldetails/pages/page4.dart';
import 'package:hotelcrew/features/hoteldetails/pages/page5.dart';
import 'package:hotelcrew/features/hoteldetails/pages/page6.dart';

import '../../core/packages.dart';
import 'package:flutter/material.dart';

class HotelDetailsEdit extends StatefulWidget {
  const HotelDetailsEdit({super.key});

  @override
  _HotelDetailsEditState createState() => _HotelDetailsEditState();
}

class _HotelDetailsEditState extends State<HotelDetailsEdit>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final List<String> pages = ['Basic Info', 'Property', 'Operational', 'Staff'];
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Details',
        style: TextStyle(
          fontSize: 16
        ),),
        backgroundColor: Pallete.primary400,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset("assets/pencil.svg",
            height: 24,
            width: 24,),
          )
        ],
        leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset("assets/pencil.svg",
            height: 24,
            width: 24,),
          )
      
      ),
      body: Column(
        children: [
          // Hotel Avatar and Name Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              height: 130,
              width: 99,
              child: Column(
                children: [
                  SizedBox(
                    height: 84,
                    width: 80,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/hotel_image.png'),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Text(
                    'Hotel Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Year est.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // TabBar to switch between different pages
          
      TabBar(
              // isScrollable: true,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600,
              fontSize: 14,
              
            ),
              controller: _tabController,
              labelPadding: const EdgeInsets.all(0),
              onTap: (index) {
                _pageController.jumpToPage(index);
                setState(() {
                  _currentIndex = index;
                });
              },
              indicatorColor: Pallete.primary700,
              labelColor: Pallete.neutral800,
              // unselectedLabelColor: Colors.grey,
              tabs: pages.map((title) => Tab(text: title)).toList(),
              dividerColor: Colors.transparent,
            ),
            
        
          Expanded(
            // PageView with builder
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _tabController.animateTo(index);
                });
              },
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const PageOne();
                  case 1:
                    return const PageTwo();
                  case 2:
                    return const PageThree();
                  case 3:
                    return const PageFour();
                  default:
                    return const Center(child: Text('Page not found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}