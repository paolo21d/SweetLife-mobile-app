import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/model/shopping_list_element.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:flutter/material.dart';

class ShoppingListDetails extends StatefulWidget {
  static const routeName = '/shopping-list-details';

  ShoppingListDetails({Key key}) : super(key: key);

  @override
  _ShoppingListDetailsState createState() => _ShoppingListDetailsState();
}

class _ShoppingListDetailsState extends State<ShoppingListDetails> {
  ShoppingList shoppingList = ShoppingList(
      1,
      "my first shopping list",
      [
        ShoppingListElement(
            1, 5, Ingredient(1, "ing1"), Unit(1, "unit1"), true),
        ShoppingListElement(
            2, 12, Ingredient(2, "ing2"), Unit(1, "unit1"), true),
        ShoppingListElement(
            3, 2000, Ingredient(3, "ing3"), Unit(2, "unit2"), false),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
        ShoppingListElement(
            4, 0.25, Ingredient(4, "ing4"), Unit(1, "unit1"), true),
      ],
      DateTime(2021),
      1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shopping Lists Details"),
          actions: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // TODO redirect to shopping list modification
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // TODO Delete this shopping list and redirect back to ShoppingListOverview
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    shoppingList.name,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ...shoppingList.elements.map((element) {
                  return Card(
                    child: CheckboxListTile(
                      value: element.active,
                      onChanged: (bool value) {
                        setState(() {
                          element.active = value;
                        //  TODO send request to change active state of ingredient
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: element.active? Text(element.ingredient.name) : Text(element.ingredient.name, style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),),
                      subtitle: Text("${element.amount} ${element.unit.name}"),
                      secondary: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //  TODO remove this element
                        },
                      ),
                    ),
                    elevation: 10,
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
