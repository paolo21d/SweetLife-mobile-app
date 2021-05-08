import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/providers/shopping_lists_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListDetails extends StatefulWidget {
  static const routeName = '/shopping-list-details';

  ShoppingListDetails({Key key}) : super(key: key);

  @override
  _ShoppingListDetailsState createState() => _ShoppingListDetailsState();
}

class _ShoppingListDetailsState extends State<ShoppingListDetails> {
  /*ShoppingList shoppingList = ShoppingList(
      "1",
      "my first shopping list",
      [
        ShoppingListElement(1, "ing1", "unit1", true),
        ShoppingListElement(1, "ing1", "unit1", true),
        ShoppingListElement(1, "ing1", "unit1", true),
        ShoppingListElement(1, "ing1", "unit1", true),
        ShoppingListElement(1, "ing1", "unit1", true),
      ],
      DateTime(2021),
      "login11");*/
  bool _isInited = false;
  var _isLoading = false;

  //fetched data
  ShoppingList shoppingList;

  @override
  void didChangeDependencies() {
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
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // TODO Delete this shopping list and redirect back to ShoppingListOverview
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
            ),
    );
  }
}
