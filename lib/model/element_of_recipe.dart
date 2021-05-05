import 'dart:convert';

class ElementOfRecipe {
  final double amount;
  final String ingredientName;
  final String unitName;

  ElementOfRecipe(this.ingredientName, this.amount, this.unitName);

  String toJson() {
    return json.encode({
      "amount": this.amount,
      "ingredientName": this.ingredientName,
      "unitName": this.unitName
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": this.amount,
      "ingredientName": this.ingredientName,
      "unitName": this.unitName
    };
  }
}
