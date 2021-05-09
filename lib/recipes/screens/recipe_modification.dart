import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:SweetLife/model/confectionery_type.dart';
import 'package:SweetLife/model/element_of_recipe.dart';
import 'package:SweetLife/model/ingredient.dart';
import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/model/unit.dart';
import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_details.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app_drawer.dart';

class RecipeModification extends StatefulWidget {
  static const routeName = '/recipe-modification';

  @override
  _RecipeModificationState createState() => _RecipeModificationState();
}

class _RecipeModificationState extends State<RecipeModification> {
  final _preparationTimeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  bool isValidIngredients = true;
  bool isValidConfectioneryType = true;

  // ingredient creation data
  TextEditingController _ingredientCreationAmount = TextEditingController();
  String choosedIngredientName;
  String choosedUnitName;

  //creating Recipe data
  String creatingName;
  int creatingPreparationTime;
  String creatingDescription;
  List<String> addedPhotos = <String>[];
  Map<String, bool> checkedConfectioneryTypes = <String, bool>{};
  List<ElementOfRecipe> addedIngredients = [];

  bool _isInited = false;
  var _isLoading = false;
  String _initRecipeNameValue = "";
  String _initRecipeDescriptionValue = "";
  String _initRecipePreparationTimeValue = "";

  // fetched data
  List<ConfectioneryType> availableConfectioneryTypes = [];
  List<Ingredient> availableIngredients = [];
  List<Unit> availableUnits = [];
  Recipe modifyingRecipe;

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      _isInited = true;

      String modifyingRecipeId =
          ModalRoute.of(context).settings.arguments as String;

      Provider.of<RecipesProvider>(context)
          .fetchDataToRecipeModification(modifyingRecipeId)
          .then((_) {
        setState(() {
          _isLoading = false;
          availableIngredients =
              Provider.of<RecipesProvider>(context, listen: false)
                  .allIngredients;
          availableConfectioneryTypes =
              Provider.of<RecipesProvider>(context, listen: false)
                  .allConfectioneryTypes;
          availableUnits =
              Provider.of<RecipesProvider>(context, listen: false).allUnits;

          //set previous recipe values
          modifyingRecipe = Provider.of<RecipesProvider>(context, listen: false)
              .fetchedRecipeById;
          addedIngredients = modifyingRecipe.recipeElements;
          addedPhotos = modifyingRecipe.photos;
          //TODO set name, description, preparation time
          _initRecipeNameValue = modifyingRecipe.name;
          _initRecipeDescriptionValue = modifyingRecipe.description;
          _initRecipePreparationTimeValue =
              modifyingRecipe.preparationTime.toString();

          _prepareCheckedConfectioneryTypes(modifyingRecipe.confectioneryTypes);
        });
      });
    }

    super.didChangeDependencies();
  }

  //nazwa, czas przygotowania, opis, image picker, skladniki, typ przepisu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe Modification"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveRecipe,
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                              initialValue: _initRecipeNameValue,
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
                              },
                              onSaved: (value) => creatingName = value,
                            ),

                            // preparation time
                            TextFormField(
                              initialValue: _initRecipePreparationTimeValue,
                              decoration: InputDecoration(
                                  labelText: 'Preparation time'),
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
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number.';
                                }
                                if (int.parse(value) <= 0) {
                                  return 'Please enter a number greater than zero.';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  creatingPreparationTime = int.parse(value),
                            ),

                            //description
                            TextFormField(
                              initialValue: _initRecipeDescriptionValue,
                              decoration:
                                  InputDecoration(labelText: 'Description'),
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
                              onSaved: (value) => creatingDescription = value,
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
                                      pageViewKey: PageStorageKey<String>(
                                          'carousel_slider'),
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
                            !isValidIngredients
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Invalid ingredients",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFD32F2F)),
                                    ),
                                  )
                                : Center(),
                            ...addedIngredients.map((ingredient) {
                              return ListTile(
                                title: Text(ingredient.ingredientName),
                                subtitle: Text(
                                    "${ingredient.amount} ${ingredient.unitName}"),
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
                              !isValidConfectioneryType
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Invalid confectionery types",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFFD32F2F)),
                                      ),
                                    )
                                  : Center(),
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

  void _prepareCheckedConfectioneryTypes(
      List<ConfectioneryType> modifyingRecipeConfectioneryTypes) {
    checkedConfectioneryTypes = <String, bool>{};
    for (ConfectioneryType type in availableConfectioneryTypes) {
      checkedConfectioneryTypes.putIfAbsent(type.id, () {
        if (modifyingRecipeConfectioneryTypes
            .where((element) => element.id == type.id)
            .isNotEmpty) {
          return true;
        }
        return false;
        // return modifyingRecipeConfectioneryTypes.contains(type);
      });
      // checkedConfectioneryTypes[type.id] = false;
    }
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    String imageInBase64 = base64Encode(image.readAsBytesSync());
    setState(() {
      if (image != null) {
        addedPhotos.add(imageInBase64);
      }
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    String imageInBase64 = base64Encode(image.readAsBytesSync());
    setState(() {
      if (image != null) {
        addedPhotos.add(imageInBase64);
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
    return addedPhotos.map((photo) {
      return Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Image.memory(
                    base64Decode(photo),
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
                              addedPhotos
                                  .removeWhere((element) => element == photo);
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
        addedIngredients
            .add(ElementOfRecipe(ingredient.name, amount, unit.name));
      }
      choosedIngredientName = availableIngredients[0].name;
      choosedUnitName = availableUnits[0].name;
      _ingredientCreationAmount.clear();
    });
  }

  Future<void> _saveRecipe() async {
    bool isValid = validateForm();
    //  TODO validate form
    if (isValid) {
      _form.currentState.save();
      /*setState(() {
        _isLoading = true;
      });*/

      List<ConfectioneryType> creatingConfectioneryTypes = [];
      checkedConfectioneryTypes.forEach((typeId, typeValue) {
        if (typeValue) {
          creatingConfectioneryTypes.add(availableConfectioneryTypes
              .firstWhere((element) => element.id == typeId));
        }
      });

      modifyingRecipe.name = creatingName;
      modifyingRecipe.description = creatingDescription;
      modifyingRecipe.preparationTime = creatingPreparationTime;
      modifyingRecipe.photos = addedPhotos;
      modifyingRecipe.recipeElements = addedIngredients;
      modifyingRecipe.confectioneryTypes = creatingConfectioneryTypes;
      // log(creatingRecipe.toJson());

      try {
        await Provider.of<RecipesProvider>(context, listen: false)
            .updateRecipe(modifyingRecipe);

        log("Updated Recipe with id: ${modifyingRecipe.id}");

        // TODO fix redirect to created recipe to RecipeDetailsScreen (on RecipeDetails after click return we come back to RecipeCreationScreen)
        Navigator.of(context).popAndPushNamed(
          RecipeDetails.routeName,
          arguments: modifyingRecipe.id,
        );
        /*Navigator.of(context).pushNamedAndRemoveUntil(RecipeDetails.routeName,
            ModalRoute.withName(RecipeSearch.routeName),
            arguments: modifyingRecipe.id);*/
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

  bool validateForm() {
    bool isValidNameTimeDescription = _form.currentState.validate();
    setState(() {
      isValidIngredients = addedIngredients.isNotEmpty;
      isValidConfectioneryType = checkedConfectioneryTypes.containsValue(true);
    });

    return isValidNameTimeDescription &&
        isValidIngredients &&
        isValidConfectioneryType;
  }
}
