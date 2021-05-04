import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/element_of_recipe.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/recipe_comment.dart';
import 'package:SweetLife/model/recipe_photo.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_drawer.dart';

class RecipeDetails extends StatelessWidget {
  static const routeName = '/recipe-details';

  Recipe recipe = Recipe(
      1,
      "Simple White Cake",
      "Preheat oven to 350 degrees F (175 degrees C). Grease and flour a 9x9 inch pan or line a muffin pan with paper liners. \n In a medium bowl, cream together the sugar and butter. Beat in the eggs, one at a time, then stir in the vanilla. Combine flour and baking powder, add to the creamed mixture and mix well. Finally stir in the milk until batter is smooth. Pour or spoon batter into the prepared pan. \n Bake for 30 to 40 minutes in the preheated oven. For cupcakes, bake 20 to 25 minutes. Cake is done when it springs back to the touch.",
      25,
      DateTime(2021),
      1,
      [
        RecipePhoto(1,
            "https://assets.tmecosys.com/image/upload/t_web667x528/img/recipe/ras/Assets/5e057cbe-e64e-484b-b8e2-19c9c74ddcd2/Derivates/0702d718-d752-447c-a1b2-c8b35fc71643.jpg"),
        RecipePhoto(2,
            "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F7662123.jpg&q=85"),
        RecipePhoto(3,
            "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8368810.jpg&q=85")
      ],
      [
        ElementOfRecipe(1, 0.5, Ingredient(1, "butter"), Unit(1, "cups"), 1, 1),
        ElementOfRecipe(2, 2, Ingredient(2, "eggs"), Unit(3, "pieces"), 2, 3),
        ElementOfRecipe(3, 1.5, Ingredient(3, "flour"), Unit(1, "cups"), 3, 1),
        ElementOfRecipe(4, 0.5, Ingredient(4, "milk"), Unit(1, "cups"), 4, 1),
      ],
      [
        ConfectioneryType(1, "confType1"),
        ConfectioneryType(2, "confType2"),
      ],
      [
        RecipeComment(1, "comment 1", DateTime(2021), 1, "login1", 1),
        RecipeComment(2, "comment 2", DateTime(2021), 2, "login2", 1),
        RecipeComment(3, "comment 3 comment 3 comment 3 comment 3 comment 3",
            DateTime(2021), 3, "login3", 1),
      ],
      4.5);

  @override
  Widget build(BuildContext context) {
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
                      Text(recipe.rate.toString()),
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
                                Text("${element.amount} ${element.unit.name} "),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text("${element.ingredient.name}"),
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
                    ...recipe.confectioneryType.map((confectioneryTypes) {
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
                  child: Image.network(photo.image,
                      fit: BoxFit.cover, width: 1000.0)),
            ))
        .toList();
  }
}
