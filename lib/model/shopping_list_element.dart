import 'dart:convert';

class ShoppingListElement {
  double amount;
  String ingredient;
  String unit;
  bool active;

  ShoppingListElement(this.amount, this.ingredient, this.unit, this.active);

  String toJson() {
    return json.encode({
      "amount": this.amount,
      "ingredient": this.ingredient,
      "unit": this.unit,
      "active": this.active
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": this.amount,
      "ingredient": this.ingredient,
      "unit": this.unit,
      "active": this.active
    };
  }
}
