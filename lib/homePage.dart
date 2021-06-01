import 'package:flutter/material.dart';
import 'components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicalresearchapp/drawer/userProfile.dart';

class HomePage extends StatefulWidget {
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
  HomePage({
    Key key,
    this.title,
  }) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  String token, email, name;
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    print("TOKEN========$token");
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "Medical Research"),
      drawer: _drawer(context),
      body: Container(),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                Text('Hello $name'),
                SizedBox(height: 5),
                Text('Registered Email: $email'),
                SizedBox(height: 5),
                OutlineButton(
                  child: Text("Edit Profile"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserProfilePage()))
                        .then((value) {
                      if (value == true) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Profile Updation Successful"),
                            duration: Duration(milliseconds: 1000)));
                      } else if (value == false) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Profile Updation Failed"),
                            duration: Duration(milliseconds: 1000)));
                      } else {}
                      // Run the code here using the value
                    });
                  },
                )
              ],
            ), //Text('Hello $name'),
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }
}
