import '../homePage.dart';
import 'package:flutter/material.dart';
import '../newEntry.dart';
import '../viewRecords.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  @override
  Widget build(BuildContext context) {
    _children = [
      HomePage(),
      ViewRecordsPage(
        title: "Medical Research",
      ),
      NewEntryPage(),
    ];
    return Scaffold(
        body: Container(child: _children[_currentIndex]),
        bottomNavigationBar: getBottomNavigationBar());
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      unselectedLabelStyle:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      onTap: onTabTapped, // new
      currentIndex: _currentIndex, // new
      items: [
        new BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.view_comfortable),
          label: 'View Records',
        ),
        new BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'New Entry'),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
