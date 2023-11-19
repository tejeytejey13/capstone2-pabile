import 'package:capstone_project_pabile/client/screen/allstall.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project_pabile/client/screen/homepage.dart';
import 'package:capstone_project_pabile/client/screen/history.dart';
import 'package:capstone_project_pabile/client/screen/profilepage.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key});
  @override
  _BotNavBarState createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const Homepage(),
    const AllStalls(),
    const HistoryPage(),
    const ClientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            HapticFeedback.lightImpact();
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFE6E6E6),
        selectedItemColor: const Color(0xFF3876BF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Stalls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
