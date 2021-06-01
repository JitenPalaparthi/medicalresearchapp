import 'package:flutter/material.dart';
import 'apis/user.dart' as api_user;
import 'apis/endpoints.dart';
import 'components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

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
  String token, role, email;
  bool isLoaded = false;
  Map<String, dynamic> summaryData;
  List<dynamic> groupData = [];
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
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
      drawer: Container(),
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
