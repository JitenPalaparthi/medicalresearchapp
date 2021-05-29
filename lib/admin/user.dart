import 'package:flutter/material.dart';
import '../helpers/httphelper.dart';
import '../apis/endpoints.dart';
import '../models/user.dart' as user_model;
import '../components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/user.dart' as api_user;

class UserPage extends StatefulWidget {
  UserPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String token, email, role;
  bool isloaded = false;
  List<user_model.User> data = []; //edited line
  final mainKey = GlobalKey<ScaffoldState>();
  final String url = EndPoint.BASE_URL + EndPoint.GET_USERS;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    role = prefs.getString("role");
    print("----------it is coming here?$token");

    var list = await api_user.User().getUsers(url, token, 0, 0);

    setState(() {
      print(list.length);
      data = list;
      isloaded = true;
    });
    //var list =  await HttpHelper().getBeneficiaries(url, token, 0, 0);
  }

  @override
  void initState() {
    super.initState();
    print("it is called?");
    this.getInit();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this.getInit();
    return Scaffold(
        appBar: setAppbar(context, "New Medical Research Data"),
        body: isloaded
            ? Container(
                child: FutureBuilder(builder: (context, snapshot) {
                  return DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Mobile',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Block/Un-Block',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: data.map((item) {
                      return DataRow(cells: <DataCell>[
                        DataCell(Text(item.name)),
                        DataCell(Text(item.email)),
                        DataCell(Text(item.mobile)),
                        DataCell(item.status == "active"
                            ? IconButton(
                                icon: Icon(Icons.block),
                                tooltip: "block the user",
                                onPressed: () async {
                                  await onSubmit(
                                      context, token, item.id, "inactive");
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.approval),
                                tooltip: "Un-block the user",
                                onPressed: () async {
                                  await onSubmit(
                                      context, token, item.id, "active");
                                })),
                      ]);
                    }).toList(),
                  );
                }),
                //UsersPage(),
                // This trailing comma makes auto-formatting nicer for build methods.
              )
            : Container(child: Text("Data yet to be loaded")));
  }

  Future<void> onSubmit(
      BuildContext context, String token, String id, String status) async {
    print(token);
    Map<String, dynamic> body = new Map<String, dynamic>();
    body["status"] = status;
    var result = await api_user.User().updateUserById(id, token, body);

    if (result.status == "success") {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          content: Text("Organization User Profile Updation Successful"),
          duration: Duration(milliseconds: 1000))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          content: Text("Organization User Profile Updation Unsuccessful"),
          duration: Duration(milliseconds: 1000))));
    }
    getInit();
  }
}
