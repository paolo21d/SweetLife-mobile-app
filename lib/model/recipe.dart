import 'dart:convert';

import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/recipe_comment.dart';
import 'package:SweetLife/model/recipe_rate.dart';

import 'element_of_recipe.dart';

class Recipe {
  String id;
  String name;
  String description;
  int preparationTime;
  DateTime auditCD;
  String auditCU;
  List<String> photos;
  List<ElementOfRecipe> recipeElements;
  List<ConfectioneryType> confectioneryTypes;
  List<RecipeComment> comments;
  List<RecipeRate> rates;

  Recipe(
      this.id,
      this.name,
      this.description,
      this.preparationTime,
      this.auditCD,
      this.auditCU,
      this.photos,
      this.recipeElements,
      this.confectioneryTypes,
      this.comments,
      this.rates);

  Recipe.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    this.name = json['name'];
    this.description = json['description'];
    this.preparationTime = json['preparationTime'];
    this.auditCD = DateTime.parse(json['auditCD']);
    this.auditCU = json['auditCU'];
    this.photos = (json['photos'] as List).map((photo) => photo as String).toList();
    this.recipeElements = (json['recipeElements'] as List)
        .map((element) => ElementOfRecipe(
            element["ingredientName"], element["amount"] as double, element["unitName"]))
        .toList();
    this.confectioneryTypes = (json['confectioneryTypes'] as List)
        .map((type) => ConfectioneryType(type['id'], type["name"]))
        .toList();
    this.comments = (json['comments'] as List)
        .map((comment) => RecipeComment(
            comment['content'], DateTime.parse(comment['auditCD']), comment['userLogin']))
        .toList();
    this.rates = (json['rates'] as List)
        .map((rate) =>
            RecipeRate(rate['rate'], DateTime.parse(rate['auditCD']), rate['userLogin']))
        .toList();
  }

  String toJson() {
    return json.encode({
      "name": this.name,
      "description": this.description,
      "preparationTime": this.preparationTime,
      "auditCD": this.auditCD.toIso8601String(),
      "auditCU": this.auditCU,
      "photos": this.photos,
      "recipeElements":
          this.recipeElements.map((element) => element.toMap()).toList(),
      "confectioneryTypes":
          this.confectioneryTypes.map((type) => type.toMap()).toList(),
      "comments": this.comments.map((comment) => comment.toMap()).toList(),
      "rates": this.rates.map((rate) => rate.toMap()).toList()
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "description": this.description,
      "preparationTime": this.preparationTime,
      "auditCD": this.auditCD.toIso8601String(),
      "auditCU": this.auditCU,
      "photos": this.photos,
      "recipeElements":
          this.recipeElements.map((element) => element.toMap()).toList(),
      "confectioneryTypes":
          this.confectioneryTypes.map((type) => type.toMap()).toList(),
      "comments": this.comments.map((comment) => comment.toMap()).toList(),
      "rates": this.rates.map((rate) => rate.toMap()).toList()
    };
  }
}
