import './group.dart';

class Template {
  final String id;
  final String project;
  final List<Group> groups;
  final String status;
  final String lastUpdated;
  Template({this.id, this.project, this.groups, this.status, this.lastUpdated});

  factory Template.fromJson(Map<String, dynamic> json) {
    var list = json['groups'] as List;

    List<Group> groupsList = list.map((i) => Group.fromJson(i)).toList();

    return Template(
      id: json['id'],
      project: json['project'],
      groups: groupsList,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["project"] = project;
    map["groups"] = groups;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }
}

class TemplateMetaData {
  final String id;
  final String project;
  TemplateMetaData({this.id, this.project});
  factory TemplateMetaData.fromJson(Map<String, dynamic> json) {
    return TemplateMetaData(
      id: json['id'],
      project: json['project'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["project"] = project;
    return map;
  }
}
