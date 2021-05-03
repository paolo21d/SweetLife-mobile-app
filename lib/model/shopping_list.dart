import 'package:SweetLife/model/shopping_list_element.dart';

class ShoppingList {
  int id;
  String name;
  List<ShoppingListElement> elements;
  DateTime auditCD;
  int auditCU;

  ShoppingList(this.id, this.name, this.elements, this.auditCD, this.auditCU);
}
