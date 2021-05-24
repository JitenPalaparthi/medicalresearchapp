class Field {
  final String id;
  final String name;
  final String label;
  final String type;
  final String control;
  List<dynamic> defaults;
  final bool required;
  final String regEx;
  dynamic value;

  Field({
    this.id,
    this.name,
    this.label,
    this.type,
    this.control,
    this.defaults,
    this.required,
    this.regEx,
    this.value,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      label: json['label'],
      type: json['type'],
      control: json['control'],
      required: json['required'],
      regEx: json['regEx'],
      defaults: json['defaults'],
      value: json["value"],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map["name"] = name;
    map["label"] = label;
    map["type"] = type;
    map['control'] = control;
    map["required"] = required;
    map["regEx"] = regEx;
    map["defaults"] = defaults;
    map['value'] = value;
    return map;
  }
}
