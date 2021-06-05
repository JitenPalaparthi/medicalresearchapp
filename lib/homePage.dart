import 'package:flutter/material.dart';
import 'apis/user.dart' as api_user;
import 'apis/endpoints.dart';
import 'components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicalresearchapp/drawer/userProfile.dart';
import 'package:flutter/foundation.dart';
import '../drawer/about.dart';
import '../drawer/help.dart';
import '../drawer/contact.dart';

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
  String token, role, email, name;
  bool isLoaded = false;
  Map<String, dynamic> summaryData;
  List<dynamic> groupData = [];
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");

    role = prefs.getString("role");

    var data = await api_user.User()
        .getSummary(EndPoint.BASE_URL + EndPoint.GETSUMMARY, token);

    setState(() {
      isLoaded = true;
      summaryData = data;
      if (summaryData["projectData_groupby_project_count"] != null) {
        groupData = Cast<List<dynamic>>()
            .f(summaryData["projectData_groupby_project_count"]);
        print(groupData[0].runtimeType);
      }
      summaryData.forEach((key, value) {
        print(key);
        print(value);
        print(value.runtimeType);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  dispose() {
    super.dispose();
  }

//fontSize: 20.0,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "Medical Research"),
      drawer: _drawer(context),
      body: isLoaded
          ? Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 300,
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Text("Summary",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ))),
                Container(
                    width: 300,
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total number of users:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              )),
                          Text(summaryData["no_of_users"].toString() ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ))
                        ])),
                Container(
                    width: 300,
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total number of projects:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(summaryData["no_of_projects"].toString() ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ))
                        ])),
                Container(

                    //margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: FutureBuilder(builder: (context, snapshot) {
                  return DataTable(
                    showBottomBorder: true,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Project',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                      DataColumn(
                        label: Text(
                          'Data Count',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ),
                    ],
                    rows: groupData.length > 0
                        ? groupData.map((item) {
                            return DataRow(cells: <DataCell>[
                              DataCell(Text(item["project"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0))),
                              DataCell(Text(item["count"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0))),
                            ]);
                          }).toList()
                        : null,
                  );
                })),
              ],
            ))
          : Container(),
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
          ListTile(
            title: Text('About'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => About()));
            },
          ),
          ListTile(
            title: Text('Help'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Helppage()));
            },
          ),
          ListTile(
            title: Text('Contact'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ContactPAge()));
            },
          ),
        ],
      ),
    );
  }
}

class Cast<T> {
  T f(x) {
    if (x is T) {
      return x;
    } else {
      return null;
    }
  }
}
