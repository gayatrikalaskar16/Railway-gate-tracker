import 'package:flutter/material.dart';
import 'package:manage_realway/FindRouteScreen.dart';
import 'package:manage_realway/ProfileScreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    FindRouteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index on tab change
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: 'Find Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green, // Color for selected items
        unselectedItemColor: Colors.grey, // Color for unselected items
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Fixed layout for items
        backgroundColor: Colors.white, // Background color of the bar
        elevation: 10, // Shadow elevation for the bar
      ),
    );
  }
}
