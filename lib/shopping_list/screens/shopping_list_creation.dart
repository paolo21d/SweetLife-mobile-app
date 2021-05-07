import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/shopping_list_element.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListCreation extends StatefulWidget {
  static const routeName = '/shopping-list-creation';

  ShoppingListCreation({Key key}) : super(key: key);

  @override
  _ShoppingListCreationState createState() => _ShoppingListCreationState();
}

class _ShoppingListCreationState extends State<ShoppingListCreation> {
  bool _isInited = false;
  TextEditingController _shoppingListNameController = TextEditingController();
  List<ShoppingListElement> ingredients;

  TextEditingController _ingredientCreationAmountController =
      TextEditingController();
  String choosedIngredientName;
  String choosedUnitName;

  //      MOCKS!!
  List<Ingredient> availableIngredients = [];
  List<Unit> availableUnits = [];

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      ingredients = <ShoppingListElement>[];
      _isInited = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List Creation"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                //TODO implement saving
              }),
        ],
      ),
      body: SingleChildScrollView(
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
                      decoration:
                          InputDecoration(hintText: "Shopping List Name")),
                ],
              ),
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addIngredient(context),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Ingredient _getIngredientByName(String ingredientName) {
    return availableIngredients
        .firstWhere((element) => element.name == ingredientName);
  }

  Unit _getUnitByName(String unitName) {
    return availableUnits.firstWhere((element) => element.name == unitName);
  }

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
        ingredients
            .add(ShoppingListElement(amount, choosedIngredientName, choosedUnitName, true));
      }
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
      _ingredientCreationAmountController.clear();
    });
  }
}
