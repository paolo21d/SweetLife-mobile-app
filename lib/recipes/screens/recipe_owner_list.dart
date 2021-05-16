import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:SweetLife/recipes/widgets/recipe_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_drawer.dart';

class RecipeOwnerList extends StatefulWidget {
  static const routeName = '/recipe-owner-list';

  @override
  _RecipeOwnerListState createState() => _RecipeOwnerListState();
}

class _RecipeOwnerListState extends State<RecipeOwnerList> {
  bool _isInited = false;
  var _isLoading = false;

  List<Recipe> recipesToDisplay = [];

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      _isInited = true;

      Provider.of<RecipesProvider>(context)
          .fetchRecipesForLoggedUser()
          .then((_) {
        setState(() {
          _isLoading = false;
          recipesToDisplay =
              Provider.of<RecipesProvider>(context, listen: false)
                  .fetchedRecipes;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Recipes"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: recipesToDisplay.length,
              itemBuilder: (context, index) {
                return RecipeListItem(recipesToDisplay[index]);
              },
            ),
    );
  }
}
