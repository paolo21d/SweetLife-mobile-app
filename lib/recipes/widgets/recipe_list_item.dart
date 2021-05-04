import 'package:SweetLife/model/recipe_description.dart';
import 'package:SweetLife/recipes/screens/recipe_details.dart';
import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeDescription recipeDescription;

  RecipeListItem(this.recipeDescription);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                recipeDescription.photo,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                RecipeDetails.routeName,
                arguments: recipeDescription.id,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(recipeDescription.name),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(recipeDescription.rate.toString()),
                    Icon(Icons.favorite),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(recipeDescription.commentsAmount.toString()),
                    Icon(Icons.comment_rounded),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(recipeDescription.preparationTime.toString()),
                    Icon(Icons.timelapse),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
