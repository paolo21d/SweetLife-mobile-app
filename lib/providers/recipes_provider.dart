import 'dart:convert';

import 'package:SweetLife/exceptions/http_exception.dart';
import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/recipe_comment.dart';
import 'package:SweetLife/model/recipe_rate.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:SweetLife/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipesProvider with ChangeNotifier {
  String _authToken;
  User _loggedUser;
  final String apiURL =
      "sweetlife-api-default-rtdb.europe-west1.firebasedatabase.app";

  List<Recipe> _fetchedRecipes;
  List<Ingredient> _allFetchedIngredients;
  List<Unit> _allFetchedUnits;
  List<ConfectioneryType> _allFetchedConfectioneryTypes;
  Recipe _fetchedRecipeById;
  String _createdRecipeId;

  // RecipesProvider(this._authToken, this._userId);
  set authToken(String value) {
    _authToken = value;
  }

  set user(User value) {
    _loggedUser = value;
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

  Recipe get fetchedRecipeById {
    return _fetchedRecipeById;
  }

  List<ConfectioneryType> get allConfectioneryTypes {
    return [..._allFetchedConfectioneryTypes];
  }

  String get createdRecipeId {
    return _createdRecipeId;
  }

  Future<void> createRecipe(Recipe recipe) async {
    recipe.auditCU = _loggedUser.id;

    var url = Uri.https(apiURL, "/recipes.json", {"auth": _authToken});
    final response = await http.post(url, body: recipe.toJson());

    _createdRecipeId =
        (json.decode(response.body) as Map<String, dynamic>)["name"];
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    if (recipe.auditCU != _loggedUser.id) {
      throw HttpException("Unauthorized! User is not owner of this object!");
    }

    var url =
        Uri.https(apiURL, "/recipes/${recipe.id}.json", {"auth": _authToken});
    await http.put(url, body: recipe.toJson());

    notifyListeners();
  }

  Future<void> addCommentToRecipe(String recipeId, String commentValue) async {
    Recipe recipe = await _fetchRecipeById(recipeId);
    RecipeComment comment =
        RecipeComment(commentValue, DateTime.now(), _loggedUser.email);
    recipe.comments.add(comment);

    var url =
        Uri.https(apiURL, "/recipes/${recipe.id}.json", {"auth": _authToken});
    await http.patch(url,
        body: json.encode({
          "comments": recipe.comments.map((comment) => comment.toMap()).toList()
        }));
  }

  Future<void> addRateToRecipe(String recipeId, double rateValue) async {
    Recipe recipe = await _fetchRecipeById(recipeId);
    RecipeRate rate = RecipeRate(rateValue, DateTime.now(), _loggedUser.email);

    if (recipe.rates.isNotEmpty) {
      recipe.rates
          .removeWhere((element) => element.userLogin == _loggedUser.email);
      recipe.rates.add(rate);
    } else {
      recipe.rates = [rate];
    }

    var url =
        Uri.https(apiURL, "/recipes/${recipe.id}.json", {"auth": _authToken});
    await http.patch(url,
        body: json.encode(
            {"rates": recipe.rates.map((rate) => rate.toMap()).toList()}));
  }

  Future<void> fetchDataToRecipeCreation() async {
    await Future.wait([
      _fetchAllIngredients(),
      _fetchAllUnits(),
      _fetchAllConfectioneryTypes()
    ]);

    notifyListeners();
  }

  Future<void> fetchDataToRecipeModification(String modifyingRecipeId) async {
    await Future.wait([
      _fetchAllIngredients(),
      _fetchAllUnits(),
      _fetchAllConfectioneryTypes(),
      _fetchAllRecipes()
    ]);

    _fetchedRecipeById =
        _fetchedRecipes.firstWhere((recipe) => recipe.id == modifyingRecipeId);

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

  Future<void> fetchRecipeById(String recipeId) async {
    /*await _fetchAllRecipes();

    _fetchedRecipeById =
        _fetchedRecipes.firstWhere((recipe) => recipe.id == recipeId);*/
    Recipe recipe = await _fetchRecipeById(recipeId);
    _fetchedRecipeById = recipe;

    notifyListeners();
  }

  Future<void> fetchFilteredRecipes(String searchText, double preparationTime,
      List<String> ingredients, List<String> confectioneryTypes) async {
    await _fetchAllRecipes();

    List<Recipe> filteredRecipes = [];
    for (Recipe recipe in _fetchedRecipes) {
      if (searchText != null &&
          searchText.isNotEmpty &&
          !recipe.name.contains(searchText) &&
          !recipe.description.contains(searchText)) {
        continue;
      }
      if (preparationTime != null &&
          preparationTime > 0 &&
          recipe.preparationTime > preparationTime) {
        continue;
      }
      if (ingredients != null && ingredients.isNotEmpty) {
        bool intersection = recipe.recipeElements
            .map((element) => element.ingredientName)
            .toList()
            .any((element) => ingredients.contains(element));
        if (!intersection) continue;
      }
      if (confectioneryTypes != null && confectioneryTypes.isNotEmpty) {
        bool intersection = recipe.confectioneryTypes
            .map((type) => type.name)
            .toList()
            .any((typeName) => confectioneryTypes.contains(typeName));
        if (!intersection) continue;
      }
      filteredRecipes.add(recipe);
    }
    _fetchedRecipes = filteredRecipes;

    notifyListeners();
  }

  Future<void> fetchRecipesForLoggedUser() async {
    await _fetchRecipesForUser(_loggedUser.id);

    notifyListeners();
  }

  // PRIVATE
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

  Future<Recipe> _fetchRecipeById(String recipeId) async {
    var url = Uri.https(apiURL, "/recipes/$recipeId.json");
    final response = await http.get(url);

    if (response == null) {
      throw HttpException("Not found recipe with id $recipeId");
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    return Recipe.fromJson(recipeId, extractedData);
  }

  Future<void> _fetchRecipesForUser(String userId) async {
    await _fetchAllRecipes();
    if (_fetchedRecipes != null || _fetchedRecipes.isNotEmpty) {
      _fetchedRecipes =
          _fetchedRecipes.where((recipe) => recipe.auditCU == userId).toList();
    }
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
