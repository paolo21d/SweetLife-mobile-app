import 'dart:io';

import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/element_of_recipe.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_drawer.dart';

class RecipeCreation extends StatefulWidget {
  static const routeName = '/recipe-creation';

  @override
  _RecipeCreationState createState() => _RecipeCreationState();
}

class _RecipeCreationState extends State<RecipeCreation> {
  final _preparationTimeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  bool _isInited = false;
  Map<int, bool> checkedConfectioneryTypes = <int, bool>{};
  List<File> addedPhotos = <File>[];
  List<ElementOfRecipe> addedIngredients = [];

  TextEditingController _ingredientCreationAmount = TextEditingController();

  String choosedIngredientName;
  String choosedUnitName;

  //      MOCKS!!
  List<ConfectioneryType> availableConfectioneryTypes = [
    ConfectioneryType(1, "Torty"),
    ConfectioneryType(2, "Lody"),
    ConfectioneryType(3, "Rurki"),
  ];
  List<Ingredient> availableIngredients = [
    Ingredient(1, "ing1"),
    Ingredient(2, "ing2"),
    Ingredient(3, "ing3"),
    Ingredient(4, "ing4"),
  ];
  List<Unit> availableUnits = [
    Unit(1, "Unit1"),
    Unit(2, "Unit2"),
    Unit(3, "Unit3"),
    Unit(4, "Unit4"),
  ];

  String dropdownValue = 'One';

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      addedPhotos = <File>[];
      addedIngredients = [];
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
                Card(
                  child: Column(
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
                        decoration:
                            InputDecoration(labelText: 'Preparation time'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _preparationTimeFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
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
                    ],
                  ),
                ),

                // image picker
                Card(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Photos:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              icon: Icon(Icons.photo_library),
                              onPressed: _imgFromGallery),
                          IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: _imgFromCamera)
                        ],
                      ),
                      /*...addedPhotos.map((photoFile) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              photoFile,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        );
                      })*/
                      addedPhotos.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No photo"),
                              ),
                            )
                          : Container(
                              child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                pageViewKey:
                                    PageStorageKey<String>('carousel_slider'),
                              ),
                              items: imageSliders(context),
                            ))
                    ],
                  ),
                ),

                //  ingredients
                Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              "Ingredients:",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _addIngredientFiled(context);
                              }),
                        ],
                      ),
                      ...addedIngredients.map((ingredient) {
                        return ListTile(
                          title: Text(ingredient.ingredient.name),
                          subtitle: Text(
                              "${ingredient.amount} ${ingredient.unit.name}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                addedIngredients.removeWhere(
                                    (element) => element == ingredient);
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

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
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        ...availableConfectioneryTypes.map(
                          (confectioneryType) {
                            return CheckboxListTile(
                              value: checkedConfectioneryTypes[
                                  confectioneryType.id],
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (image != null) {
        addedPhotos.add(image);
      }
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      if (image != null) {
        addedPhotos.add(image);
      }
    });
  }

  Ingredient _getIngredientByName(String ingredientName) {
    return availableIngredients
        .firstWhere((element) => element.name == ingredientName);
  }

  Unit _getUnitByName(String unitName) {
    return availableUnits.firstWhere((element) => element.name == unitName);
  }

  imageSliders(BuildContext context) {
    return addedPhotos.map((photoFile) {
      return Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Image.file(
                    photoFile,
                    fit: BoxFit.fitHeight,
                    width: 1000,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(100, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              addedPhotos.removeWhere(
                                  (element) => element == photoFile);
                            });
                          },
                        )
                        /*Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/
                        ),
                  ),
                ],
              )),
        ),
      );
    }).toList();
  }

  _addIngredientFiled(BuildContext context) async {
    setState(() {
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
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
                /*DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),*/
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
                  controller: _ingredientCreationAmount,
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
        Ingredient ingredient = _getIngredientByName(choosedIngredientName);
        Unit unit = _getUnitByName(choosedUnitName);
        double amount = double.parse(_ingredientCreationAmount.value.text);
        addedIngredients.add(ElementOfRecipe(
            null, amount, ingredient, unit, ingredient.id, unit.id));
      }
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
      _ingredientCreationAmount.clear();
    });
  }
}
