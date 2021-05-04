import 'package:SweetLife/recipes/screens/recipe_creation.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_overview.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Sweet Life"),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                  onPressed: () {
                    //  TODO implement log out
                  },
                  child: Text("Log out")),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description_rounded),
            title: Text('Recipe search'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RecipeSearch.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Create recipe'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RecipeCreation.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket_rounded),
            title: Text('Shopping list'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ShoppingListOverview.routeName);
            },
          ),
        ],
      ),
    );
  }
}
