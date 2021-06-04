import 'package:flutter/material.dart';
import 'apis/template.dart' as api_template;
import 'apis/projectData.dart' as api_projectData;
import 'apis/user.dart' as api_user;
import 'models/template.dart' as model_template;
import 'models/projectData.dart' as model_projectData;
import 'apis/endpoints.dart';
import 'components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/foundation.dart';

class ViewRecordsPage extends StatefulWidget {
  final String title;
  @override
  _ViewRecordsPageState createState() => _ViewRecordsPageState();
  ViewRecordsPage({
    Key key,
    this.title,
  }) : super(key: key);
}

class _ViewRecordsPageState extends State<ViewRecordsPage> {
  String token, _mySelection, role, email;
  bool isLoaded = false, isDDLoaded = false, isRowView = false;
  List<model_projectData.ProjectData> projectData = [];
  List<model_template.TemplateMetaData> listMetaData = [];
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    role = prefs.getString("role");
    var metaData = await api_template.Template().getTemplateMetaData(
        EndPoint.BASE_URL + EndPoint.GET_TEMPLATEMETADATA, token);

    var data = await api_user.User()
        .getSummary(EndPoint.BASE_URL + EndPoint.GETSUMMARY, token);
    data.forEach((key, value) {
      print(key);
      print(value);
    });

    setState(() {
      listMetaData = metaData;
      isDDLoaded = true;
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
      appBar: setAppbar(context, "View Medical Research Data"),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                child: new DropdownButton(
                  items: listMetaData != null
                      ? listMetaData.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.project),
                            value: item.id,
                          );
                        }).toList()
                      : null,
                  hint: Text("Select Project"),
                  onChanged: (newVal) async {
                    setState(() {
                      _mySelection = newVal;
                    });
                    var pData = await api_projectData.ProjectData()
                        .getProjectDataByTemplateId(
                            EndPoint.BASE_URL +
                                EndPoint.GETALL_PROJECTDATA +
                                "/0/0/?_templateId=" +
                                _mySelection,
                            token,
                            0,
                            0);
                    setState(() {
                      projectData = pData;
                      isLoaded = true;
                    });
                  },
                  value: _mySelection,
                )),
            IconButton(
              icon: Icon(Icons.view_column),
              onPressed: () {
                setState(() {
                  isRowView = false;
                });
              },
              tooltip: "Column View",
            ),
            IconButton(
                icon: Icon(Icons.table_rows),
                onPressed: () {
                  setState(() {
                    isRowView = true;
                  });
                },
                tooltip: "Row View"),
          ],
        ),
        isLoaded && !isRowView
            ? Container(
                child: Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(5.5),
                  itemCount: projectData.length,
                  itemBuilder: _itemBuilder,
                ),
              ))
            : isLoaded && projectData.length > 0 && isRowView
                ? Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            showCheckboxColumn: true,
                            columns: _getColumns(projectData[0].fieldData),
                            rows: projectData.map((item) {
                              return _getRow(item.fieldData);
                            }).toList())))
                : Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    child: Text("Select a template to read the data.")),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download_rounded),
        onPressed: () async {
          var downloadURL = EndPoint.BASE_URL +
              EndPoint.DOWNLOAD_PROJECTDATABYID +
              "/" +
              _mySelection;
          if (kIsWeb) {
            html.AnchorElement anchorElement =
                new html.AnchorElement(href: downloadURL);
            anchorElement.download = downloadURL;
            anchorElement.click();
          } else {
            await _downloadFile(
                EndPoint.BASE_URL +
                    EndPoint.DOWNLOAD_PROJECTDATABYID +
                    "/" +
                    _mySelection,
                _mySelection + ".xlsx");

            // await http.get(url);
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      // height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 2,
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: _getWidgetListAll(projectData[index]),
        ),
      ),
    );
  }

  List<Widget> _getWidgetListAll(model_projectData.ProjectData details) {
    List<Widget> listWidgets = [];

    listWidgets.addAll(_getWidgetList(details.fieldData));

    listWidgets.add(Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: OutlinedButton(
          child: Text("Delete"),
          onPressed: () async {
            Widget cancelButton = OutlinedButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            );
            Widget continueButton = OutlinedButton(
              child: Text("Continue"),
              onPressed: () async {
                var response = await api_projectData.ProjectData()
                    .deleteProjectDataById(
                        EndPoint.BASE_URL + EndPoint.DELETE_PROJECTDATABYID,
                        details.id,
                        token);
                if (response.httpStatus == 200) {
                  final snackBar = SnackBar(
                      content: Text('projectData succcessfully deleted'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  //reload the page
                  var pData = await api_projectData.ProjectData()
                      .getProjectDataByTemplateId(
                          EndPoint.BASE_URL +
                              EndPoint.GETALL_PROJECTDATA +
                              "/0/0/?_templateId=" +
                              _mySelection,
                          "",
                          0,
                          0);
                  setState(() {
                    projectData = pData;
                    isLoaded = true;
                  });
                } else {
                  final snackBar =
                      SnackBar(content: Text('could not delete projectData'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                Navigator.pop(context);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("AlertDialog"),
              content: Text(
                  "Would you like to delete the record?It would be parmanently deleted"),
              actions: [
                cancelButton,
                continueButton,
              ],
            );

            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
        )));
    return listWidgets;
  }

  List<Widget> _getWidgetList(List<model_projectData.FieldData> data) {
    List<Widget> listWidgets = [];
    data.forEach((element) {
      var value;
      if (element.value.runtimeType == bool) {
        if (element.value) {
          value = "true";
        } else {
          value = "false";
        }
      } else {
        value = element.value;
      }
      listWidgets.add(_getBoxedContent(value, element.label, element.id));
    });
    return listWidgets;
  }

  Widget _getBoxedContent(String value, String heading, String name) {
    return Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: InputDecorator(
            decoration: InputDecoration(
              labelText: heading,
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              value ?? "",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )));
  }

  Future<File> _downloadFile(String url, String filename) async {
    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  List<DataColumn> _getColumns(List<model_projectData.FieldData> data) {
    List<DataColumn> columns = [];
    data.forEach((element) {
      columns.add(DataColumn(
        label: Text(
          element.label,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ));
    });
    return columns;
  }

  DataRow _getRow(List<model_projectData.FieldData> data) {
    List<DataCell> cells = [];
    data.forEach((element) {
      cells.add(DataCell(Text(element.value.toString())));
    });
    return DataRow(cells: cells);
  }

  String _boldtext(String heading) {
    return Text(
      heading,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ).toString();
  }
}
