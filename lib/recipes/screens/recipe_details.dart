import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/element_of_recipe.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/recipe_photo.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:flutter/material.dart';

import '../../app_drawer.dart';

class RecipeDetails extends StatelessWidget {
  Recipe recipe = Recipe(
      1,
      "Simple White Cake",
      "Preheat oven to 350 degrees F (175 degrees C). Grease and flour a 9x9 inch pan or line a muffin pan with paper liners. \n In a medium bowl, cream together the sugar and butter. Beat in the eggs, one at a time, then stir in the vanilla. Combine flour and baking powder, add to the creamed mixture and mix well. Finally stir in the milk until batter is smooth. Pour or spoon batter into the prepared pan. \n Bake for 30 to 40 minutes in the preheated oven. For cupcakes, bake 20 to 25 minutes. Cake is done when it springs back to the touch.",
      25,
      DateTime(2021),
      1,
      [
        RecipePhoto(1,
            "https://assets.tmecosys.com/image/upload/t_web667x528/img/recipe/ras/Assets/5e057cbe-e64e-484b-b8e2-19c9c74ddcd2/Derivates/0702d718-d752-447c-a1b2-c8b35fc71643.jpg")
      ],
      [
        ElementOfRecipe(
            1,
            0.5,
            Ingredient(1, "butter", [Unit(1, "cups"), Unit(2, "teaspoon")]),
            Unit(1, "cups"),
            1,
            1),
        ElementOfRecipe(2, 2, Ingredient(2, "eggs", [Unit(3, "pieces")]),
            Unit(3, "pieces"), 2, 3),
        ElementOfRecipe(3, 1.5, Ingredient(3, "flour", [Unit(1, "cups")]),
            Unit(1, "cups"), 3, 1),
        ElementOfRecipe(4, 0.5, Ingredient(4, "milk", [Unit(1, "cups")]),
            Unit(1, "cups"), 4, 1),
      ],
      [
        ConfectioneryType(1, "confType1"),
        ConfectioneryType(2, "confType2"),
      ],
      [],
      4.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe List"),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* images */
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                recipe.photos[0].image,
                fit: BoxFit.cover,
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
                      /*return Text(
                          "${element.amount} ${element.unit.name} ${element.ingredient.name}");*/
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
            Card()
          ],
        ),
      ),
    );
  }
}
