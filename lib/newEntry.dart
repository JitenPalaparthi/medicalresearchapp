import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'apis/template.dart' as api_template;
import 'apis/projectData.dart' as api_projectData;
import 'models/template.dart' as model_template;
import 'models/group.dart' as model_group;
import 'models/field.dart' as model_field;
import 'models/projectData.dart' as model_projectData;
import 'apis/endpoints.dart';
import 'components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEntryPage extends StatefulWidget {
  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final mainKey = GlobalKey<ScaffoldState>();

  String _mySelection, token, role, email;
  bool isLoaded = false, isDDLoaded = false;
  model_template.Template templateData = new model_template.Template();
  model_projectData.ProjectData projectData;
  List<model_template.TemplateMetaData> listMetaData = [];

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    role = prefs.getString("role");
    var metaData = await api_template.Template().getTemplateMetaData(
        EndPoint.BASE_URL + EndPoint.GET_TEMPLATEMETADATA, token);

    setState(() {
      print(token);
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
      appBar: setAppbar(context, "New Medical Research Data"),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  print(_mySelection);
                });
                var data = await api_template.Template().getTemplateById(
                    EndPoint.BASE_URL +
                        EndPoint.GET_TEMPLATEBYID +
                        _mySelection,
                    token);
                setState(() {
                  templateData = data;
                  isLoaded = true;
                });
              },
              value: _mySelection,
            )),
        isLoaded
            ? Flexible(
                child: ListView.builder(
                // padding: const EdgeInsets.all(5.5),
                itemCount: 1,
                itemBuilder: _itemBuilder,
              ))
            : Container(
                margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                child: Text("Select a project to load required fields"))
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          submit();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }

  void submit() async {
    projectData = new model_projectData.ProjectData();
    projectData.fieldData = [];
    try {
      projectData.templateId = templateData.id;
      templateData.groups.forEach((element) {
        element.fields.forEach((field) {
          projectData.fieldData.add(new model_projectData.FieldData(
              fieldId: field.id, label: field.label, value: field.value));
        });
      });
      var result = await api_projectData.ProjectData().addProjectData(
          EndPoint.BASE_URL + EndPoint.ADD_PROJECTDATA, token, projectData);
      if (result.status == "success") {
        final snackBar =
            SnackBar(content: Text('Project data successfully saved'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text('Project data not saved'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: _getGroupWidgets(templateData.groups),
      ),
    );
  }

  List<Widget> _getGroupWidgets(List<model_group.Group> groups) {
    List<Widget> listWidgets = [];
    int gindex = 0;
    groups.forEach((element) {
      listWidgets.add(_getExpansionTileByGroup(element, gindex));
      gindex++;
    });
    return listWidgets;
  }

  List<Widget> _getWidgetList(List<model_field.Field> data, int gindex) {
    List<Widget> listWidgets = [];
    int findex = 0;
    data.forEach((element) {
      switch (element.control) {
        case "textField":
          listWidgets.add(_getTextField(element, gindex, findex));
          break;
        case "checkBox":
          listWidgets.add(_getCheckBox(element, gindex, findex));
          break;
        case "dropDown":
          listWidgets.add(_getDropDown(element, gindex, findex));
          break;
        case "datePicker":
          listWidgets.add(_getDatePicker(element, gindex, findex));
          break;
        default:
      }
      findex++;
    });
    return listWidgets;
  }

  Widget _getTextField(model_field.Field field, int gindex, findex) {
    return Container(
        width: 300,
        height: 75,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: TextField(
            key: Key(field.id),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(field.regEx))
            ],
            maxLines: 2,
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: field.label,
            ),
            onChanged: (text) {
              templateData.groups[gindex].fields[findex].value = text;
            }));
  }

  Widget _getCheckBox(model_field.Field field, int gindex, findex) {
    bool val = false;
    if (templateData.groups[gindex].fields[findex].defaults[0]
            .toString()
            .toLowerCase() ==
        "true") {
      val = true;
      templateData.groups[gindex].fields[findex].value = true;
    } else {
      val = false;
      templateData.groups[gindex].fields[findex].value = false;
    }
    return Container(
      width: 300,
      height: 75,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: field.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Checkbox(
          key: Key(field.id),
          checkColor: Colors.black,
          value: val,
          onChanged: (value) {
            setState(() {
              templateData.groups[gindex].fields[findex].value = value;
            });
          },
        ),
      ),
    );
  }

  Widget _getDatePicker(model_field.Field field, int gindex, findex) {
    return Container(
      width: 300,
      height: 75,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: field.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: OutlinedButton(
          onPressed: () async {
            //DateTime _date = DateTime(2020, 11, 17);
            final DateTime newDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2017, 1),
              lastDate: DateTime(2022, 7),
              helpText: 'Select a date',
            );
            if (newDate != null) {
              setState(() {
                // _date = newDate;
                var dateParse = DateTime.parse(newDate.toString());

                var formattedDate =
                    "${dateParse.day}-${dateParse.month}-${dateParse.year}";
                templateData.groups[gindex].fields[findex].value =
                    formattedDate;
              });
            }
          },
          child: Text(templateData.groups[gindex].fields[findex].value ??
              'Select Date'),
          key: Key(field.id),
        ),
        // //SizedBox(height: 8),
      ),
    );
  }

  Widget _getDropDown(model_field.Field field, int gindex, findex) {
    return Container(
      width: 300,
      height: 75,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: InputDecorator(
          decoration: InputDecoration(
            labelText: field.label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: DropdownButton<String>(
            key: Key(field.id),
            value: templateData.groups[gindex].fields[findex].value,
            onChanged: (String newValue) {
              setState(() {
                templateData.groups[gindex].fields[findex].value = newValue;
              });
            },
            items:
                field.defaults.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString()),
              );
            }).toList(),
          )),
    );
  }

  Widget _getExpansionTileByGroup(model_group.Group group, int gindex) {
    return Card(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
              child: Text(group.header)),
          Wrap(
              alignment: WrapAlignment.start,
              children: _getWidgetList(group.fields, gindex))
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      elevation: 5,
    );
  }
}
