import 'dart:developer';

import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/element_of_recipe.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/recipe_comment.dart';
import 'package:SweetLife/model/recipe_rate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecipeDetails extends StatelessWidget {
  static const routeName = '/recipe-details';

  Recipe recipe = Recipe(
      "1",
      "Simple White Cake",
      "Preheat oven to 350 degrees F (175 degrees C). Grease and flour a 9x9 inch pan or line a muffin pan with paper liners. \n In a medium bowl, cream together the sugar and butter. Beat in the eggs, one at a time, then stir in the vanilla. Combine flour and baking powder, add to the creamed mixture and mix well. Finally stir in the milk until batter is smooth. Pour or spoon batter into the prepared pan. \n Bake for 30 to 40 minutes in the preheated oven. For cupcakes, bake 20 to 25 minutes. Cake is done when it springs back to the touch.",
      25,
      DateTime(2021),
      "login1", [
    "https://assets.tmecosys.com/image/upload/t_web667x528/img/recipe/ras/Assets/5e057cbe-e64e-484b-b8e2-19c9c74ddcd2/Derivates/0702d718-d752-447c-a1b2-c8b35fc71643.jpg",
    "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F7662123.jpg&q=85",
    "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8368810.jpg&q=85"
  ], [
    ElementOfRecipe("butter", 0.5, "cups"),
    ElementOfRecipe("eggs", 2, "pieces"),
    ElementOfRecipe("flour", 1.5, "cups"),
    ElementOfRecipe("milk", 1.5, "cups"),
  ], [
    ConfectioneryType("1", "confType1"),
    ConfectioneryType("2", "confType2"),
  ], [
    RecipeComment("comment 1", DateTime(2021), "login1"),
    RecipeComment("comment 2", DateTime(2021), "login2"),
    RecipeComment("comment 3 comment 3 comment 3 comment 3 comment 3",
        DateTime(2021), "login3"),
  ], [
    RecipeRate(2.5, DateTime(2021), "login1")
  ]);

  @override
  Widget build(BuildContext context) {
    log(recipe.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Details"),
      ),
      // drawer: AppDrawer(),
      body: SingleChildScrollView(
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
                  pageViewKey: PageStorageKey<String>('carousel_slider'),
                ),
                items: imageSliders(),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            /* recipe name */
            Text(
              recipe.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      Text(recipe.comments.length.toString()),
                      Text(" "),
                      Icon(Icons.comment_rounded),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(recipe.rates.toString()),
                      // TODO convert rate list to average rate
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
                subtitle: Text("${recipe.preparationTime.toString()} min"),
              ),
            ),

            /* ingredients */
            Card(
              child: ListTile(
                leading: Icon(Icons.shopping_basket_rounded),
                title: Text("Ingredients"),
                subtitle: Column(
                  children: [
                    ...recipe.recipeElements.map((element) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child:
                                Text("${element.amount} ${element.unitName} "),
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
                    ...recipe.confectioneryTypes.map((confectioneryTypes) {
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
                  subtitle: Text(recipe.description, softWrap: true)),
            ),

            /* Comments */
            Card(
              child: ListTile(
                leading: Icon(Icons.comment),
                title: Text("Comments"),
                subtitle: Column(
                  children: [
                    ...recipe.comments.map((comment) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(comment.userLogin),
                            subtitle: Text(comment.content),
                            trailing: Text(
                              DateFormat.yMMMd().format(comment.auditCD),
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
    );
  }

  List<Widget> imageSliders() {
    return recipe.photos
        .map((photo) => Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child:
                      Image.network(photo, fit: BoxFit.cover, width: 1000.0)),
            ))
        .toList();
  }
}
