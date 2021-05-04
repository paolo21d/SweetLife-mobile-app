import 'package:SweetLife/model/recipe_description.dart';
import 'package:SweetLife/providers/auth_provider.dart';
import 'package:SweetLife/providers/recipes_provider.dart';
import 'package:SweetLife/providers/shopping_lists_provider.dart';
import 'package:SweetLife/recipes/screens/recipe_creation.dart';
import 'package:SweetLife/recipes/screens/recipe_details.dart';
import 'package:SweetLife/recipes/screens/recipe_search.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_creation.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_details.dart';
import 'package:SweetLife/shopping_list/screens/shopping_list_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SweetLifeApp());
}

class SweetLifeApp extends StatelessWidget {
  // This widget is the root of your application.
  final RecipeDescription rec1 = RecipeDescription(
      1,
      "Rec1",
      "desc1",
      1,
      "https://assets.tmecosys.com/image/upload/t_web667x528/img/recipe/ras/Assets/5e057cbe-e64e-484b-b8e2-19c9c74ddcd2/Derivates/0702d718-d752-447c-a1b2-c8b35fc71643.jpg",
      2.5,
      20);
  final RecipeDescription rec2 = RecipeDescription(
      2,
      "Rec2",
      "desc2",
      2,
      "https://assets.tmecosys.com/image/upload/t_web667x528/img/recipe/ras/Assets/5e057cbe-e64e-484b-b8e2-19c9c74ddcd2/Derivates/0702d718-d752-447c-a1b2-c8b35fc71643.jpg",
      2.5,
      20);
  List<RecipeDescription> recDesc = [];

  @override
  Widget build(BuildContext context) {
    recDesc.add(rec1);
    recDesc.add(rec2);
    recDesc.add(rec1);
    recDesc.add(rec2);
    recDesc.add(rec1);
    recDesc.add(rec2);
    recDesc.add(rec1);
    recDesc.add(rec2);
    recDesc.add(rec1);
    recDesc.add(rec2);
    recDesc.add(rec1);
    recDesc.add(rec2);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        /*ChangeNotifierProxyProvider<AuthProvider, RecipesProvider>(
          builder: (ctx, auth, _) => RecipesProvider(auth.token, auth.userId),
        )*/
        ChangeNotifierProvider.value(
          value: RecipesProvider("token", "userId"),
        ),
        ChangeNotifierProvider.value(
          value: ShoppingListsProvider("token", "userId"),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.amberAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: Colors.white),
          home: RecipeSearch(recDesc),
          routes: {
            RecipeCreation.routeName: (ctx) => RecipeCreation(),
            RecipeDetails.routeName: (ctx) => RecipeDetails(),
            RecipeSearch.routeName: (ctx) => RecipeSearch(recDesc),
            ShoppingListCreation.routeName: (ctx) => ShoppingListCreation(),
            ShoppingListDetails.routeName: (ctx) => ShoppingListDetails(),
            ShoppingListOverview.routeName: (ctx) => ShoppingListOverview(),
          },
          // home: RecipeDetails(),
          // home: RecipeCreation(),
          // home: RecipeSearch(recDesc),
          // home: ShoppingListOverview(),
          // home: ShoppingListCreation(),
          // home: ShoppingListDetails(),
        ),
      ),
    );
  }
}
