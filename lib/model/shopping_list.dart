import 'dart:convert';

import 'package:SweetLife/model/shopping_list_element.dart';

class ShoppingList {
  String id;
  String name;
  List<ShoppingListElement> elements;
  DateTime auditCD;
  String auditCU;

  ShoppingList(this.id, this.name, this.elements, this.auditCD, this.auditCU);

  int get activeElementsQuantity {
    return elements.where((element) => element.active).toList().length;
  }

  ShoppingList.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    this.name = json['name'];
    this.auditCD = DateTime.parse(json['auditCD']);
    this.auditCU = json['auditCU'];
    this.elements = json.containsKey('elements')
        ? (json['elements'] as List)
            .map((element) => ShoppingListElement(element['amount'],
                element['ingredient'], element['unit'], element['active']))
            .toList()
        : List<ShoppingListElement>.empty();
  }

  String toJson() {
    return json.encode({
      "name": this.name,
      "auditCD": this.auditCD.toIso8601String(),
      "auditCU": this.auditCU,
      "elements": this.elements.map((element) => element.toMap()).toList()
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "auditCD": this.auditCD.toIso8601String(),
      "auditCU": this.auditCU,
      "elements": this.elements.map((element) => element.toMap()).toList()
    };
  }
}
