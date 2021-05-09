import 'dart:developer';

import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/model/shopping_list_element.dart';
import 'package:SweetLife/providers/shopping_lists_provider.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_modification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListDetails extends StatefulWidget {
  static const routeName = '/shopping-list-details';

  ShoppingListDetails({Key key}) : super(key: key);

  @override
  _ShoppingListDetailsState createState() => _ShoppingListDetailsState();
}

class _ShoppingListDetailsState extends State<ShoppingListDetails> {
  bool _isInited = false;
  var _isLoading = false;

  //fetched data
  ShoppingList shoppingList;

  @override
  void didChangeDependencies() {
    log("ShoppingListDetails didChangeDependencies");

    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      _isInited = true;

      String shoppingListId =
          ModalRoute.of(context).settings.arguments as String;
      Provider.of<ShoppingListsProvider>(context)
          .fetchShoppingListById(shoppingListId)
          .then((_) {
        setState(() {
          _isLoading = false;
          shoppingList =
              Provider.of<ShoppingListsProvider>(context, listen: false)
                  .fetchedShoppingListById;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List Details"),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // TODO redirect to shopping list modification
                Navigator.of(context)
                    .pushNamed(ShoppingListModification.routeName,
                        arguments: shoppingList.id)
                    .then((_) {
                  setState(() {
                    _isInited = false;
                    _isLoading = false;
                    log("Then in ShoppingListDetails after navigation to ShoppingListModfification");
                  });
                });
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // TODO Delete this shopping list and redirect back to ShoppingListOverview
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Shopping List Delete'),
                    content: Text(
                        'Are you sure you want to delete the shopping list?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      )
                    ],
                  ),
                ).then((value) {
                  if (value) {
                    _deleteShoppingList().then((deleted) {
                      if (deleted) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                });
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                              _updateShoppingList();
                              //  TODO send request to change active state of ingredient
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          title: element.active
                              ? Text(element.ingredient)
                              : Text(
                                  element.ingredient,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey),
                                ),
                          subtitle: Text("${element.amount} ${element.unit}"),
                          secondary: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _ingredientDeleteProcedure(element);
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
            ),
    );
  }

  Future<bool> _deleteShoppingList() async {
    try {
      await Provider.of<ShoppingListsProvider>(context, listen: false)
          .deleteShoppingList(shoppingList.id);
      return true;
    } catch (error) {
      log(error.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleting failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> _updateShoppingList() async {
    log("Updating shopping list...");
    try {
      await Provider.of<ShoppingListsProvider>(context, listen: false)
          .updateShoppingList(shoppingList);
      return true;
    } catch (error) {
      log(error.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleting failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return false;
    }
  }

  Future<void> _ingredientDeleteProcedure(ShoppingListElement deletingElement) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ingredient Delete'),
        content: Text(
            'Are you sure you want to delete ingredient ${deletingElement.ingredient}?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          )
        ],
      ),
    ).then((value) {
      if (value) {
        setState(() {
          shoppingList.elements.removeWhere((element) =>
              element.ingredient == deletingElement.ingredient &&
              element.unit == deletingElement.unit &&
              element.amount == deletingElement.amount);
          _updateShoppingList();
        });
      }
    });
  }
}
