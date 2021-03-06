import 'package:SweetLife/providers/auth_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_creation.dart';
import 'package:SweetLife/recipes/screens/recipe_owner_list.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_overview.dart';
import 'package:SweetLife/user/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              Provider.of<AuthProvider>(context, listen: false).isAuth
                  ? /*IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout()
                            .then((_) {
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                        });
                      },
                    )*/
                  FlatButton.icon(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout()
                            .then((_) {
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                        });
                      },
                      icon: Icon(Icons.logout),
                      label: Text(
                          Provider.of<AuthProvider>(context, listen: false)
                              .loggedUser
                              .email),
                      textColor: Colors.white,
                    )
                  : IconButton(
                      icon: Icon(Icons.login_rounded),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName);
                      },
                    ),
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
          Provider.of<AuthProvider>(context, listen: false).isAuth
              ? _loggedUserRedirections(context)
              : Container()
        ],
      ),
    );
  }

  Widget _loggedUserRedirections(BuildContext context) {
    return Column(children: [
      Divider(),
      ListTile(
        leading: Icon(Icons.list_alt_rounded),
        title: Text("My recipes"),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(RecipeOwnerList.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.add),
        title: Text('Create recipe'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(RecipeCreation.routeName);
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
    ]);
  }
}
