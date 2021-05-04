import 'dart:convert';

import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipesProvider extends ChangeNotifier {
  final String authToken;
  final String userId;
  final String apiURL =
      "sweetlife-api-default-rtdb.europe-west1.firebasedatabase.app";

  RecipesProvider(this.authToken, this.userId);

  Future<List<Ingredient>> get allIngredients async {
    var url = Uri.https(apiURL, "/ingredients.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<Ingredient> ingredients = [];
    extractedData.forEach((ingredientId, ingredientData) {
      ingredients.add(Ingredient(ingredientId, ingredientData['name']));
      // print(ingredients.last);
    });
    return ingredients;
  }

  Future<List<Unit>> get allUnits async{
    var url = Uri.https(apiURL, "/units.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<Unit> units = [];
    extractedData.forEach((unitId, unitData) {
      units.add(Unit(unitId, unitData['name']));
      print(units.last);
    });
    return units;

  }
}
