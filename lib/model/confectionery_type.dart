import 'dart:convert';

class ConfectioneryType {
  final String id;
  final String name;

  ConfectioneryType(this.id, this.name);

  String toJson() {
    return json.encode({"id": this.id, "name": this.name});
  }

  Map<String, dynamic> toMap() {
    return {"id": this.id, "name": this.name};
  }
}
