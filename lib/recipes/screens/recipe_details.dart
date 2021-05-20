import 'dart:convert';

import 'package:SweetLife/model/recipe.dart';
import 'package:SweetLife/providers/auth_provider.dart';
import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_modification.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecipeDetails extends StatefulWidget {
  static const routeName = '/recipe-details';

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool _isInited = false;
  bool _isLoading = false;

  // String commentValue;
  TextEditingController _commentValueController = TextEditingController();
  TextEditingController _rateValueController = TextEditingController();
  double _rate = 3;

  //fetched data
  Recipe recipe;

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      setState(() {
        _isLoading = true;
      });
      _isInited = true;
      final String recipeId =
          ModalRoute.of(context).settings.arguments as String;

      Provider.of<RecipesProvider>(context).fetchRecipeById(recipeId).then((_) {
        setState(() {
          _isLoading = false;
          recipe = Provider.of<RecipesProvider>(context, listen: false)
              .fetchedRecipeById;
          if (_didLoggedUserRatedRecipe()) {
            _rate = _getLoggedUserRate();
          } else {
            _rate = 3.0;
          }
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Details"),
        actions: [
          !_isLoading && _isOwner()
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(RecipeModification.routeName,
                            arguments: recipe.id)
                        .then((_) {
                      setState(() {
                        _isInited = false;
                        _isLoading = false;
                      });
                    });
                  })
              : Container()
        ],
      ),
      // drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  /* images */
                  //https://pub.dev/packages/carousel_slider/example
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        pageViewKey: PageStorageKey<String>('carousel_slider'),
                      ),
                      items: imageSliders(recipe.photos),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /* recipe name */
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /* Rates and Comments */
                  Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(recipe.comments.length.toString()),
                                Text(" "),
                                Icon(Icons.comment_rounded),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(recipe.rates.length != 0
                                    ? (recipe.rates
                                                .map((e) => e.rate)
                                                .reduce((a, b) => a + b) /
                                            recipe.rates.length)
                                        .toString()
                                    : "No rates"),
                                Text(" "),
                                Icon(Icons.favorite),
                              ],
                            ),
                          ],
                        ),
                        Provider.of<AuthProvider>(context, listen: false).isAuth
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                    onPressed: _addComment,
                                    child: Text("Add comment"),
                                  ),
                                  //TODO display current rate if logged user already rated recipe
                                  RaisedButton(
                                    onPressed: _addRate,
                                    child: _didLoggedUserRatedRecipe()
                                        ? Text(
                                            "Change current rate ${_getLoggedUserRate()}")
                                        : Text("Add rate"),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),

                  /* preparation time */
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.access_time_rounded),
                      title: Text("Preparation time"),
                      subtitle:
                          Text("${recipe.preparationTime.toString()} min"),
                    ),
                  ),

                  /* ingredients */
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_basket_rounded),
                      title: Text("Ingredients"),
                      subtitle: Column(
                        children: [
                          ...recipe.recipeElements.map((element) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                      "${element.amount} ${element.unitName} "),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text("${element.ingredientName}"),
                                )
                              ],
                            );
                          })
                        ],
                      ),
                    ),
                  ),

                  /* confectionery types */
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.fastfood_rounded),
                      title: Text("Confectionery Types"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...recipe.confectioneryTypes
                              .map((confectioneryTypes) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(confectioneryTypes.name),
                            );
                          })
                        ],
                      ),
                    ),
                  ),

                  /* Preparation description */
                  Card(
                    child: ListTile(
                        leading: Icon(Icons.architecture),
                        title: Text(
                          "Directions",
                        ),
                        subtitle: Text(recipe.description, softWrap: true)),
                  ),

                  /* Comments */
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.comment),
                      title: Text("Comments"),
                      subtitle: recipe.comments.isEmpty
                          ? Text("No comments")
                          : Column(
                              children: [
                                ...recipe.comments.map((comment) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(comment.userLogin),
                                        subtitle: Text(comment.content),
                                        trailing: Text(
                                          DateFormat.yMMMd()
                                              .format(comment.auditCD),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                })
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  List<Widget> imageSliders(List<String> photos) {
    if(photos.isEmpty)
      return [Image.network(
        "https://inzynieriaprocesow.pl/wp-content/themes/consultix/images/no-image-found-360x250.png",
        fit: BoxFit.cover,
      )];

    return photos
        .map((photo) => Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child:
                    // Image.network(photo, fit: BoxFit.cover, width: 1000.0),
                    Image.memory(base64Decode(photo),
                        fit: BoxFit.cover, width: 1000.0),
              ),
            ))
        .toList();
  }

  void _addComment() async {
    final commentValue = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Recipe comment"),
              content: TextField(
                controller: _commentValueController,
                decoration: InputDecoration(hintText: "Comment"),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(_commentValueController.text);
                  },
                  child: Text("Save comment"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(null);
                  },
                  child: Text("Cancel"),
                  textColor: Colors.grey,
                ),
              ],
            ));

    if (commentValue != null) {
      await Provider.of<RecipesProvider>(context, listen: false)
          .addCommentToRecipe(recipe.id, commentValue);

      await Provider.of<RecipesProvider>(context, listen: false)
          .fetchRecipeById(recipe.id);

      setState(() {
        recipe = Provider.of<RecipesProvider>(context, listen: false)
            .fetchedRecipeById;
      });
    }
  }

  void _addRate() async {
    final rateValue = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Recipe rate"),
              /*content:
                  TextField(
            controller: _rateValueController,
            decoration: InputDecoration(hintText: "Rate"),
            keyboardType: TextInputType.number,
          ),*/
              content: RatingBar.builder(
                initialRating: _rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  setState(() {
                    _rate = rating;
                  });
                },
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(_rate);
                  },
                  child: Text("Save rate"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(null);
                  },
                  child: Text("Cancel"),
                  textColor: Colors.grey,
                ),
              ],
            ));

    if (rateValue != null) {
      await Provider.of<RecipesProvider>(context, listen: false)
          .addRateToRecipe(recipe.id, rateValue);

      await Provider.of<RecipesProvider>(context, listen: false)
          .fetchRecipeById(recipe.id);

      setState(() {
        recipe = Provider.of<RecipesProvider>(context, listen: false)
            .fetchedRecipeById;
      });
    }
  }

  bool _didLoggedUserRatedRecipe() {
    return Provider.of<AuthProvider>(context, listen: false).isAuth &&
        recipe.rates.isNotEmpty &&
        recipe.rates.map((rate) => rate.userLogin).toList().contains(
            Provider.of<AuthProvider>(context, listen: false).loggedUser.email);
  }

  double _getLoggedUserRate() {
    String loggedUserLogin =
        Provider.of<AuthProvider>(context, listen: false).loggedUser.email;
    return recipe.rates
        .firstWhere((rate) => rate.userLogin == loggedUserLogin)
        .rate;
  }

  bool _isOwner() {
    return Provider.of<AuthProvider>(context, listen: false).isAuth &&
        recipe.auditCU ==
            Provider.of<AuthProvider>(context, listen: false).loggedUser.id;
  }
}
