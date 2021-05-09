import 'dart:convert';

import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShoppingListsProvider with ChangeNotifier {
  String _authToken;
  String _userId;
  final String apiURL =
      "sweetlife-api-default-rtdb.europe-west1.firebasedatabase.app";

  set authToken(String value) {
    _authToken = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<ShoppingList> _fetchedShoppingLists;
  List<Ingredient> _allFetchedIngredients;
  List<Unit> _allFetchedUnits;
  ShoppingList _fetchedShoppingListById;
  String _createdShoppingListId;

  List<ShoppingList> get fetchedShoppingLists {
    return _fetchedShoppingLists;
  }

  List<Ingredient> get allIngredients {
    return _allFetchedIngredients;
  }

  List<Unit> get allUnits {
    return _allFetchedUnits;
  }

  ShoppingList get fetchedShoppingListById {
    return _fetchedShoppingListById;
  }

  String get createdShoppingListId {
    return _createdShoppingListId;
  }

  Future<void> fetchDataToShoppingListCreation() async {
    await Future.wait([_fetchAllIngredients(), _fetchAllUnits()]);

    notifyListeners();
  }

  Future<void> fetchDataToShoppingListModification(
      String shoppingListId) async {
    await Future.wait(
        [_fetchAllIngredients(), _fetchAllUnits(), _fetchAllShoppingLists()]);

    _fetchedShoppingListById = _fetchedShoppingLists
        .firstWhere((element) => element.id == shoppingListId);
    notifyListeners();
  }

  Future<void> fetchShoppingListById(String shoppingListId) async {
    await _fetchAllShoppingLists();

    _fetchedShoppingListById = _fetchedShoppingLists
        .firstWhere((element) => element.id == shoppingListId);

    notifyListeners();
  }

  Future<void> fetchDataToShoppingListOverview() async {
    await _fetchAllShoppingLists();

    notifyListeners();
  }

  Future<void> createShoppingList(ShoppingList shoppingList) async {
    var url = Uri.https(apiURL, "/shopping-lists.json");
    final response = await http.post(url, body: shoppingList.toJson());

    _createdShoppingListId =
        (json.decode(response.body) as Map<String, dynamic>)["name"];
    notifyListeners();
  }

  Future<void> deleteShoppingList(String shoppingListId) async {
    var url = Uri.https(apiURL, "/shopping-lists/$shoppingListId.json");
    await http.delete(url);

    notifyListeners();
  }

  Future<void> updateShoppingList(ShoppingList shoppingList) async {
    var url = Uri.https(apiURL, "/shopping-lists/${shoppingList.id}.json");
    await http.put(url, body: shoppingList.toJson());

    notifyListeners();
  }

  // private methods
  Future<void> _fetchAllShoppingLists() async {
    // TODO fetch shopping list only for logged user
    var url = Uri.https(apiURL, "/shopping-lists.json");
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    List<ShoppingList> shoppingLists = [];
    extractedData.forEach((shoppingListId, shoppingListJson) {
      shoppingLists
          .add(ShoppingList.fromJson(shoppingListId, shoppingListJson));
    });
    _fetchedShoppingLists = shoppingLists;
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
    });
    _allFetchedUnits = units;
  }
}
