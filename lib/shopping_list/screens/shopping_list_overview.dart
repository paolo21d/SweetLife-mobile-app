import 'package:SweetLife/app_drawer.dart';
import 'package:SweetLife/model/shopping_list_description.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShoppingListOverview extends StatefulWidget {
  static const routeName = '/shopping-list-overview';

  @override
  _ShoppingListOverviewState createState() => _ShoppingListOverviewState();
}

class _ShoppingListOverviewState extends State<ShoppingListOverview> {
  List<ShoppingListDescription> shoppingLists = [
    ShoppingListDescription(1, "lista1", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(2, "lista2", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(3, "lista3", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(4, "lista4", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(4, "lista4", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(4, "lista4", DateTime(2021), 5, 3, 1),
    ShoppingListDescription(4, "lista4", DateTime(2021), 5, 3, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Lists"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
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
                        "All elements: ${shoppingLists[index].elementsQuantity}"),
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
                  Navigator.of(context).pushNamed(
                    ShoppingListDetails.routeName,
                    arguments: shoppingLists[index].id,
                  );
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
          //TODO redirect to ShoppingListCreation screen
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
