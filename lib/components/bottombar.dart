import '../homePage.dart';
import 'package:flutter/material.dart';
import '../newEntry.dart';
import '../viewRecords.dart';
import '../admin/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  String token, email, role;
  List<Widget> _children = [];
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    role = prefs.getString("role");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      new HomePage(),
      new ViewRecordsPage(
        title: "Medical Research",
      ),
      new NewEntryPage(),
      new UserPage(),
    ];
    return Scaffold(
        body: Container(child: _children[_currentIndex]),
        bottomNavigationBar: role == "admin"
            ? getBottomNavigationBarForAdmin()
            : getBottomNavigationBar());
    // bottomNavigationBar: getBottomNavigationBar());
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

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

  Widget getBottomNavigationBarForAdmin() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

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
        new BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users')
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
