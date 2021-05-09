import 'dart:convert';

import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/recipes/screens/recipe_details.dart';
import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  RecipeListItem(this.recipe);

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
              child:
                  /*Image.network(
                recipe.photos.length != 0 ? recipe.photos[0] : "https://inzynieriaprocesow.pl/wp-content/themes/consultix/images/no-image-found-360x250.png",
                fit: BoxFit.cover,
              ),*/
                  recipe.photos.length != 0
                      ? Image.memory(base64Decode(recipe.photos[0]),
                          fit: BoxFit.cover)
                      : Image.network(
                          "https://inzynieriaprocesow.pl/wp-content/themes/consultix/images/no-image-found-360x250.png",
                          fit: BoxFit.cover,
                        ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                RecipeDetails.routeName,
                arguments: recipe.id,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(recipe.name),
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
                    Text(recipe.rates.length != 0
                        ? (recipe.rates
                                    .map((e) => e.rate)
                                    .reduce((a, b) => a + b) /
                                recipe.rates.length)
                            .toString()
                        : "No rates"),
                    Icon(Icons.favorite),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(recipe.comments.length.toString()),
                    Icon(Icons.comment_rounded),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(recipe.preparationTime.toString()),
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
