import 'package:SweetLife/app_drawer.dart';
import 'package:SweetLife/model/recipe_description.dart';
import 'package:SweetLife/recipes/widgets/recipe_list_item.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final List<RecipeDescription> recipeDescriptions;

  RecipeList(this.recipeDescriptions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe List"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: recipeDescriptions.length,
        itemBuilder: (context, index) {
          return RecipeListItem(null);
        },
      ),
    );
  }
}
