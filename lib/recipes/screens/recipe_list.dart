import 'package:SweetLife/model/recipe_description.dart';
import 'package:SweetLife/recipes/widgets/recipe_list_item.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final List<RecipeDescription> recipeDescriptions;

  RecipeList(this.recipeDescriptions);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => RecipeListItem(recipeDescriptions[i]),
    );
  }
}
