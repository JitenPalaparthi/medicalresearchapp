class ProjectData {
  final String id;
  String templateId;
  String enterdBy;
  List<FieldData> fieldData;
  final String status;
  final String lastUpdated;

  ProjectData(
      {this.id,
      this.templateId,
      this.enterdBy,
      this.fieldData,
      this.status,
      this.lastUpdated});

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    var list = json['fieldData'] as List;

    List<FieldData> fieldData = list.map((i) => FieldData.fromJson(i)).toList();

    return ProjectData(
      id: json['id'],
      templateId: json['templateId'],
      enterdBy: json['enteredBy'],
      fieldData: fieldData,
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'fieldData': fieldData,
      'enteredBy': enterdBy,
      'status': status,
      'lastUpdated': lastUpdated,
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["templateId"] = templateId;
    map["fieldData"] = fieldData;
    map["enteredBy"] = enterdBy;
    map["status"] = status;
    map["lastUpdated"] = lastUpdated;
    return map;
  }
}

class FieldData {
  final String id;
  final String fieldId;
  final String label;
  final dynamic value;
  FieldData({this.id, this.fieldId, this.label, this.value});
  factory FieldData.fromJson(Map<String, dynamic> json) {
    return FieldData(
      id: json['id'],
      fieldId: json['fieldId'],
      label: json['label'],
      value: json['value'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldId': fieldId,
      'label': label,
      'value': value,
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["fieldId"] = fieldId;
    map["label"] = label;
    map["value"] = value;
    return map;
  }
}
