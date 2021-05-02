import 'package:SweetLife/model/confectionery_type.dart';
import 'package:flutter/material.dart';

import '../../app_drawer.dart';

class RecipeCreation extends StatefulWidget {
  @override
  _RecipeCreationState createState() => _RecipeCreationState();
}

class _RecipeCreationState extends State<RecipeCreation> {
  final _preparationTimeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  bool _isInited = false;

  List<ConfectioneryType> availableConfectioneryTypes = [
    ConfectioneryType(1, "Torty"),
    ConfectioneryType(2, "Lody"),
    ConfectioneryType(3, "Rurki"),
  ];
  Map<int, bool> checkedConfectioneryTypes = <int, bool>{};

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      _prepareCheckedConfectioneryTypes();
      _isInited = true;
    }
    super.didChangeDependencies();
  }

  //nazwa, czas przygotowania, opis, image picker, skladniki, typ przepisu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe Creation"),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: null),
            //TODO implement saving
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                //name
                TextFormField(
                    initialValue: "",
                    decoration: InputDecoration(labelText: "Name"),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_preparationTimeFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter recipe name';
                      }
                      return null;
                    }),

                // preparation time
                TextFormField(
                  initialValue: "",
                  decoration: InputDecoration(labelText: 'Preparation time'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _preparationTimeFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a preparation time in minutes.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                    return null;
                  },
                  onSaved: null,
                ),

                //description
                TextFormField(
                  initialValue: "",
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                  onSaved: null,
                ),

                // image picker

                //  ingredients

                //  confectionery types
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Card(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Confectionery types:",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ...availableConfectioneryTypes.map(
                          (confectioneryType) {
                            return CheckboxListTile(
                              value:
                                  checkedConfectioneryTypes[confectioneryType.id],
                              title: Text(confectioneryType.name),
                              onChanged: (bool value) {
                                setState(() {
                                  checkedConfectioneryTypes[
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
                )
              ],
            ),
          ),
        ));
  }

  void _prepareCheckedConfectioneryTypes() {
    checkedConfectioneryTypes = <int, bool>{};
    for (ConfectioneryType type in availableConfectioneryTypes) {
      checkedConfectioneryTypes.putIfAbsent(type.id, () => false);
      // checkedConfectioneryTypes[type.id] = false;
    }
  }
}
