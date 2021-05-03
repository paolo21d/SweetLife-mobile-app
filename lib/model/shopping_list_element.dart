import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/unit.dart';

class ShoppingListElement {
  int id;
  double amount;
  Ingredient ingredient;
  Unit unit;
  bool active;

  ShoppingListElement(
      this.id, this.amount, this.ingredient, this.unit, this.active);
}