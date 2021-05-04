import 'package:SweetLife/app_drawer.dart';
import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe_description.dart';
import 'package:SweetLife/recipes/widgets/recipe_list_item.dart';
import 'package:flutter/material.dart';

class RecipeSearch extends StatefulWidget {
  static const routeName = '/recipe-search';

  final List<RecipeDescription> recipeDescriptions;

  const RecipeSearch(this.recipeDescriptions);

  @override
  _RecipeSearchState createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  TextEditingController _searchText = TextEditingController();
  TextEditingController _searchPreparationTime = TextEditingController();
  Map<String, bool> choosedIngredient = <String, bool>{};
  Map<int, bool> choosedConfectioneryType = <int, bool>{};

  bool _isInited = false;

  //    MOCKS!!!!
  List<ConfectioneryType> availableConfectioneryTypes = [
    ConfectioneryType(1, "Torty"),
    ConfectioneryType(2, "Lody"),
    ConfectioneryType(3, "Rurki"),
  ];
  List<Ingredient> availableIngredients = [
    Ingredient("1", "ing1"),
    Ingredient("2", "ing2"),
    Ingredient("3", "ing3"),
    Ingredient("4", "ing4"),
  ];

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      _isInited = true;
      _prepareChosedConfectioneryTypes();
      _prepareChosedIngredients();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Recipe"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: widget.recipeDescriptions.length,
        itemBuilder: (context, index) {
          return RecipeListItem(widget.recipeDescriptions[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openRecipeFiltering,
        child: Icon(Icons.filter_alt_rounded),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  void _prepareChosedConfectioneryTypes() {
    choosedConfectioneryType = <int, bool>{};
    for (ConfectioneryType type in availableConfectioneryTypes) {
      choosedConfectioneryType.putIfAbsent(type.id, () => false);
    }
  }

  void _prepareChosedIngredients() {
    choosedIngredient = <String, bool>{};
    for (Ingredient ingredient in availableIngredients) {
      choosedIngredient.putIfAbsent(ingredient.id, () => false);
    }
  }

  _openRecipeFiltering() async {
    final result = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Recipe Filtering"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.search),
                          title: Text("Search text"),
                        ),
                        TextField(
                          controller: _searchText,
                          // decoration: InputDecoration(hintText: ""),
                        ),
                      ],
                    ),
                  ),

                  //preparation time
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.access_time_rounded),
                          title: Text("Preparation time"),
                          contentPadding: EdgeInsets.zero,
                        ),
                        TextField(
                          controller: _searchPreparationTime,
                          // decoration: InputDecoration(hintText: ""),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),

                  //ingredients
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.shopping_basket_rounded),
                          title: Text("Ingredients"),
                        ),
                        ...availableIngredients.map(
                          (confectioneryType) {
                            return CheckboxListTile(
                              value: choosedIngredient[confectioneryType.id],
                              title: Text(confectioneryType.name),
                              onChanged: (bool value) {
                                setState(() {
                                  choosedIngredient[confectioneryType.id] =
                                      value;
                                });
                              },
                              // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //confectioneryTypes

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.fastfood_rounded),
                          title: Text("Confectionery Types"),
                        ),
                        ...availableConfectioneryTypes.map(
                          (confectioneryType) {
                            return CheckboxListTile(
                              value: choosedConfectioneryType[
                                  confectioneryType.id],
                              title: Text(confectioneryType.name),
                              onChanged: (bool value) {
                                setState(() {
                                  choosedConfectioneryType[
                                      confectioneryType.id] = value;
                                });
                              },
                              // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text("Filter")),
          FlatButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Cancel")),
        ],
      ),
    );

    if(result) {
      String searchText = _searchText.value.text;
      double maxPreparationTime = double.parse(_searchPreparationTime.value.text);


    }
  }
}
