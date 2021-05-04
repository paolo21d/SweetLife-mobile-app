import 'package:flutter/material.dart';

class ShoppingListsProvider extends ChangeNotifier {
  final String authToken;
  final String userId;

  ShoppingListsProvider(this.authToken, this.userId);
}
