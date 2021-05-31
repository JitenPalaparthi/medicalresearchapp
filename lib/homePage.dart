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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppbar(context, "Medical Research"),
      drawer: Container(),
      body: isLoaded
          ? Container(
              child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Row(children: [
                      Text("Total number of users:"),
                      Text(summaryData["no_of_users"].toString() ?? "")
                    ])),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Row(children: [
                      Text("Total number of projects:"),
                      Text(summaryData["no_of_projects"].toString() ?? "")
                    ])),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: FutureBuilder(builder: (context, snapshot) {
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Project',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Data Count',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: groupData.length > 0
                            ? groupData.map((item) {
                                return DataRow(cells: <DataCell>[
                                  DataCell(Text(item["project"].toString())),
                                  DataCell(Text(item["count"].toString())),
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
