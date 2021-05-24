import './field.dart';

class Group {
  final String id;
  final String name;
  final String header;
  final List<Field> fields;
  Group({this.id, this.name, this.header, this.fields});

  factory Group.fromJson(Map<String, dynamic> json) {
    var list = json['fields'] as List;

    List<Field> fieldslist = list.map((i) => Field.fromJson(i)).toList();

    return Group(
        id: json['id'],
        name: json['name'],
        header: json['header'],
        fields: fieldslist);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["header"] = header;
    map["fields"] = fields;
    return map;
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "header": header, "fields": fields};
}
