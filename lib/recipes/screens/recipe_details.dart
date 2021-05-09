import 'dart:convert';
import 'dart:developer';

import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_modification.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecipeDetails extends StatelessWidget {
  static const routeName = '/recipe-details';

  @override
  Widget build(BuildContext context) {
    final String recipeId = ModalRoute.of(context).settings.arguments as String;
    log("Recipe ID: $recipeId");

    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Details"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // TODO redirect to recipe modification
                // TODO solve this as solved in ShoppingListDetails -> convert to statefull and refresh
                Navigator.of(context).pushNamed(RecipeModification.routeName,
                    arguments: recipeId);
              }),
        ],
      ),
      // drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<RecipesProvider>(context, listen: false)
            .fetchRecipeById(recipeId),
        builder: (ctx, result) => result.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<RecipesProvider>(
                builder: (ctx, recipeData, child) => SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      /* images */
                      //https://pub.dev/packages/carousel_slider/example
                      Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            pageViewKey:
                                PageStorageKey<String>('carousel_slider'),
                          ),
                          items:
                              imageSliders(recipeData.fetchedRecipeById.photos),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /* recipe name */
                      Text(
                        recipeData.fetchedRecipeById.name,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /* Rates and Comments */
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(recipeData
                                    .fetchedRecipeById.comments.length
                                    .toString()),
                                Text(" "),
                                Icon(Icons.comment_rounded),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                    recipeData.fetchedRecipeById.rates.length !=
                                            0
                                        ? (recipeData.fetchedRecipeById.rates
                                                    .map((e) => e.rate)
                                                    .reduce((a, b) => a + b) /
                                                recipeData.fetchedRecipeById
                                                    .rates.length)
                                            .toString()
                                        : "No rates"),
                                Text(" "),
                                Icon(Icons.favorite),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /* preparation time */
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.access_time_rounded),
                          title: Text("Preparation time"),
                          subtitle: Text(
                              "${recipeData.fetchedRecipeById.preparationTime.toString()} min"),
                        ),
                      ),

                      /* ingredients */
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.shopping_basket_rounded),
                          title: Text("Ingredients"),
                          subtitle: Column(
                            children: [
                              ...recipeData.fetchedRecipeById.recipeElements
                                  .map((element) {
                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                          "${element.amount} ${element.unitName} "),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text("${element.ingredientName}"),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ),

                      /* confectionery types */
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.fastfood_rounded),
                          title: Text("Confectionery Types"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...recipeData.fetchedRecipeById.confectioneryTypes
                                  .map((confectioneryTypes) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(confectioneryTypes.name),
                                );
                              })
                            ],
                          ),
                        ),
                      ),

                      /* Preparation description */
                      Card(
                        child: ListTile(
                            leading: Icon(Icons.architecture),
                            title: Text(
                              "Directions",
                            ),
                            subtitle: Text(
                                recipeData.fetchedRecipeById.description,
                                softWrap: true)),
                      ),

                      /* Comments */
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.comment),
                          title: Text("Comments"),
                          subtitle: Column(
                            children: [
                              ...recipeData.fetchedRecipeById.comments
                                  .map((comment) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(comment.userLogin),
                                      subtitle: Text(comment.content),
                                      trailing: Text(
                                        DateFormat.yMMMd()
                                            .format(comment.auditCD),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> imageSliders(List<String> photos) {
    return photos
        .map((photo) => Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child:
                    // Image.network(photo, fit: BoxFit.cover, width: 1000.0),
                    Image.memory(base64Decode(photo),
                        fit: BoxFit.cover, width: 1000.0),
              ),
            ))
        .toList();
  }
}
