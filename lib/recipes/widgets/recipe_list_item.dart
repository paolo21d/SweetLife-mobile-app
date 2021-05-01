import 'package:SweetLife/model/recipe_description.dart';
import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeDescription recipeDescription;

  RecipeListItem(this.recipeDescription);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: null, //TODO redirect to RecipeDetails
          child: Image.network(recipeDescription.photo, fit: BoxFit.cover),
        ),
        footer: GridTileBar,
      ),

    );
  }
}
