// ignore_for_file: library_private_types_in_public_api

import 'package:capstone_project_pabile/stall/additem.dart';
import 'package:capstone_project_pabile/stall/homepage.dart';
import 'package:capstone_project_pabile/stall/orders.dart';
import 'package:capstone_project_pabile/stall/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StallBotNavBar extends StatefulWidget {
  const StallBotNavBar({super.key});
  @override
  _StallBotNavBarState createState() => _StallBotNavBarState();
}

class _StallBotNavBarState extends State<StallBotNavBar> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const Orders(),
    const AddItem(),
    // const Lists(),
    const StallProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
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
        backgroundColor: const Color(0xFFE6E6E6),
        selectedItemColor: const Color(0xFF3876BF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Food Lists',
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
