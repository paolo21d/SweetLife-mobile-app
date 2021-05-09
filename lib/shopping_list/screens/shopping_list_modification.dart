import 'dart:developer';

import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/model/shopping_list_element.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:SweetLife/providers/shopping_lists_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListModification extends StatefulWidget {
  static const routeName = '/shopping-list-modification';

  ShoppingListModification({Key key}) : super(key: key);

  @override
  _ShoppingListModificationState createState() =>
      _ShoppingListModificationState();
}

class _ShoppingListModificationState extends State<ShoppingListModification> {
  TextEditingController _shoppingListNameController = TextEditingController();
  TextEditingController _ingredientCreationAmountController =
      TextEditingController();

  String choosedIngredientName;
  String choosedUnitName;
  bool _isInited = false;
  var _isLoading = false;

  bool isValidName = true;
  bool isValidIngredients = true;

  // crating ShoppingListData
  List<ShoppingListElement> ingredients;

  // fetched data
  List<Ingredient> availableIngredients = [];
  List<Unit> availableUnits = [];
  ShoppingList modifyingShoppingList;

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      // ingredients = <ShoppingListElement>[];
      _isInited = true;

      String modifyingShoppingListId =
          ModalRoute.of(context).settings.arguments as String;

      Provider.of<ShoppingListsProvider>(context)
          .fetchDataToShoppingListModification(modifyingShoppingListId)
          .then((_) {
        setState(() {
          _isLoading = false;
          availableIngredients =
              Provider.of<ShoppingListsProvider>(context, listen: false)
                  .allIngredients;
          availableUnits =
              Provider.of<ShoppingListsProvider>(context, listen: false)
                  .allUnits;
          modifyingShoppingList =
              Provider.of<ShoppingListsProvider>(context, listen: false)
                  .fetchedShoppingListById;
          _shoppingListNameController.text = modifyingShoppingList.name;
          ingredients = modifyingShoppingList.elements;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List Modification"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveShoppingList,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 18),
                        ),
                        TextField(
                          controller: _shoppingListNameController,
                          decoration: isValidName
                              ? InputDecoration(hintText: "Shopping List Name")
                              : InputDecoration(
                                  hintText: "Shopping List Name",
                                  errorText: "Invalid name"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  !isValidIngredients
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Invalid ingredients",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        )
                      : Center(),
                  ...ingredients.map((element) {
                    return Card(
                      child: ListTile(
                        title: Text(element.ingredient),
                        subtitle: Text("${element.amount} ${element.unit}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              ingredients.remove(element);
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: () => _addIngredient(context),
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
            ),
    );
  }

/*  Ingredient _getIngredientByName(String ingredientName) {
    return availableIngredients
        .firstWhere((element) => element.name == ingredientName);
  }

  Unit _getUnitByName(String unitName) {
    return availableUnits.firstWhere((element) => element.name == unitName);
  }*/

  _addIngredient(BuildContext context) async {
    setState(() {
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
      _ingredientCreationAmountController.clear();
    });

    final result = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add ingredient"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ingredient
                Text("Ingredient:"),
                DropdownButton(
                  value: choosedIngredientName,
                  items: availableIngredients.map((ingredient) {
                    return new DropdownMenuItem(
                      value: ingredient.name,
                      child: Text(ingredient.name),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      choosedIngredientName = newValue;
                    });
                  },
                  isExpanded: true,
                ),
                // unit
                SizedBox(
                  height: 10,
                ),
                Text("Unit:"),
                DropdownButton(
                  value: choosedUnitName,
                  items: availableUnits.map((unit) {
                    return DropdownMenuItem(
                      value: unit.name,
                      child: Text(unit.name),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      choosedUnitName = newValue;
                    });
                  },
                  isExpanded: true,
                ),
                //amount
                SizedBox(
                  height: 10,
                ),
                Text("Amount:"),
                TextField(
                  controller: _ingredientCreationAmountController,
                  decoration: InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
              ],
            );
          },
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text("Save")),
          FlatButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Cancel")),
        ],
      ),
    );

    setState(() {
      if (result) {
        // Ingredient ingredient = _getIngredientByName(choosedIngredientName);
        // Unit unit = _getUnitByName(choosedUnitName);
        double amount =
            double.parse(_ingredientCreationAmountController.value.text);
        ingredients.add(ShoppingListElement(
            amount, choosedIngredientName, choosedUnitName, true));
      }
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
      _ingredientCreationAmountController.clear();
    });
  }

  Future<void> _saveShoppingList() async {
    bool isValid = _validateForm();

    if (isValid) {
      String modifyingListName = _shoppingListNameController.value.text;

      modifyingShoppingList.name = modifyingListName;
      modifyingShoppingList.elements = ingredients;

      try {
        await Provider.of<ShoppingListsProvider>(context, listen: false)
            .updateShoppingList(modifyingShoppingList)
            .then((_) {
          /*Navigator.of(context).popAndPushNamed(
            ShoppingListDetails.routeName,
            arguments: modifyingShoppingList.id,
          );*/
          Navigator.of(context).pop();
        });
      } catch (error) {
        log(error.toString());
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
  }

  bool _validateForm() {
    setState(() {
      isValidName = _shoppingListNameController.value.text.isNotEmpty;
      isValidIngredients = ingredients.isNotEmpty;
    });
    return isValidName && isValidIngredients;
  }
}
