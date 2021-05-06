import 'dart:convert';
import 'dart:developer';

import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipesProvider with ChangeNotifier {
  String _authToken;
  String _userId;
  final String apiURL =
      "sweetlife-api-default-rtdb.europe-west1.firebasedatabase.app";

  List<Recipe> _fetchedRecipes;
  List<Ingredient> _allFetchedIngredients;
  List<Unit> _allFetchedUnits;
  List<ConfectioneryType> _allFetchedConfectioneryTypes;

  // RecipesProvider(this._authToken, this._userId);
  set authToken(String value) {
    _authToken = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<Recipe> get fetchedRecipes {
    return [..._fetchedRecipes];
  }

  List<Ingredient> get allIngredients {
    return [..._allFetchedIngredients];
  }

  List<Unit> get allUnits {
    return [..._allFetchedUnits];
  }

  List<ConfectioneryType> get allConfectioneryTypes {
    return [..._allFetchedConfectioneryTypes];
  }

  Future<String> createRecipe(Recipe recipe) async {
    var url = Uri.https(apiURL, "/recipes.json");
    final response = await http.post(url, body: recipe.toJson());

    return (response.body as Map<String, dynamic>)["name"];
  }

  Future<void> fetchDataToRecipeCreation() async {
    await Future.wait([
      _fetchAllIngredients(),
      _fetchAllUnits(),
      _fetchAllConfectioneryTypes()
    ]);

    notifyListeners();
  }

  Future<void> fetchDataToRecipeSearch() async {
    await Future.wait([
      _fetchAllIngredients(),
      _fetchAllConfectioneryTypes(),
      _fetchAllRecipes()
    ]);

    notifyListeners();
  }

  Future<void> fetchFilteredRecipes(String searchText, double preparationTime, List<String> ingredients, List<String> confectioneryTypes) async {

  }

  Future<void> _fetchAllRecipes() async {
    var url = Uri.https(apiURL, "/recipes.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<Recipe> recipes = [];
    extractedData.forEach((recipeId, rescipeJson) {

      recipes.add(Recipe.fromJson(recipeId, rescipeJson));
    });
    _fetchedRecipes = recipes;

    // log(response.body);
  }

  Future<void> _fetchAllIngredients() async {
    var url = Uri.https(apiURL, "/ingredients.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<Ingredient> ingredients = [];
    extractedData.forEach((ingredientId, ingredientData) {
      ingredients.add(Ingredient(ingredientId, ingredientData['name']));
    });
    _allFetchedIngredients = ingredients;

    // extractedData.entries.map((entry) => Ingredient(entry.key, entry.value["name"])).toList();
  }

  Future<void> _fetchAllUnits() async {
    var url = Uri.https(apiURL, "/units.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<Unit> units = [];
    extractedData.forEach((unitId, unitData) {
      units.add(Unit(unitId, unitData['name']));
      // log(units.last.toString());
    });
    _allFetchedUnits = units;
  }

  Future<void> _fetchAllConfectioneryTypes() async {
    var url = Uri.https(apiURL, "/confectionery-types.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<ConfectioneryType> confectioneryTypes = [];
    extractedData.forEach((typeId, typeData) {
      confectioneryTypes.add(ConfectioneryType(typeId, typeData['name']));
      // log(confectioneryTypes.last.toString());
    });
    _allFetchedConfectioneryTypes = confectioneryTypes;
  }
}
