import 'dart:developer';

import 'package:SweetLife/app_drawer.dart';
import 'package:SweetLife/model/shopping_list.dart';
import 'package:SweetLife/providers/shopping_lists_provider.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_creation.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShoppingListOverview extends StatefulWidget {
  static const routeName = '/shopping-list-overview';

  @override
  _ShoppingListOverviewState createState() => _ShoppingListOverviewState();
}

class _ShoppingListOverviewState extends State<ShoppingListOverview> {
  bool _isInited = false;
  var _isLoading = false;

  // fetched data
  List<ShoppingList> shoppingLists = [];

  @override
  void didChangeDependencies() {
    log("ShoppingListOverview didChangeDepencencies");
    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      _isInited = true;

      Provider.of<ShoppingListsProvider>(context)
          .fetchDataToShoppingListOverview()
          .then((_) {
        setState(() {
          _isLoading = false;
          shoppingLists =
              Provider.of<ShoppingListsProvider>(context, listen: false)
                  .fetchedShoppingLists;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Lists"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: shoppingLists.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      shoppingLists[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "All elements: ${shoppingLists[index].elements.length}"),
                          Text(
                              "To buy elements: ${shoppingLists[index].activeElementsQuantity}"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Created: ${DateFormat.yMMMd().format(shoppingLists[index].auditCD)}")
                        ],
                      ),
                    ),
                    trailing: TextButton(
                      child: Text("Details"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(
                          ShoppingListDetails.routeName,
                          arguments: shoppingLists[index].id,
                        )
                            .then((_) {
                          setState(() {
                            //TODO wołane jest po załadowaniu strony do której nawigujemy, a nie po powrocie do obecnej strony
                            _isInited = false;
                          });
                        });
                      },
                    ),
                  ),
                  elevation: 10,
                );

                /*return Card(
            child: Row(
              children: [
                Text(
                  shoppingLists[index].name,
                  style: TextStyle(fontSize: 20),
                ),
                Column(
                  children: [
                    Text("All elements: ${shoppingLists[index].elementsQuantity}"),
                    Text(
                        "To buy elements: ${shoppingLists[index].activeElementsQuantity}"),
                  ],
                ),
                TextButton(
                  child: Text("Details"),
                  onPressed: () {},
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            elevation: 10,
          );*/
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ShoppingListCreation.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
