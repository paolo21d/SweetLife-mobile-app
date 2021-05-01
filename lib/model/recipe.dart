import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/recipe_comment.dart';
import 'package:SweetLife/model/recipe_photo.dart';

import 'element_of_recipe.dart';

class Recipe {
  int id;
  String name;
  String description;
  int preparationTime;
  DateTime auditCD;
  int auditCU;
  List<RecipePhoto> photos;
  List<ElementOfRecipe> recipeElements;
  List<ConfectioneryType> confectioneryType;
  List<RecipeComment> comments;
  double rate;

  Recipe(
      this.id,
      this.name,
      this.description,
      this.preparationTime,
      this.auditCD,
      this.auditCU,
      this.photos,
      this.recipeElements,
      this.confectioneryType,
      this.comments,
      this.rate);
}
