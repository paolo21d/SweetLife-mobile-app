import 'package:SweetLife/model/unit.dart';

import 'ingredient.dart';

class ElementOfRecipe {
  final int id;
  final double amount;
  final Ingredient ingredient;
  final Unit unit;

  final String ingredientId;
  final String unitId;

  ElementOfRecipe(this.id, this.amount, this.ingredient, this.unit,
      this.ingredientId, this.unitId);
}
